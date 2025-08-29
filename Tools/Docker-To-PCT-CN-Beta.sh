#!/bin/bash
# Make by lurenjbd 2025-04-16
# Edited 2025-04-19
# Turn docker image to PCT template.

log_info() {
	echo -e "\033[0;32m[信息]\033[0m $1"
}

log_warn() {
	echo -e "\033[0;33m[警告]\033[0m $1"
}

log_error() {
	echo -e "\033[0;31m[错误]\033[0m $1"
	exit 1
}

check_and_install() {
	command -v $1 >/dev/null 2>&1 || { 
		log_info "正在安装 $1..."
		apt install $1 -y || log_error "安装 $1 失败"
	}
}

prepare_environment() {
	if [ -f "/usr/share/lxc/templates/lxc-oci" ]; then
		sed -i 's/set -eu/set -u/g' /usr/share/lxc/templates/lxc-oci
	fi

	check_and_install skopeo
	check_and_install umoci
	check_and_install jq
}

parse_docker_image() {
	local input=$1
	
	if [[ $input == *"docker pull"* ]]; then
		echo $input | sed 's/docker pull //'
	else
		echo $input
	fi
}

check_duplicate_filename() {
	local file_path=$1
	local base_dir=$(dirname "$file_path")
	local filename=$(basename "$file_path")
	
	if [[ "$filename" == *.tar.gz ]]; then
		local name="${filename%.tar.gz}"
		local ext="tar.gz"
	else
		local name="${filename%.*}"
		local ext="${filename##*.}"
	fi
	
	local counter=1
	local new_path="$file_path"
	
	while [ -e "$new_path" ]; do
		log_warn "文件 $new_path 已存在" >&2
		new_path="${base_dir}/${name}-${counter}.${ext}"
		counter=$((counter+1))
	done
	
	if [ "$new_path" != "$file_path" ]; then
		log_info "将使用新文件名: $(basename "$new_path")" >&2
	fi
	
	echo "$new_path"
}

process_container_config() {
	local config_file=$1
	local output_file=$2
	local docker_image=$3
	
	if [ ! -f "$config_file" ]; then
		log_error "配置文件 $config_file 不存在"
	fi

	local output_dir=$(dirname "$output_file")
	if [ ! -d "$output_dir" ]; then
		mkdir -p "$output_dir"
	fi

	local execute_cmd=$(grep "^lxc.execute.cmd" "$config_file" | awk -F"'" '{print $2}' | tr -d '"')
	if [ -n "$execute_cmd" ]; then
		echo "lxc.init.cmd = $execute_cmd" | grep -v "=$" | grep -v "= $" >> "$output_file"
	fi

	grep "^lxc.mount.auto" "$config_file" | grep -v "=$" | grep -v "= $" >> "$output_file"

	grep "^lxc.environment" "$config_file" | grep -v "=$" | grep -v "= $" >> "$output_file"

	grep "^lxc.uts.name" "$config_file" | grep -v "=$" | grep -v "= $" >> "$output_file"

	if [[ $docker_image == *"redroid"* ]]; then
		log_info "检测到redroid容器，添加特殊参数..."
		echo "lxc.mount.entry = /dev/fuse dev/fuse none bind,create=file" >> "$output_file"
		echo "lxc.apparmor.profile = unconfined" >> "$output_file"
		echo "lxc.autodev = 1" >> "$output_file"
		echo "lxc.autodev.tmpfs.size = 25000000" >> "$output_file"
	fi

	log_info "配置已成功写入 $output_file"
}

package_container() {
	local docker_name=$1
	
	log_info "正在查找支持存储模板的存储池..."
	
	local template_storage=""
	local template_path=""
	local available_storages=()
	local available_paths=()
	
	if [ -f "/etc/pve/storage.cfg" ]; then
		local storage_type=""
		local storage_name=""
		local storage_path=""
		local has_vztmpl=false
		
		while IFS= read -r line; do
			if [[ $line =~ ^([a-zA-Z0-9]+):\ ([a-zA-Z0-9_-]+) ]]; then
				if [ "$has_vztmpl" = true ] && [ -n "$storage_path" ]; then
					available_storages+=("$storage_name")
					available_paths+=("${storage_path}/template/cache")
				fi
				
				storage_type="${BASH_REMATCH[1]}"
				storage_name="${BASH_REMATCH[2]}"
				storage_path=""
				has_vztmpl=false
			elif [[ $line =~ path\ (.+) ]]; then
				storage_path="${BASH_REMATCH[1]}"
			elif [[ $line =~ content.*vztmpl.* ]]; then
				has_vztmpl=true
			fi
		done < "/etc/pve/storage.cfg"
		
		if [ "$has_vztmpl" = true ] && [ -n "$storage_path" ]; then
			available_storages+=("$storage_name")
			available_paths+=("${storage_path}/template/cache")
		fi
	fi
	
	if [ ${#available_storages[@]} -gt 0 ]; then
		log_info "找到以下支持存储模板的存储池:"
		for i in "${!available_storages[@]}"; do
			echo "[$i] ${available_storages[$i]}: ${available_paths[$i]}"
		done
		
		local choice=""
		while true; do
			read -p "请选择要使用的存储池 [0-$((${#available_storages[@]}-1))]: " choice
			
			if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -lt "${#available_storages[@]}" ]; then
				template_storage="${available_storages[$choice]}"
				template_path="${available_paths[$choice]}"
				break
			else
				log_warn "无效选择，请重试"
			fi
		done
		
		log_info "选择存储池 $template_storage: $template_path"
		
		if [ ! -d "$template_path" ]; then
			mkdir -p "$template_path" || log_error "无法创建目录 $template_path"
		fi

		log_info "正在打包rootfs为压缩包..."
		local tar_file="${docker_name}.tar.gz"
		
		if command -v pigz >/dev/null 2>&1; then
			log_info "使用多线程压缩 (pigz)..."
			tar --exclude=dev --exclude=sys --exclude=proc -cf - -C /var/lib/lxc/$docker_name/rootfs/ . | pigz -p $(($(nproc) - 1)) > "$tar_file" || log_error "打包rootfs失败"
		else
			log_info "使用单线程压缩。若需更快压缩，请安装pigz ('apt install pigz')..."
			tar --exclude=dev --exclude=sys --exclude=proc -czf "$tar_file" -C /var/lib/lxc/$docker_name/rootfs/ . || log_error "打包rootfs失败"
		fi

		local target_file="${template_path}/${tar_file}"
		local new_target_file=$(check_duplicate_filename "$target_file")
		
		log_info "正在移动压缩包到PVE模板缓存目录..."
		mv "$tar_file" "$new_target_file" 2>/dev/null || log_error "移动压缩包失败"
		
		log_info "容器 $docker_name 已成功打包并移动到 $new_target_file"
		
		local delete_choice=""
		while true; do
			read -p "是否删除临时容器 $docker_name? (y/n): " delete_choice
			case $delete_choice in
				[Yy]* )
					log_info "正在删除临时容器..."
					lxc-destroy -n "$docker_name" && log_info "容器 $docker_name 已删除" || log_warn "删除容器 $docker_name 失败"
					break
					;;
				[Nn]* )
					log_info "保留临时容器 $docker_name"
					break
					;;
				* )
					log_warn "请输入 y 或 n"
					;;
			esac
		done
	else
		log_error "未找到支持模板的存储池，无法继续。请确保至少有一个存储池配置了 vztmpl 内容类型。"
	fi
	check_and_clean_cache
}

check_and_clean_cache() {
	local cache_dir="/var/cache/lxc/sha256"
	if [ -d "$cache_dir" ]; then
		local cache_size=$(du -sb "$cache_dir" | awk '{print $1}')
		local cache_size_mb=$((cache_size / 1024 / 1024))
		if [ $cache_size_mb -gt 1024 ]; then
			log_warn "OCI缓存大小已超过1GB（当前${cache_size_mb}MB）"
			local clean_choice=""
			while true; do
				read -p "是否清理OCI缓存目录 /var/cache/lxc/sha256 ? (y/n): " clean_choice
				case $clean_choice in
					[Yy]* )
						log_info "正在清理OCI缓存目录..."
						rm -f $cache_dir/* && log_info "OCI缓存已清理" || log_warn "清理OCI缓存失败"
						break
						;;
					[Nn]* )
						log_info "保留OCI缓存"
						break
						;;
					* )
						log_warn "请输入 y 或 n"
						;;
				esac
			done
		fi
	fi
}

main() {
	if [ $# -ne 1 ]; then
		log_info "用法: $0 <docker镜像名称>"
		log_info "例如: $0 'docker pull redroid/redroid:12.0.0-latest'"
		log_info "或者: $0 'redroid/redroid:12.0.0-latest'"
		exit 1
	fi

	prepare_environment

	local docker_image=$(parse_docker_image "$1")
	
	local docker_name=$(echo $docker_image | sed 's/\//-/g' | sed 's/:/-/g')
	
	local docker_registry="docker.io"
	if [ -n "${DOCKER_REGISTRY_URL}" ]; then
		docker_registry=$(echo "${DOCKER_REGISTRY_URL}" | sed -E 's|^(https?://)?(.*?)/?$|\2|')
	fi
	local docker_url="docker://${docker_registry}/${docker_image}"

	log_info "Docker镜像: $docker_image"
	log_info "容器名称: $docker_name"
	log_info "Docker镜像源: $docker_registry"
	log_info "Docker URL: $docker_url"

	if [ -d "/var/lib/lxc/$docker_name" ]; then
		log_warn "容器 $docker_name 已存在"
		local use_existing=""
		while true; do
			read -p "是否直接打包已有容器? (y/n, n将尝试创建新容器): " use_existing
			case $use_existing in
				[Yy]* )
					log_info "使用已有容器: $docker_name"
					break
					;;
				[Nn]* )
					local rename_existing=""
					read -p "要重命名现有容器还是删除它? (r=重命名/d=删除): " rename_existing
					case $rename_existing in
						[Rr]* )
							local new_name=""
							read -p "请输入新名称: " new_name
							if [ -z "$new_name" ] || [ -d "/var/lib/lxc/$new_name" ]; then
								log_error "新名称为空或容器已存在: $new_name"
							fi
							log_info "将创建名字为 $new_name 的容器"
							docker_name=$new_name
							break
							;;
						[Dd]* )
							log_info "正在删除已有容器..."
							lxc-destroy -n "$docker_name" || log_error "删除容器失败"
							log_info "容器已删除"
							break
							;;
						* )
							log_warn "请输入 r 或 d"
							;;
					esac
					;;
				* )
					log_warn "请输入 y 或 n"
					;;
			esac
		done
	fi

	local config_file="/var/lib/lxc/$docker_name/config"
	local output_file="/var/lib/lxc/$docker_name/rootfs/oci-config"

	if [ ! -d "/var/lib/lxc/$docker_name" ]; then
		log_info "正在创建容器..."
		lxc-create -n $docker_name -t oci -- -u $docker_url || log_error "创建容器 $docker_name 失败"
		process_container_config "$config_file" "$output_file" "$docker_image"
	fi

	package_container "$docker_name"
}

main "$@"

