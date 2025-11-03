#!/bin/bash

set -e

echo "[v2raya-install] 开始安装 v2rayA + v2ray-core..."

# 安装路径
BIN_DIR=/usr/local/bin
SHARE_DIR=/usr/local/share/v2ray

mkdir -p "$BIN_DIR" "$SHARE_DIR"

### ✅ 安装 v2rayA 二进制
echo "[v2raya-install] 获取 v2rayA 最新版本号..."
version="$(wget -qO- https://apt.v2raya.org/dists/v2raya/main/binary-amd64/Packages | grep '^Version:' | head -n1 | cut -d' ' -f2)"

if [ -z "$version" ]; then
  echo "[错误] 未能获取 v2rayA 最新版本号 ❌"
  exit 1
fi

echo "[v2raya-install] 最新版本为：$version"

cd /tmp
BIN_NAME="v2raya_linux_x64_$version"
BIN_URL="https://github.com/v2rayA/v2rayA/releases/download/v$version/$BIN_NAME"

echo "[v2raya-install] 下载 v2rayA..."
wget -O "$BIN_NAME" "$BIN_URL"
install -Dm755 "$BIN_NAME" "$BIN_DIR/v2rayA"

### ✅ 安装 v2ray-core
CORE_URL="https://github.com/v2fly/v2ray-core/releases/download/v5.41.0/v2ray-linux-64.zip"
CORE_ZIP="/tmp/v2ray-core.zip"
CORE_TMP="/tmp/v2ray-core"

echo "[v2raya-install] 下载 v2ray-core v5.41.0..."
wget -O "$CORE_ZIP" "$CORE_URL"

echo "[v2raya-install] 解压 v2ray-core..."
rm -rf "$CORE_TMP"
mkdir -p "$CORE_TMP"
unzip "$CORE_ZIP" -d "$CORE_TMP"

echo "[v2raya-install] 安装 v2ray 主程序..."
install -Dm755 "$CORE_TMP/v2ray" "$BIN_DIR/v2ray"

echo "[v2raya-install] 安装 dat 文件到 $SHARE_DIR..."
for f in "$CORE_TMP"/*.dat; do
  install -Dm644 "$f" "$SHARE_DIR/$(basename "$f")"
done

echo "[v2raya-install] 安装完成 ✅"
echo "[v2raya-install] 可执行文件："
echo "  - $BIN_DIR/v2ray"
echo "  - $BIN_DIR/v2rayA"
echo "[v2raya-install] 数据文件目录：$SHARE_DIR"
echo "[v2raya-install] 如需启动，请运行：v2rayA"
