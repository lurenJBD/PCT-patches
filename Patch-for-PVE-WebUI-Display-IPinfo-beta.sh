#!/bin/bash
# Make by lurenjbd 2025-02-14
# Edited 2025-07-30
# Patch to make PCT WebUI display IP information.

########### Variable ###########

MIN_VERSION="8.1.0"
RESTORE_MODE=0
SKIP_CONFIRM=0
LANGUAGE="zh_cn"

# 颜色代码
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' 

#  Patches BASE64
PATCH_BASE64='
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'

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
                printf_msg "错误: 未知选项 $1" "Error: Unknown option $1" "ERROR"
                show_usage
                exit 1
                ;;
        esac
    done
}


generate_path() {
    CREATE_NEW_FILE=0
    
    FIRST_LINE_PATH=$(awk 'NR==1 {print $2}' "$1")
    SECOND_LINE_PATH=$(awk 'NR==2 {print $2}' "$1")
    
    if [[ "$FIRST_LINE_PATH" == "/dev/null" ]]; then
        CREATE_NEW_FILE=1
    fi
    TARGET_FILE="${SECOND_LINE_PATH}"
    
    if [[ ! "${SECOND_LINE_PATH}" =~ ^/ ]]; then
        TARGET_FILE=""
    fi
}


check_ready() {
    generate_path "$1"

    if [[ -z "$TARGET_FILE" ]]; then
        printf_msg "无法从补丁中获取目标文件路径: $1" "Cannot get target file path from patch: $1" "ERROR"
        return 1
    fi

    BACKUP_FILE="$TARGET_FILE.bak"
    
    if [ -e "$BACKUP_FILE" ]; then
        printf_msg "备份文件已存在: $BACKUP_FILE" "Backup file already exists: $BACKUP_FILE" "WARNING"
    elif [ -e "$TARGET_FILE" ]; then
        NEED_BACKUP_FILES+=("$TARGET_FILE")
    else
        if [[ "$CREATE_NEW_FILE" -eq 1 ]]; then
            printf_msg "将创建新文件: $TARGET_FILE" "Will create new file: $TARGET_FILE" "SUCCESS"
        else
            printf_msg "未找到目标文件: $TARGET_FILE" "Target file not found: $TARGET_FILE" "ERROR"
            return 1
        fi
    fi

    TARGET_DIR=$(dirname "$TARGET_FILE")
    
    if [[ ! -d "$TARGET_DIR" && "$CREATE_NEW_FILE" -eq 1 ]]; then
        printf_msg "目标目录不存在，将创建: $TARGET_DIR" "Target directory does not exist, will create: $TARGET_DIR" "INFO"
        mkdir -p "$TARGET_DIR"
    fi

    PATCH_FILE="$1"
    if ! patch --dry-run -d "$TARGET_DIR" < "$PATCH_FILE" >/dev/null 2>&1; then
        # only 8.3.3 in 8.3.x need special treatment
        if [[ "$FIX_VERSION" == "8.3.x" && "$TARGET_DIR" == "/usr/share/pve-manager/js" ]]; then
            PATCH_FILE=$(echo "$1" | sed 's/8\.3\.x/8.3.3/')
            if patch --dry-run -d "$TARGET_DIR" < "$PATCH_FILE" >/dev/null 2>&1; then
                printf_msg "补丁 $PATCH_FILE 可以成功应用" "$PATCH_FILE Patch can be apply successfully." "SUCCESS"
                CHECK_PATCH_PASS+=("$PATCH_FILE")
                return 0
            fi
        fi
        printf_msg "补丁 $(basename ${PATCH_FILE}) 无法应用。请检查补丁文件和目标目录。" "$(basename ${PATCH_FILE}) Patch cannot be apply. Please check the patch file and target directory." "ERROR"
        patch --dry-run -d "$TARGET_DIR" < "$PATCH_FILE"
        return 1
    else
        printf_msg "补丁 $(basename ${PATCH_FILE}) 可以成功应用" "$(basename ${PATCH_FILE}) Patch can be apply successfully." "SUCCESS"
        CHECK_PATCH_PASS+=("$1")
        return 0
    fi
}


restore_patch(){
	generate_path "$1"
	
	if [[ -z "$TARGET_FILE" ]]; then
		printf_msg "无法从补丁获取目标文件路径: $1" "Cannot get target file path from patch: $1" "ERROR"
		return 1
	fi
	
	BACKUP_FILE="$TARGET_FILE.bak"
    
    if [[ "$CREATE_NEW_FILE" -eq 1 ]]; then
        if [ -e "$TARGET_FILE" ]; then
            rm -f "$TARGET_FILE"
            printf_msg "已删除新创建的文件 $TARGET_FILE" "Deleted newly created file $TARGET_FILE" "INFO"
        else
            printf_msg "文件不存在，无需删除: $TARGET_FILE" "File does not exist, no need to delete: $TARGET_FILE" "INFO"
        fi
    else
        TARGET_DIR=$(dirname "$TARGET_FILE")
        PATCH_FILE="$1"
        
        printf_msg "尝试反向应用补丁: $PATCH_FILE" "Trying to reverse apply patch: $PATCH_FILE" "INFO"
        
        if [ -e "$TARGET_FILE" ] && patch -R --dry-run -d "$TARGET_DIR" < "$PATCH_FILE" >/dev/null 2>&1; then
            patch -R -d "$TARGET_DIR" < "$PATCH_FILE" > /dev/null 2>&1
            printf_msg "成功反向应用补丁，恢复文件 $TARGET_FILE" "Successfully reverse applied patch to restore $TARGET_FILE" "SUCCESS"
        elif [ -e "$BACKUP_FILE" ]; then
            printf_msg "反向应用补丁失败，使用备份文件恢复" "Reverse patch failed, using backup file to restore" "WARNING"
            mv $BACKUP_FILE $TARGET_FILE
            printf_msg "成功恢复文件 $TARGET_FILE" "Restore $TARGET_FILE file successfully." "SUCCESS"
        else
            printf_msg "未找到备份文件 $BACKUP_FILE 且无法反向应用补丁" "Backup file $BACKUP_FILE not found and cannot reverse apply patch." "WARNING"
        fi
    fi
}


arrays_equal() {
    local arr1=("${!1}")
    local arr2=("${!2}")

    if [ ${#arr1[@]} -ne ${#arr2[@]} ]; then
        printf_msg "补丁检查失败！" "Patch check Failed!" "ERROR"
        return 1
    fi

    local sorted1=$(printf '%s\n' "${arr1[@]}" | sort)
    local sorted2=$(printf '%s\n' "${arr2[@]}" | sort)
    
    if [ "$sorted1" = "$sorted2" ]; then
        printf_msg "补丁检查通过！可以应用到当前PVE版本" "Patch check passed! Can work with this version of PVE" "SUCCESS"
        return 0
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
    rm -rf /tmp/patch_files.tar.gz /tmp/pct-webui-patch
    if [ "$Need_RestartAPI" -eq 1 ]; then
        printf_msg "正在重启PVE Web界面服务..." "Restarting PVE Web UI services..." "INFO"
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

if [[ "$(echo -e "$MIN_VERSION\n$PVE_VERSION" | sort -V | head -n1)" != "$MIN_VERSION" ]]; then
    printf_msg "当前PVE版本 $PVE_VERSION 低于 $MIN_VERSION。请升级PVE系统版本。" "The current PVE version $PVE_VERSION is lower than $MIN_VERSION. Please upgrade the PVE system version." "WARNING"
    exit 1
fi

if [[ "$SKIP_CONFIRM" -ne 1 ]]; then
    printf_msg "我已了解该脚本的作用，并自愿承担对应的风险。" "I have understood the purpose of this script and voluntarily assume the corresponding risks." "INFO"
    user_input=$(read_user_input "请输入 y/Y 继续执行: " "Please enter y/Y to continue: ")
    case "$user_input" in
        y|Y) Need_RestartAPI=1;;
        *)
            printf_msg "输入无效或用户取消操作，脚本退出。" "Invalid input or operation canceled, exiting the script." "ERROR"
            exit 1
            ;;
    esac
else
    Need_RestartAPI=1
fi

echo "$PATCH_BASE64" | base64 -d > /tmp/patch_files.tar.zst
tar -I zstd -xf /tmp/patch_files.tar.zst -C /tmp
FIX_VERSION=$(echo $PVE_VERSION |  awk -F'.' '{print $1"."$2".x"}' )
PATCH_TMP_DIR=$(find -L /tmp/pct-webui-patch/${FIX_VERSION} -name "*.diff" 2>/dev/null)

if [[ -z "$PATCH_TMP_DIR" ]]; then
    printf_msg "未找到适用于PVE版本 ${FIX_VERSION} 的补丁文件。" "No patch files found for PVE version ${FIX_VERSION}." "WARNING"
    Need_RestartAPI=0
    exit 1
fi

if [[ "$RESTORE_MODE" -eq 1 ]]; then
    if ! grep -q "xtype: 'pveIPView'" /usr/share/pve-manager/js/pvemanagerlib.js; then
        printf_msg "未检测到补丁应用的痕迹，无需恢复。" "No patch application detected, no need to restore." "WARNING"
        Need_RestartAPI=0
        exit 0
    fi

    for FILE in $PATCH_TMP_DIR; do
        restore_patch "$FILE"
    done
    
    printf_msg "恢复完成，已还原到原始状态" "Restoration completed, system has been reverted to original state" "SUCCESS"
    exit 0
fi

if ! command -v patch &> /dev/null; then
    printf_msg "未找到 'patch' 命令，正在安装..." "The 'patch' command is not found. Installing it now..." "INFO"
    apt update
    apt install -y patch
    clear 
    printf_msg "'patch' 命令安装成功" "The 'patch' command was installed successfully" "SUCCESS"
fi

if grep -q "xtype: 'pveIPView'" /usr/share/pve-manager/js/pvemanagerlib.js; then
    printf_msg "该补丁已执行，请不要再次执行。如需恢复，请使用 -R 或 --restore 参数。" "The patch has already been applied. Please do not apply it again. If you need to revert, use the -R or --restore option." "WARNING"
    Need_RestartAPI=0
    exit 1
fi

for FILE in $PATCH_TMP_DIR; do
    check_ready "$FILE"
    PATCH_FILE_LIST+=("$FILE")
done

if ! arrays_equal PATCH_FILE_LIST[@] CHECK_PATCH_PASS[@]; then
    printf_msg "由于补丁检查不通过，脚本停止执行" "Script stop execution due to patch check failure" "ERROR"
    Need_RestartAPI=0
    exit 1
fi

for FILE in "${NEED_BACKUP_FILES[@]}"; do
    BACKUP_FILE="$FILE.bak"
    printf_msg "备份 $FILE 到 $BACKUP_FILE" "Backing up $FILE to $BACKUP_FILE" "INFO"
    cp "$FILE" "$BACKUP_FILE"
done

for FILE in "${CHECK_PATCH_PASS[@]}"; do
    printf_msg "应用补丁: $FILE" "Applying patch: $FILE" "INFO"
    generate_path $FILE
    TARGET_DIR=$(dirname "$TARGET_FILE")
    PATCH_FILE=$FILE
    patch -d "$TARGET_DIR" < "$PATCH_FILE" > /dev/null 2>&1
    if [ -f "$TARGET_FILE.orig" ]; then
        printf_msg "清理 *.orig 文件" "Cleaning up *.orig files" "INFO"
        rm "$TARGET_FILE.orig"
    fi
done

printf_msg "所有操作已完成！" "All operations completed successfully!" "SUCCESS"
printf_msg "作者: lurenjbd" "Author: lurenjbd" "INFO"

RUNNING_VMS=$(check_running_vms)
if [ -n "$RUNNING_VMS" ] && [ "$RUNNING_VMS" -gt 0 ]; then
    printf_msg "检测到当前有 $RUNNING_VMS 个运行中的虚拟机或容器，建议重启PVE宿主机以确保补丁完全生效。" \
               "Detected $RUNNING_VMS running VMs or containers, it is recommended to restart the PVE host to ensure the patch takes full effect." "WARNING"
fi
