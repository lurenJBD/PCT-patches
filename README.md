# Patches for PCT/PVE 8

Patch scripts to improve PCT/PVE 8:

1. Add OCI container type support to PCT, enabling Redroid container startup
2. Add an IP information panel to the PCT WebUI for easy viewing of container IPs

---

[Chinese Documentation](README-CN.md) | English Documentation

## 0. Warning Information

> [!IMPORTANT]
> Running **Redroid PCT(LXC) containers** may affect other PCT(LXC) containers, e.g.: Docker cannot start or NFS cannot be mounted inside other PCT(LXC) containers.  
> To avoid such issues, do not set **Redroid PCT(LXC) containers** to autostart.  
> To resolve this, set a non-OCI PCT(LXC) container (e.g., Debian 12) to autostart,  
> or manually start a non-OCI PCT(LXC) container (e.g., Debian 12) before running a **Redroid PCT(LXC) container**.  
> This ensures lxcfs initializes correctly, so running **Redroid PCT(LXC) containers** does not affect Docker or NFS in other PCT(LXC) containers.

> [!WARNING]
> 1. PVE Cluster Mode: The script has not been tested in cluster environments. Use in cluster mode is not recommended.  
> 2. Compatibility: This script is only tested and supported on **fresh installations** of `PVE 8.2 ~ 8.4`.  
>    There may be unknown issues on other versions or non-fresh installations.  
>    Not tested on ARM64 PVE, not recommended for ARM64 users.  
> 3. To update the patch script, **revert changes** before updating.

> [!CAUTION]
> 1. If you have used other PCT(LXC) related scripts, using this script may cause unpredictable issues (and vice versa).  
> 2. Please back up important data before using this script. All data loss caused by the script is the user's responsibility. Running the script means you accept this statement!  
> 3. After applying this script, do not update PVE. If you need to update PVE, please revert the changes first to avoid accidents.


## 1. Add OCI Container Type Support to PCT

> [!Tip]
> It is recommended to use a fresh PVE 8.2+ installation

### 1.1 Usage

Supported on `PVE 8.2 ~ 8.4`

On the PVE host, run in the `Console (Shell)`:

```bash
wget -q https://raw.githubusercontent.com/lurenJBD/PCT-patches/refs/heads/pve-8/Patch-for-PCT-to-support-oci.sh
bash Patch-for-PCT-to-support-oci.sh -e
```

To revert the script changes, run:

```bash
bash Patch-for-PCT-to-support-oci.sh -e -R
```

### 1.2 Supported Parameters

Usage: `Patch-for-PCT-to-support-oci.sh [options]`

| Option              | Description                       |
| ------------------- | --------------------------------- |
| `-h, --help`        | Show this help message            |
| `-R, --restore`     | Restore original files            |
| `-D, --del-backup`  | Delete backup files after restore |
| `-y, --yes`         | Skip confirmation prompts         |
| `-c, --chinese`     | Show messages in Chinese (default)|
| `-e, --english`     | Use English for messages          |

### 1.3 PCT Feature Support

- [X] Snapshots
- [X] Backup
- [X] Firewall
- [X] Template + Full Clone
- [ ] Template + Linked Clone

---

> [!CAUTION]
> After creating a **Redroid PCT(LXC) container**, if the container's **OS Type** is not `Oci`, or there are no `lxc.init.cmd` and `lxc.mount.auto` parameter options:  
> First refresh the PVE WebUI to check for changes. If still missing, try rebooting PVE.  
> If the issue persists after reboot, rerun the script (ensure no containers/VMs are running), then try creating a new **Redroid PCT(LXC) container**.  
> To confirm success, see [deployment screenshots](#apparmor-profile-lxcinitcmd-and-ixcmountauto-parameters-added-for-oci-containers-the-latter-two-are-only-for-oci-containers).

## 2. Create Redroid LXC Container

> [!IMPORTANT]
> When creating the container, uncheck **Unprivileged container**

Download a template from [`Release`](https://github.com/lurenJBD/PCT-patches/releases), recommended: [`lineage19.1-x86_64-houdini-magisk-gapps.tar.gz`](https://github.com/lurenJBD/PCT-patches/releases/download/lineage/lineage19.1-x86_64-houdini-magisk-gapps.tar.gz)

### 2.1 Initialize the Container

Allocate at least `5GB` for `rootfs`; at least `4GB (4096MB)` RAM; set `Swap` to `0`.

| Parameter   | Value      |
| ----------- | ---------- |
| `rootfs`    | `≥ 5GB`    |
| `Memory`    | `≥ 4096MB` |
| `Swap`      | `= 0`      |

### 2.2 Configure Network

> [!Tip]
> To disable IPv6, add `androidboot.disable_ipv6=1` to the `lxc.init.cmd` parameter [Lineage templates only]

Set `IPv4` to `DHCP`. Regardless of `IPv6` settings, **Redroid PCT(LXC) containers** will get a stateless IPv6 address.

### 2.3 Add User Data Storage

After creating the container, go to `Resources` and click `Add` to add a `Mount Point`. Set `Path` to `/data`, and disk size to at least `25G`.

| Parameter   | Value   |
| ----------- | ------- |
| `Path`      | `/data` |
| `Disk Size` | `≥ 25G` |

### 2.4 [Optional] Configure GPU Acceleration

> [!NOTE]
> This is equivalent to manually adding `lxc.mount.entry: /dev/dri dev/dri none bind,optional,create=dir` to the config file

Click `Add` to add a `Mount Entry`. Set `Source Path` to `/dev/dri`, `Target Path` to `/dev/dri`, and `Create Type` to `dir`.

| Parameter      | Value      |
| -------------- | ---------- |
| `Source Path`  | `/dev/dri` |
| `Target Path`  | `/dev/dri` |
| `Create Type`  | `dir`      |

> [!IMPORTANT]
> PCT now auto-configures `lxc.init.cmd` and `lxc.mount.auto` for OCI containers. No need to set these manually in Options.

For more `lxc.init.cmd` parameters, see [redroid-doc](https://github.com/remote-android/redroid-doc?tab=readme-ov-file#configuration)

#### 2.5 Screenshots

##### `Mount Entry` feature for OCI containers (OCI only)

![Image](https://github.com/user-attachments/assets/660b1df1-4ad6-49bc-8982-617b115af164)

##### Apparmor profile, `lxc.init.cmd` and `lxc.mount.auto` for OCI containers (the latter two for OCI only)

![Image](https://github.com/user-attachments/assets/0b0dfee6-564a-4363-ad3b-a68e1b5ceaf4)

---

## 3. Add IP Information Panel to PCT WebUI

Supported on `PVE 8.1 ~ 8.4`

Thanks to `Gabriel Goller` (from pve-devel) for reference

### 3.1 Usage

```bash
wget -q https://raw.githubusercontent.com/lurenJBD/PCT-patches/refs/heads/pve-8/Patch-for-PCT-WebUI-Display-IPinfo-beta.sh
bash Patch-for-PCT-WebUI-Display-IPinfo-beta.sh -e
```

To revert the script changes, run:

```bash
bash Patch-for-PCT-WebUI-Display-IPinfo-beta.sh -e -R
```

#### 3.2 Screenshots

##### PCT main page showing IP info
![Image](https://github.com/user-attachments/assets/6fee1c85-578f-48bd-b44b-e8c01c2f9c17)

##### Detailed IP info
![Image](https://github.com/user-attachments/assets/60037ce5-ca58-4a9e-88eb-91f022560a70)

## Special Thanks

Special thanks to [NEANC](https://github.com/NEANC) for ReadMe improvements!
