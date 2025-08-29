# Docker to PCT Template Conversion Tool
[中文文档](https://github.com/lurenJBD/PCT-pacthes/blob/main/Tools/README-CN.md) | [English](https://github.com/lurenJBD/PCT-pacthes/blob/main/Tools/README.md)

## Introduction

This is a tool for converting Docker images to Proxmox Container Templates (PCT). With this tool, you can easily import Docker containers into the Proxmox VE environment and use them as PCT container templates.
Note that not all Docker images can be successfully converted to PCT container templates; only a limited range of Docker images are supported.

## Features

- Support for pulling images from Docker Hub or custom image repositories
- Automatic processing of container configurations and generation of PCT-compatible configurations
- Special optimization for Redroid containers
- Multi-threaded compression to improve conversion speed
- Intelligent management of template storage locations
- OCI cache cleaning functionality

## Requirements

- Proxmox VE system
- Required tools: skopeo, umoci, jq (the script will install these automatically)
- Optional tools: pigz (for multi-threaded compression)

## Installation

```bash
wget -q https://github.com/lurenJBD/PCT-pacthes/raw/refs/heads/main/Tools/Docker-To-PCT-EN-Beta.sh
chmod +x Docker-To-PCT-EN-Beta.sh
```

## Usage

### Basic Usage

```bash
./Docker-To-PCT-EN-Beta.sh <Docker image name>
```

Examples:

```bash
./Docker-To-PCT-EN-Beta.sh redroid/redroid:12.0.0-latest
# or
./Docker-To-PCT-EN-Beta.sh 'docker pull redroid/redroid:12.0.0-latest'
```

### Using Custom Docker Image Repository

Specify a custom image repository by setting the `DOCKER_REGISTRY_URL` environment variable:

```bash
export DOCKER_REGISTRY_URL=https://dockerproxy.com
./Docker-To-PCT-EN-Beta.sh redroid/redroid:12.0.0-latest
```

## Notes

- When the cache directory `/var/cache/lxc/sha256` exceeds 1GB in size, the script will ask if you want to clean it
- For redroid containers, special configurations are automatically added to optimize compatibility
- The script uses all available CPU cores minus 1 for compression by default to prevent system overload

## Supported Container Examples

- redroid/redroid:12.0.0-latest
- homeassistant/home-assistant:2025.4
- nyanmisaka/jellyfin:latest
