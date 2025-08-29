#!/bin/bash
# Made by lurenjbd 2025-04-16
# Edited 2025-04-19
# Turn docker image to PCT template.

log_info() {
	echo -e "\033[0;32m[INFO]\033[0m $1"
}

log_warn() {
	echo -e "\033[0;33m[WARNING]\033[0m $1"
}

log_error() {
	echo -e "\033[0;31m[ERROR]\033[0m $1"
	exit 1
}

check_and_install() {
	command -v $1 >/dev/null 2>&1 || { 
		log_info "Installing $1..."
		apt install $1 -y || log_error "Failed to install $1"
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
		log_warn "File $new_path already exists" >&2
		new_path="${base_dir}/${name}-${counter}.${ext}"
		counter=$((counter+1))
	done
	
	if [ "$new_path" != "$file_path" ]; then
		log_info "Using new filename: $(basename "$new_path")" >&2
	fi
	
	echo "$new_path"
}

process_container_config() {
	local config_file=$1
	local output_file=$2
	local docker_image=$3
	
	if [ ! -f "$config_file" ]; then
		log_error "Configuration file $config_file does not exist"
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
		log_info "Detected redroid container, adding special parameters..."
		echo "lxc.mount.entry = /dev/fuse dev/fuse none bind,create=file" >> "$output_file"
		echo "lxc.apparmor.profile = unconfined" >> "$output_file"
		echo "lxc.autodev = 1" >> "$output_file"
		echo "lxc.autodev.tmpfs.size = 25000000" >> "$output_file"
	fi

	log_info "Configuration successfully written to $output_file"
}

package_container() {
	local docker_name=$1
	
	log_info "Looking for storage pools that support templates..."
	
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
		log_info "Found the following storage pools supporting templates:"
		for i in "${!available_storages[@]}"; do
			echo "[$i] ${available_storages[$i]}: ${available_paths[$i]}"
		done
		
		local choice=""
		while true; do
			read -p "Please select a storage pool to use [0-$((${#available_storages[@]}-1))]: " choice
			
			if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -lt "${#available_storages[@]}" ]; then
				template_storage="${available_storages[$choice]}"
				template_path="${available_paths[$choice]}"
				break
			else
				log_warn "Invalid selection, please try again"
			fi
		done
		
		log_info "Selected storage pool $template_storage: $template_path"
		
		if [ ! -d "$template_path" ]; then
			mkdir -p "$template_path" || log_error "Cannot create directory $template_path"
		fi

		log_info "Packaging rootfs into a compressed archive..."
		local tar_file="${docker_name}.tar.gz"
		
		if command -v pigz >/dev/null 2>&1; then
			log_info "Using multi-threaded compression (pigz)..."
			tar --exclude=dev --exclude=sys --exclude=proc -cf - -C /var/lib/lxc/$docker_name/rootfs/ . | pigz -p $(($(nproc) - 1)) > "$tar_file" || log_error "Failed to package rootfs"
		else
			log_info "Using single-threaded compression. For faster compression, install pigz ('apt install pigz')..."
			tar --exclude=dev --exclude=sys --exclude=proc -czf "$tar_file" -C /var/lib/lxc/$docker_name/rootfs/ . || log_error "Failed to package rootfs"
		fi

		local target_file="${template_path}/${tar_file}"
		local new_target_file=$(check_duplicate_filename "$target_file")
		
		log_info "Moving the compressed archive to PVE template cache directory..."
		mv "$tar_file" "$new_target_file" 2>/dev/null || log_error "Failed to move the compressed archive"
		
		log_info "Container $docker_name has been successfully packaged and moved to $new_target_file"
		
		local delete_choice=""
		while true; do
			read -p "Delete temporary container $docker_name? (y/n): " delete_choice
			case $delete_choice in
				[Yy]* )
					log_info "Deleting temporary container..."
					lxc-destroy -n "$docker_name" && log_info "Container $docker_name has been deleted" || log_warn "Failed to delete container $docker_name"
					break
					;;
				[Nn]* )
					log_info "Keeping temporary container $docker_name"
					break
					;;
				* )
					log_warn "Please enter y or n"
					;;
			esac
		done
	else
		log_error "No storage pools that support templates were found. Cannot continue. Please ensure at least one storage pool is configured with the vztmpl content type."
	fi
	check_and_clean_cache
}

check_and_clean_cache() {
	local cache_dir="/var/cache/lxc/sha256"
	if [ -d "$cache_dir" ]; then
		local cache_size=$(du -sb "$cache_dir" | awk '{print $1}')
		local cache_size_mb=$((cache_size / 1024 / 1024))
		if [ $cache_size_mb -gt 1024 ]; then
			log_warn "OCI cache size has exceeded 1GB (currently ${cache_size_mb}MB)"
			local clean_choice=""
			while true; do
				read -p "Clean OCI cache directory /var/cache/lxc/sha256? (y/n): " clean_choice
				case $clean_choice in
					[Yy]* )
						log_info "Cleaning OCI cache directory..."
						rm -f $cache_dir/* && log_info "OCI cache has been cleaned" || log_warn "Failed to clean OCI cache"
						break
						;;
					[Nn]* )
						log_info "Keeping OCI cache"
						break
						;;
					* )
						log_warn "Please enter y or n"
						;;
				esac
			done
		fi
	fi
}

main() {
	if [ $# -ne 1 ]; then
		log_info "Usage: $0 <docker image name>"
		log_info "Example: $0 'docker pull redroid/redroid:12.0.0-latest'"
		log_info "Or: $0 'redroid/redroid:12.0.0-latest'"
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

	log_info "Docker image: $docker_image"
	log_info "Container name: $docker_name"
	log_info "Docker registry: $docker_registry"
	log_info "Docker URL: $docker_url"

	if [ -d "/var/lib/lxc/$docker_name" ]; then
		log_warn "Container $docker_name already exists"
		local use_existing=""
		while true; do
			read -p "Package the existing container directly? (y/n, n will attempt to create a new container): " use_existing
			case $use_existing in
				[Yy]* )
					log_info "Using existing container: $docker_name"
					break
					;;
				[Nn]* )
					local rename_existing=""
					read -p "Rename the existing container or delete it? (r=rename/d=delete): " rename_existing
					case $rename_existing in
						[Rr]* )
							local new_name=""
							read -p "Enter new name: " new_name
							if [ -z "$new_name" ] || [ -d "/var/lib/lxc/$new_name" ]; then
								log_error "New name is empty or container already exists: $new_name"
							fi
							log_info "Will create container with name $new_name"
							docker_name=$new_name
							break
							;;
						[Dd]* )
							log_info "Deleting existing container..."
							lxc-destroy -n "$docker_name" || log_error "Failed to delete container"
							log_info "Container has been deleted"
							break
							;;
						* )
							log_warn "Please enter r or d"
							;;
					esac
					;;
				* )
					log_warn "Please enter y or n"
					;;
			esac
		done
	fi

	local config_file="/var/lib/lxc/$docker_name/config"
	local output_file="/var/lib/lxc/$docker_name/rootfs/oci-config"

	if [ ! -d "/var/lib/lxc/$docker_name" ]; then
		log_info "Creating container..."
		lxc-create -n $docker_name -t oci -- -u $docker_url || log_error "Failed to create container $docker_name"
		process_container_config "$config_file" "$output_file" "$docker_image"
	fi

	package_container "$docker_name"
}

main "$@" 