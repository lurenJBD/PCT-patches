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
SN/MuODspCLhz/shY31cVA=='

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
