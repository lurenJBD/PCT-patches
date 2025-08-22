# PCT Patches for PVE

让 PVE 8.2 ~ 8.4 的 PCT 支持 OCI 类型容器的补丁

---

[中文](https://github.com/lurenJBD/PCT-pacthes/blob/main/README-CN.md) | [English](https://github.com/lurenJBD/PCT-pacthes/blob/main/README.md)

## 安装须知

> [!CAUTION]
> 如果曾使用过与 LXC/PCT 相关的其他脚本，运行该脚本可能会导致不可预估的问题。  
> **集群用户请注意：** 本脚本尚未在集群环境中测试，因此 **不建议在集群环境中使用**。  
> **兼容性声明：** 本脚本 **仅在全新安装的 `PVE 8.2 ~ 8.4` 系统上测试并通过**。其他版本或非全新安装环境可能存在未知风险。未在 ARM64 架构的 PVE 上测试过，不建议 ARM64 版本 PVE 用户使用！！！  
> 使用本脚本前，请备份重要数据。脚本导致的一切数据丢失，由使用者承担，运行脚本视为同意该声明！  
> 使用本脚本修改后，请不要更新 PVE 版本，如需要更新 PVE 版本前请务必恢复修改，避免意外发生  
> 如果之前使用旧版脚本，请先恢复一次，在应用新版的补丁，本次补丁移除了 `PVE 8.0 和 8.1` 的支持

> [!IMPORTANT]
> 运行脚本修改后，会对部分别的 PCT 容器产生影响，比如 PCT容器 里运行 Docker 或挂载 NFS  
> 为避免发生此类影响，请不要将 **Redroid(OCI) 容器** 设为开机自启动，推荐设置一个 Debian 之类的容器自启动  
> 如果不想设置自启动，建议 (自PVE系统首次运行以来）第一启动PCT容器为非 OCI 容器，就是说运行 OCI 容器前，请先运行一个非 OCI 容器

## 1. 安装补丁

推荐使用全新安装 `PVE` 系统

### 1.1 使用方法

在 `PVE` 主机上运行

```bash
wget -q https://github.com/lurenJBD/PCT-pacthes/raw/refs/heads/main/Patch-for-PCT-to-support-oci.sh
bash Patch-for-PCT-to-support-oci.sh -c
```

如需撤销补丁修改，请输入

```bash
bash Patch-for-PCT-to-support-oci.sh -c -R
```

### 1.2 支持传入的参数

用法: `Patch-for-PCT-to-support-oci.sh [选项]`

| 选项              | 描述                                     |
| ----------------- | ---------------------------------------- |
| `-h, --help`    | 显示此帮助信息 (Show this help message)  |
| `-R, --restore` | 恢复原始文件 (Restore original files)    |
| `-y, --yes`     | 跳过确认提示 (Skip confirmation prompts) |
| `-c, --chinese` | 使用中文显示消息（默认）                 |
| `-e, --english` | Use English for messages                 |

### 1.3 支持的 PCT 功能

- [X] 快照 (Snapshots)
- [X] 备份 (Backup)
- [X] 模板 (template) + 完整克隆 (Full Clone)
- [X] 防火墙 (Firewall)

### 1.4 不支持的 PCT 功能

- [ ] 模板  (template) + 链接克隆 (Linked Clone)

---

## 2. 创建 Redroid LXC 容器

从 `[Release](https://github.com/lurenJBD/PCT-patches/releases)` 中选择一个模板下载，推荐使用 `[lineage19.1-x86_64-houdini-magisk-gapps.tar.gz](https://github.com/lurenJBD/PCT-patches/releases/download/lineage/lineage19.1-x86_64-houdini-magisk-gapps.tar.gz)`

创建容器时 **不要勾选(Don't)** 非特权容器(Unprivileged container)，会导致密码无法生效

### 2.1 配置容器

分配 `rootfs` 空间大小不低于 `5GB`，内存不小于 `4GB`，关闭 `Swap`，即填写 `0`

### 2.2 配置网络

`IPv4` 选择 `DHCP`，`IPv6` 选哪个都一样，容器都会获得一个无状态IPv6地址

> [!Tip]
> 如果想关闭IPv6，请在 `lxc.init.cmd` 参数里添加 `androidboot.disable_ipv6=1` [仅限Lineage模板支持]

创建完成容器后，在 `资源(Resouces)` 内添加一个 `挂载点(Mount Point)` ，`路径(Path)` 填写 `/data`，硬盘推荐不小于 `25G`

[可选] 点击 `Add` 添加一个 `Mount Entry`，在 Soucre Path 中填入 `/dev/dri`，在Target Path 中填入 `/dev/dri`，`Create Type` 选 `dir`

> [!NOTE]
> 这个参数等效于手动向配置文件里写 `lxc.mount.entry: /dev/dri dev/dri none bind,optional,create=dir`

现在 PCT 已经会针对 OCI 类型容器 自动配置，Options 菜单里的内容已经不需要再手动操作

关于 `lxc.init.cmd` 的更多参数，请前往 [redroid-doc](https://github.com/remote-android/redroid-doc?tab=readme-ov-file#configuration) 查看

#### 效果截图

为OCI类型容器添加的 Mount Entry 功能（仅限OCI容器使用）
![Image](https://github.com/user-attachments/assets/660b1df1-4ad6-49bc-8982-617b115af164)

为OCI类型容器添加的 Apparmor profile ，lxc.init.cmd 和 lxc.mount.auto（后两者仅限OCI容器使用）
![Image](https://github.com/user-attachments/assets/0b0dfee6-564a-4363-ad3b-a68e1b5ceaf4)

---

## 3. 为 PCT WebUI 添加 IP Info 显示界面

支持 `PVE 8.1 ~ 9.0 beta 1`

感谢 `Gabriel Goller`(来自pve-devel) 提供的参考

### 3.1 使用方法

在 `PVE` 主机上运行

```bash
wget -q https://github.com/lurenJBD/PCT-pacthes/raw/refs/heads/main/Patch-for-PVE-WebUI-Display-IPinfo-beta.sh
bash Patch-for-PVE-WebUI-Display-IPinfo-beta.sh
```

如需撤销修改，请输入

```bash
bash Patch-for-PVE-WebUI-Display-IPinfo-beta.sh -R
```

#### 效果截图

PCT主界面显示IP信息
![Image](https://github.com/user-attachments/assets/6fee1c85-578f-48bd-b44b-e8c01c2f9c17)

IP信息详细
![Image](https://github.com/user-attachments/assets/60037ce5-ca58-4a9e-88eb-91f022560a70)
