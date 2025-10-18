#!/bin/bash
# Make by lurenjbd 2025-02-10
# Version 2.1
# Edited 2025-08-26
# Patch to make PCT support OCI.

########### Variable ###########

MIN_VERSION="8.2.0"
RESTORE_MODE=0
SKIP_CONFIRM=0
DEL_BACKUP=0
LANGUAGE="zh_cn"

# Color code
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' 

#  Patches BASE64
PATCH_BASE64='
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
azPtMsukFAaQGn/n'

########### Function ###########
show_usage() {
	echo -e "${BLUE}==========================================================${NC}"
	echo -e "${BLUE}                 PVE OCI Support Patch Tool${NC}"
	echo -e "${BLUE}==========================================================${NC}"
	echo -e "用法 (Usage): $0 [选项 (Options)]"
	echo ""
	echo -e "选项 (Options):"
	echo -e "  -h, --help       显示此帮助信息 (Show this help message)"
	echo -e "  -R, --restore    恢复原始文件 (Restore original files)"
	echo -e "  -D, --del-backup 恢复后删除备份文件 (Delete backup files after restore)"
	echo -e "  -y, --yes        跳过确认提示 (Skip confirmation prompts)"
	echo -e "  -c, --chinese    使用中文显示消息（默认）"
	echo -e "  -e, --english    Use English for messages"
	echo ""
	echo -e "${BLUE}==========================================================${NC}"
}

printf_msg() {
	local text_zh="$1"
	local text_en="$2"
	local type="${3:-INFO}"

	local color=$BLUE
	case "$type" in
		SUCCESS) color=$GREEN ;;
		WARNING) color=$YELLOW ;;
		ERROR) color=$RED ;;
		*) color=$BLUE ;;
	esac

	if [[ "$LANGUAGE" == "zh_cn" ]]; then
		echo -e "${color}${text_zh}${NC}"
	else
		echo -e "${color}${text_en}${NC}"
	fi
}

parse_arguments() {
	while [[ $# -gt 0 ]]; do
		case "$1" in
			-h|--help)
				show_usage
				exit 0
				;;
			-R|--restore)
				RESTORE_MODE=1
				shift
				;;
			-D|--del-backup)
				DEL_BACKUP=1
				shift
				;;
			-y|--yes)
				SKIP_CONFIRM=1
				shift
				;;
			-c|--chinese)
				LANGUAGE="zh_cn"
				shift
				;;
			-e|--english)
				LANGUAGE="en_us"
				shift
				;;
			*)
				printf_msg "错误: 未知选项 $1" \
					"Error: Unknown option $1" \
					"ERROR"
				show_usage
				exit 1
				;;
		esac
	done
}

generate_path() {
	CREATE_NEW_FILE=0

	local FIRST_LINE_PATH=$(awk 'NR==1 {print $2}' "$1")
	local SECOND_LINE_PATH=$(awk 'NR==2 {print $2}' "$1")

	if [[ "$FIRST_LINE_PATH" == "/dev/null" ]]; then
		CREATE_NEW_FILE=1
	fi

	if [[ ! "${SECOND_LINE_PATH}" =~ ^/ ]]; then
		printf_msg "无法从补丁中获取目标文件路径: $1" \
			"Cannot get target file path from patch: $1" \
			"ERROR"
		TARGET_FILE=''
		return 1
	fi

	TARGET_FILE="${SECOND_LINE_PATH}"
	return 0
}

check_ready() {
	generate_path "$1" || return 1

	BACKUP_FILE="$TARGET_FILE.bak-${BACKUP_FILE_SUFFIX}"

	if [ -e "$BACKUP_FILE" ]; then
		printf_msg "备份文件已存在: $BACKUP_FILE" \
			"Backup file already exists: $BACKUP_FILE" \
			"WARNING"
	elif [ -e "$TARGET_FILE" ]; then
		NEED_BACKUP_FILES+=("$TARGET_FILE")
	else
		if [[ "$CREATE_NEW_FILE" -eq 0 ]]; then
			printf_msg "未找到目标文件: $TARGET_FILE" \
				"Target file not found: $TARGET_FILE" \
				"ERROR"
			return 1
		fi
	fi

	TARGET_DIR=$(dirname "$TARGET_FILE")

	if [[ ! -d "$TARGET_DIR" && "$CREATE_NEW_FILE" -eq 1 ]]; then
		printf_msg "目标目录不存在，将创建: $TARGET_DIR" \
			"Target directory does not exist, will create: $TARGET_DIR" \
			"INFO"
		mkdir -p "$TARGET_DIR"
	fi

	PATCH_FILE="$1"
	if ! patch --dry-run -d "$TARGET_DIR" < "$PATCH_FILE" >/dev/null 2>&1; then
		printf_msg "补丁 $(basename ${PATCH_FILE}) 无法应用。请检查补丁文件和目标目录。" \
			"$(basename ${PATCH_FILE}) Patch cannot be apply. Please check the patch file and target directory." \
			"ERROR"
		patch --dry-run -d "$TARGET_DIR" < "$PATCH_FILE"
		return 1
	else
		if [[ "$CREATE_NEW_FILE" -eq 1 ]]; then
			printf_msg "将创建新文件: $TARGET_FILE" \
				"Will create new file: $TARGET_FILE" \
				"SUCCESS"
		else
			printf_msg "补丁 $(basename ${PATCH_FILE}) 可以成功应用" \
				"$(basename ${PATCH_FILE}) Patch can be apply successfully." \
				"SUCCESS"
		fi
		CHECK_PATCH_PASS+=("$1")
		return 0
	fi

	return 1
}

restore_patch(){
	generate_path "$1" || return 1

	BACKUP_FILE="$TARGET_FILE.bak-${BACKUP_FILE_SUFFIX}"

	if [[ "$CREATE_NEW_FILE" -eq 1 ]]; then
		if [ -e "$TARGET_FILE" ]; then
			rm -f "$TARGET_FILE"
			printf_msg "已删除新创建的文件 $TARGET_FILE" \
				"Deleted newly created file $TARGET_FILE" \
				"INFO"
		else
			printf_msg "文件不存在，无需删除: $TARGET_FILE" \
				"File does not exist, no need to delete: $TARGET_FILE" \
				"INFO"
		fi
	else
		TARGET_DIR=$(dirname "$TARGET_FILE")
		PATCH_FILE="$1"

		printf_msg "尝试反向应用补丁: $PATCH_FILE" \
			"Trying to reverse apply patch: $PATCH_FILE" \
			"INFO"

		if [ -e "$TARGET_FILE" ] && patch -R --dry-run -d "$TARGET_DIR" < "$PATCH_FILE" >/dev/null 2>&1; then
			patch -R -d "$TARGET_DIR" < "$PATCH_FILE" > /dev/null 2>&1
			printf_msg "成功反向应用补丁，恢复文件 $TARGET_FILE" \
				"Successfully reverse applied patch to restore $TARGET_FILE" \
				"SUCCESS"
			if [ -f "$TARGET_FILE.orig" ]; then
				printf_msg "清理 $TARGET_FILE.orig 文件" \
					"Cleaning up $TARGET_FILE.orig files" \
					"INFO"
				rm "$TARGET_FILE.orig"
			fi
			if [ "$DEL_BACKUP" -eq 1 ] && [ -e "$BACKUP_FILE" ]; then
				rm -f $BACKUP_FILE
				printf_msg "已删除备份文件 $BACKUP_FILE" \
					"Deleted backup file $BACKUP_FILE" \
					"SUCCESS"
			fi
		elif [ -e "$BACKUP_FILE" ]; then
			printf_msg "反向应用补丁失败，使用备份文件恢复" \
				"Reverse patch failed, using backup file to restore" \
				"WARNING"
			mv $BACKUP_FILE $TARGET_FILE
			printf_msg "成功恢复文件 $TARGET_FILE" \
				"Restore $TARGET_FILE file successfully." \
				"SUCCESS"
		else
			printf_msg "未找到备份文件 $BACKUP_FILE 且无法反向应用补丁" \
				"Backup file $BACKUP_FILE not found and cannot reverse apply patch." \
				"WARNING"
		fi
	fi

	return 0
}

arrays_equal() {
	local arr1=("${!1}")
	local arr2=("${!2}")

	[[ ${#arr1[@]} -ne ${#arr2[@]} ]] && return 1

	local sorted1=$(printf '%s\n' "${arr1[@]}" | sort)
	local sorted2=$(printf '%s\n' "${arr2[@]}" | sort)

	diff -u <(printf '%s\n' "$sorted1") <(printf '%s\n' "$sorted2") >/dev/null && return 0

	return 1
}

load_module() {
	local module=$1
	local params=$2
	local modules_file="/etc/modules"
	local modprobe_conf_file="/etc/modprobe.d/$module.conf"

	if ! modinfo "$module" &>/dev/null; then
		printf_msg "$module 模块不存在于内核中" \
			"$module module does not exist in the kernel" \
			"ERROR"
		return 1
	fi

	if ! lsmod | grep -q "$module"; then
		printf_msg "$module 模块未加载，正在加载..." \
			"$module is not loaded, loading module..." \
			"INFO"
		if [[ -n "$params" ]]; then
			modprobe "$module" $params
		else
			modprobe "$module"
		fi
	else
		printf_msg "$module 模块已加载" \
			"$module is already loaded." \
			"INFO"
	fi

	if ! grep -q "$module" "$modules_file"; then
		printf_msg "添加 $module 到 $modules_file" \
			"Adding $module to $modules_file" \
			"INFO"
		sed -i -e '$a\' "$modules_file"
		echo "$module" >> "$modules_file"
	fi
	if [[ -n "$params" && ! -f "$modprobe_conf_file" ]]; then
		echo "options $module $params" > "$modprobe_conf_file"
	fi
}

check_running_vms() {
	local running_vms=0
	local running_cts=0

	if command -v qm &> /dev/null; then
		running_vms=$(qm list | grep running | wc -l)
	fi

	if command -v pct &> /dev/null; then
		running_cts=$(pct list | grep running | wc -l)
	fi

	total=$((running_vms + running_cts))
	echo "$total"
}

cleanup() {
	rm -rf /tmp/patch_files.tar.gz /tmp/pve-dmabuf-patch
	if [ "$Need_RestartAPI" -eq 1 ]; then
		printf_msg "正在重启PVE Web界面服务..." \
			"Restarting PVE Web UI services..." \
			"INFO"
		systemctl restart pve{proxy,daemon,statd}.service
	fi
}
trap cleanup EXIT

read_user_input() {
	local prompt_zh="$1"
	local prompt_en="$2"
	local result

	if [[ "$LANGUAGE" == "zh_cn" ]]; then
		read -p "$prompt_zh" result
	else
		read -p "$prompt_en" result
	fi

	echo "$result"
}

########### Main ###########

PATCH_FILE_LIST=()
CHECK_PATCH_PASS=()
NEED_BACKUP_FILES=()
Need_RestartAPI=0

parse_arguments "$@"

if [ "$(uname -m)" != "x86_64" ]; then
	printf_msg "当前系统架构为 $(uname -m)，此脚本仅支持 x86_64 架构。" \
		"Current system architecture is $(uname -m). This script only supports x86_64." \
		"ERROR"
	exit 1
fi

if ! command -v pveversion &>/dev/null; then
	printf_msg "未检测到 pveversion 命令，请确认是否运行在 PVE 环境中。" \
		"pveversion command not found. Please ensure you are running in a PVE environment." \
		"ERROR"
	exit 1
fi

PVE_VERSION=$(pveversion | awk -F'/' '{print $2}' | awk -F'-' '{print $1}' 2>/dev/null)

if [[ "$(echo -e "$MIN_VERSION\n$PVE_VERSION" | sort -V | head -n1)" != "$MIN_VERSION" ]]; then
	printf_msg "当前PVE版本 $PVE_VERSION 低于 $MIN_VERSION。请升级PVE系统版本。" \
		"Current PVE version $PVE_VERSION is lower than $MIN_VERSION. Please upgrade the PVE system version." \
		"WARNING"
	exit 1
fi

if [[ "$SKIP_CONFIRM" -ne 1 ]]; then
	printf_msg "我已了解该脚本的作用，并自愿承担对应的风险。" \
		"I have understood the purpose of this script and voluntarily assume the corresponding risks." \
		"INFO"
	user_input=$(read_user_input "请输入 y/Y 继续执行: " "Please enter y/Y to continue: ")
	case "$user_input" in
		y|Y) Need_RestartAPI=1;;
		*)
			printf_msg "输入无效或用户取消操作，脚本退出。" \
				"Invalid input or operation canceled, exiting the script." \
				"ERROR"
			exit 1
			;;
	esac
else
	Need_RestartAPI=1
fi

if [ -f /usr/share/perl5/PVE/LXC/Setup/Oci.pm ] && [ "$RESTORE_MODE" -eq 0 ]; then
	printf_msg "该补丁已执行，请不要再次执行。如需恢复，请使用 -R 或 --restore 参数。" \
		"The patch has already been applied. Please do not apply it again. If you need to revert, use the -R or --restore option." \
		"WARNING"
	Need_RestartAPI=0
	exit 0
fi

if ! command -v patch &> /dev/null; then
	printf_msg "未找到 patch 命令，正在安装..." \
		"The patch command is not found. Installing it now..." \
		"INFO"
	apt update
	if [[ $? -ne 0 ]]; then
		printf_msg "更新软件源失败，请检查网络" \
			"Failed to update package list. Please check your network." \
			"ERROR"
		exit 1
	fi
	apt install -y patch
	if [[ $? -eq 0 ]]; then
		clear
		printf_msg "patch 命令安装成功" \
			"patch command was installed successfully." \
			"SUCCESS"
	else
		printf_msg "patch 命令安装失败，请手动安装" \
			"patch command installation failed. Please install it manually." \
			"ERROR"
		exit 1
	fi
fi

echo "$PATCH_BASE64" | base64 -d > /tmp/patch_files.tar.zst
tar -I zstd -xf /tmp/patch_files.tar.zst -C /tmp
FIX_VERSION=$(echo $PVE_VERSION |  awk -F'.' '{print $1"."$2".x"}' )
BACKUP_FILE_SUFFIX=$(echo $PVE_VERSION |  awk -F'.' '{print $1""$2""$3""}')
PATCH_TMP_DIR=$(find -L /tmp/pct-oci-patch/${FIX_VERSION} -name "*.diff" 2>/dev/null)

if [[ -z "$PATCH_TMP_DIR" ]]; then
	printf_msg "未找到适用于PVE版本 ${PVE_VERSION} 的补丁文件。" \
		"No patch files found for PVE version ${PVE_VERSION}." \
		"WARNING"
	Need_RestartAPI=0
	exit 1
fi

if [[ "$RESTORE_MODE" -eq 1 ]]; then
	if [ ! -f /usr/share/perl5/PVE/LXC/Setup/Oci.pm ]; then
		printf_msg "未检测到补丁应用的痕迹，无需恢复。" \
			"No patch application detected, no need to restore." \
			"WARNING"
		Need_RestartAPI=0
		exit 0
	fi

	for FILE in $PATCH_TMP_DIR; do
		restore_patch "$FILE"
	done

	modules=("binder_linux" "mac80211_hwsim")
	for module in "${modules[@]}"; do
		if grep -q "$module" /etc/modules; then
		printf_msg "从 /etc/modules 中移除 $module" \
			"Removing $module from /etc/modules" \
			"INFO"
		sed -i "/^$module$/d" /etc/modules
		fi
	done
	rm /etc/modprobe.d/binder_linux.conf

	printf_msg "恢复完成，已还原到原始状态" \
		"Restoration completed, system has been reverted to original state" \
		"SUCCESS"
	exit 0
fi

for FILE in $PATCH_TMP_DIR; do
	check_ready "$FILE"
	PATCH_FILE_LIST+=("$FILE")
done

if ! arrays_equal PATCH_FILE_LIST[@] CHECK_PATCH_PASS[@]; then
	printf_msg "补丁检查不通过，脚本可能不支持 ${PVE_VERSION} 版本" \
		"Patch check failed, script may not support ${PVE_VERSION} version" \
		"ERROR"
	Need_RestartAPI=0
	exit 0
else
	printf_msg "补丁检查通过！可以应用到 ${PVE_VERSION} 版本" \
		"Patch check passed! Can be applied to ${PVE_VERSION} version" \
		"SUCCESS"
fi

for FILE in "${NEED_BACKUP_FILES[@]}"; do
	BACKUP_FILE="$FILE.bak-${BACKUP_FILE_SUFFIX}"
	printf_msg "备份 $FILE 到 $BACKUP_FILE" \
		"Backing up $FILE to $BACKUP_FILE" \
		"INFO"
	cp "$FILE" "$BACKUP_FILE"
done

for FILE in "${CHECK_PATCH_PASS[@]}"; do
	printf_msg "应用补丁: $FILE" \
		"Applying patch: $FILE" \
		"INFO"
	generate_path $FILE
	TARGET_DIR=$(dirname "$TARGET_FILE")
	PATCH_FILE="$FILE"
	patch -d "$TARGET_DIR" < "$PATCH_FILE" > /dev/null 2>&1
	if [ -f "$TARGET_FILE.orig" ]; then
		printf_msg "清理 $TARGET_FILE.orig 文件" \
			"Cleaning up $TARGET_FILE.orig files" \
			"INFO"
		rm "$TARGET_FILE.orig"
	fi
done

load_module "binder_linux" "devices=binder,hwbinder,vndbinder"
load_module "mac80211_hwsim"

printf_msg "所有操作已完成！" \
	"All operations completed successfully!" \
	"SUCCESS"
printf_msg "作者: lurenjbd" \
	"Author: lurenjbd" \
	"INFO"

RUNNING_VMS=$(check_running_vms)
if [ -n "$RUNNING_VMS" ] && [ "$RUNNING_VMS" -gt 0 ]; then
	printf_msg "检测到当前有 $RUNNING_VMS 个运行中的虚拟机或容器，建议重启PVE宿主机以确保补丁完全生效。" \
		"Detected $RUNNING_VMS running VMs or containers, it is recommended to restart the PVE host to ensure the patch takes full effect." \
		"WARNING"
fi
