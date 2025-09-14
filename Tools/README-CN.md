# Docker转PCT模板 工具使用说明

中文 | [English](README.md)

## 简介

这是一个用于将 Docker 镜像转换为 Proxmox Container Templates (PCT) 的工具。通过此工具，可以轻松地将 Docker 容器导入到 Proxmox VE 环境中，并作为 PCT 容器模板使用。
但并非任何 Docker 镜像转换为 PCT 容器模板都能正常运行，仅支持有限的 Docker 镜像。

## 功能

- 支持从 Docker Hub 或自定义镜像仓库拉取镜像
- 自动处理容器配置并生成适用于 PCT 的配置
- 对 Redroid 容器提供特殊优化
- 支持多线程压缩以提高转换速度
- 智能管理模板存储位置
- 提供 OCI 缓存清理功能

## 环境要求

- Proxmox VE 系统
- 必要工具：skopeo, umoci, jq (脚本会自动安装)
- 可选工具：pigz (用于多线程压缩)

## 安装

```bash
wget -q https://raw.githubusercontent.com/lurenJBD/PCT-patches/refs/heads/pve-8/Tools/Docker-To-PCT-CN-Beta.sh
chmod +x Docker-To-PCT-CN-Beta.sh
```

## 使用方法

### 基本用法

```bash
./Docker-To-PCT-CN-Beta.sh <Docker镜像名称>
```

示例:

```bash
./Docker-To-PCT-CN-Beta.sh redroid/redroid:12.0.0-latest
# 或者
./Docker-To-PCT-CN-Beta.sh 'docker pull redroid/redroid:12.0.0-latest'
```

### 使用自定义 Docker 镜像源

通过设置环境变量 `DOCKER_REGISTRY_URL` 来指定自定义镜像源：

```bash
export DOCKER_REGISTRY_URL=https://dockerproxy.com
./Docker-To-PCT-CN-Beta.sh redroid/redroid:12.0.0-latest
```

## 注意事项

- 当缓存目录 `/var/cache/lxc/sha256` 大小超过 1GB 时，脚本会询问是否清理
- 对于 redroid 容器，会自动添加特殊配置以优化兼容性
- 脚本默认使用所有可用 CPU 核心减 1 的线程进行压缩，以避免系统过载

## 支持的容器示例

- redroid/redroid:12.0.0-latest
- homeassistant/home-assistant:2025.4
- nyanmisaka/jellyfin:latest
