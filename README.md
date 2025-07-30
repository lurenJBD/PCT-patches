# PCT Patches for PVE

[中文文档](https://github.com/lurenJBD/PCT-pacthes/blob/main/README-CN.md) | [English](https://github.com/lurenJBD/PCT-pacthes/blob/main/README.md)

---

### Introduction

> [!CAUTION]
> If you have previously used other scripts related to LXC/PCT, running this script may cause unpredictable issues.
>
> **Cluster user note:** This script has not been tested in a cluster environment and therefore **is not recommended** for use in a cluster environment.
>
> **Compatibility Disclaimer:** This script **has only been tested on fresh installations of PVE 8.2, 8.3 and 8.4**. Other versions or non-new installations may have unknown risks. Not tested on ARM64 architecture PVE, not recommended for ARM64 version PVE users!!
>
> Be sure to back up important data before using this script. All data loss caused by the script is the responsibility of the user, and running the script is considered as agreeing to this statement!
> 
> After using this script to modify your system, try to avoid updating the PVE version. If you need to update PVE, please be sure to revert the modifications before updating to avoid unexpected issues.
>
> If you have previously used an older version of this script, please revert the changes first, then apply the new patch. This patch has removed support for PVE 8.0 and 8.1.

Patch to enable PCT in PVE 8.2 ~ 8.4 to support OCI format containers.

> [!TIP]
> After running the script, it may affect other PCT containers, such as running Docker or mounting NFS in PCT containers.
>
> To avoid such effects, please do not set Redroid(OCI) containers to start automatically at boot. It is recommended to set a container like Debian to auto-start instead.
>
> If you don't want to set auto-start, it's recommended to first start a non-OCI container (since PVE system startup) before running an OCI container.

### Usage

```bash
wget -q https://github.com/lurenJBD/PCT-pacthes/raw/refs/heads/main/Patch-for-PCT-to-support-oci.sh
bash Patch-for-PCT-to-support-oci.sh -e
```

Revert Patch Modifications

```bash
bash Patch-for-PCT-to-support-oci.sh -e -R
```

### Supported Parameters

Usage: `Patch-for-PCT-to-support-oci.sh [options]`

| Option | Description |
|--------|-------------|
| `-h, --help` | Show this help message |
| `-R, --restore` | Restore original files |
| `-y, --yes` | Skip confirmation prompts |
| `-c, --chinese` | Use Chinese for messages (default) |
| `-e, --english` | Use English for messages |

### Supported PCT Features

- [X] Snapshots
- [X] Backup
- [X] template + Full Clone
- [X] Firewall

### Unsupported PCT Features

- [ ] template + Linked Clone

### Steps to create a Redroid container

Download a template from the Release section, recommended to use lineage19.1-x86_64-houdini-magisk-gapps.tar.gz

When creating containers **Don't check the box** Unprivileged container, enter any password as it won't take effect.

Allocate rootfs storage space not less than 5GB, memory not less than 4GB, turn off Swap by setting it to 0.

Configure the network IPv4 to DHCP, and any IPv6 option will work as the container will get a stateless IPv6 address.

> If you want to disable IPv6, add `androidboot.disable_ipv6=1` to the `lxc.init.cmd` parameter [Only supported by Lineage templates compiled by the author]

After creating the container, go to Resources and add a Mount Point, with Path set to `/data`, and recommended size not less than 25GB.

[Optional] Click Add to add a Mount Entry, with Source Path `/dev/dri`, Target Path `/dev/dri`, and Create Type set to `dir`.

> This parameter is equivalent to manually writing `lxc.mount.entry: /dev/dri dev/dri none bind,optional,create=dir` in the configuration file.

PCT will now automatically configure the OCI type containers properly, and the content in the Options menu no longer needs to be manually configured.

For more parameters about `lxc.init.cmd`, please check [redroid-doc](https://github.com/remote-android/redroid-doc?tab=readme-ov-file#configuration)

### Screenshots

Mount Entry feature added for OCI type containers (for OCI containers only)
![Image](https://github.com/user-attachments/assets/660b1df1-4ad6-49bc-8982-617b115af164)

Apparmor profile, lxc.init.cmd and lxc.mount.auto added for OCI type containers (the latter two are for OCI containers only)
![Image](https://github.com/user-attachments/assets/0b0dfee6-564a-4363-ad3b-a68e1b5ceaf4)

### Add IP Info Display Interface to PCT WebUI

Thanks to Gabriel Goller (from pve-devel) for the reference.

Supports PVE 8.1 ~ 9.0 beta 1

Usage:

```bash
wget -q https://github.com/lurenJBD/PCT-pacthes/raw/refs/heads/main/Patch-for-PVE-WebUI-Display-IPinfo-beta.sh
bash Patch-for-PVE-WebUI-Display-IPinfo-beta.sh
```

Revert modifications:

```bash
bash Patch-for-PVE-WebUI-Display-IPinfo-beta.sh -R
```

### Screenshots

IP information shown in PCT main interface
![Image](https://github.com/user-attachments/assets/6fee1c85-578f-48bd-b44b-e8c01c2f9c17)

IP information details
![Image](https://github.com/user-attachments/assets/60037ce5-ca58-4a9e-88eb-91f022560a70)
