#!/bin/bash
# Make by lurenjbd 2025-02-14
# Version 2.1
# Edited 2025-08-26
# Patch to make PCT WebUI display IP information.

########### Variable ###########

MIN_VERSION="8.1.0"
RESTORE_MODE=0
SKIP_CONFIRM=0
DEL_BACKUP=0
LANGUAGE="zh_cn"

# Color Code
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' 

#  Patches BASE64
PATCH_BASE64='
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
EqPVaA=='

########### Function ###########
show_usage() {
	echo -e "${BLUE}==========================================================${NC}"
	echo -e "${BLUE}         PVE WebUI Display IP Info Patch Tool${NC}"
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
		if [[ "$CREATE_NEW_FILE" -eq 1 ]]; then
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

		# 8.3.x need special treatment, try to use 8.3.3 patch.
		if [[ "$FIX_VERSION" == "8.3.x" && "$TARGET_DIR" == "/usr/share/pve-manager/js" ]]; then
			PATCH_FILE=$(echo "$1" | sed 's/8\.3\.x/8.3.3/')
			if patch --dry-run -d "$TARGET_DIR" < "$PATCH_FILE" >/dev/null 2>&1; then
				printf_msg "补丁 $(basename ${PATCH_FILE}) 可以成功应用" \
					"$(basename ${PATCH_FILE}) Patch can be apply successfully." \
					"SUCCESS"
				CHECK_PATCH_PASS+=("$PATCH_FILE")
				return 0
			fi
		fi

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

PVE_VERSION=$(pveversion | awk -F'/' '{print $2}' | awk -F'-' '{print $1}')

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

if grep -q "xtype: 'pveIPView'" /usr/share/pve-manager/js/pvemanagerlib.js && [ "$RESTORE_MODE" -eq 0 ]; then
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
PATCH_TMP_DIR=$(find -L /tmp/pct-webui-patch/${FIX_VERSION} -name "*.diff" 2>/dev/null)

if [[ -z "$PATCH_TMP_DIR" ]]; then
	printf_msg "未找到适用于PVE版本 ${PVE_VERSION} 的补丁文件。" \
		"No patch files found for PVE version ${PVE_VERSION}." \
		"WARNING"
	Need_RestartAPI=0
	exit 1
fi

if [[ "$RESTORE_MODE" -eq 1 ]]; then
	if ! grep -q "xtype: 'pveIPView'" /usr/share/pve-manager/js/pvemanagerlib.js; then
		printf_msg "未检测到补丁应用的痕迹，无需恢复。" \
			"No patch application detected, no need to restore." \
			"WARNING"
		Need_RestartAPI=0
		exit 0
	fi

	for FILE in $PATCH_TMP_DIR; do
		restore_patch "$FILE"
	done
	
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
			"Patch check failed, script may not support ${PVE_VERSION} version!" "ERROR"
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
	PATCH_FILE=$FILE
	patch -d "$TARGET_DIR" < "$PATCH_FILE" > /dev/null 2>&1
	if [ -f "$TARGET_FILE.orig" ]; then
		printf_msg "清理 $TARGET_FILE.orig 文件" \
			"Cleaning up $TARGET_FILE.orig files" \
			"INFO"
		rm "$TARGET_FILE.orig"
	fi
done

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
