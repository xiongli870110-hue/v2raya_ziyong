#!/bin/bash

set -e

BUNDLE_PATH="/opt/v2rayA-bundle.tar.gz"
BUNDLE_URL="https://github.com/xiongli870110-hue/v2raya_ziyong/releases/download/v2rayA-bundle-v2.2.7.3/v2rayA-bundle.tar.gz"
TMPDIR="/opt/v2ray-tmp"
INSTALL_DIR="/opt/v2ray"
V2RAYA_BIN="$INSTALL_DIR/v2rayA"

### ✅ 检查是否已安装
if [ -x "$V2RAYA_BIN" ]; then
  echo "[v2raya-install] 检测到已安装 v2rayA：$V2RAYA_BIN ✅"
  echo "[v2raya-install] 如需重新安装，请先删除该目录：sudo rm -rf $INSTALL_DIR"
  exit 0
fi

### ✅ 下载安装包（如缺失）
echo "[v2raya-fetch] 检查是否已存在安装包..."
if [ -f "$BUNDLE_PATH" ]; then
  echo "[v2raya-fetch] 已存在：$BUNDLE_PATH ✅"
else
  echo "[v2raya-fetch] 未找到安装包，开始下载..."
  wget -O "$BUNDLE_PATH" "$BUNDLE_URL"
  echo "[v2raya-fetch] 下载完成 ✅"
fi

### ✅ 解压安装包
echo "[v2raya-fetch] 解压安装包到临时目录 $TMPDIR..."
rm -rf "$TMPDIR"
mkdir -p "$TMPDIR"
tar -zxvf "$BUNDLE_PATH" -C "$TMPDIR"

### ✅ 安装到 /opt/v2ray
echo "[v2raya-install] 安装到 $INSTALL_DIR..."
rm -rf "$INSTALL_DIR"
mkdir -p "$INSTALL_DIR"

cp "$TMPDIR/v2raya_linux_x64_2.2.7.3" "$INSTALL_DIR/v2rayA"
cp "$TMPDIR/v2ray-core/v2ray" "$INSTALL_DIR/v2ray"

for f in "$TMPDIR/v2ray-core/"*.dat; do
  cp "$f" "$INSTALL_DIR/"
done

### ✅ 创建软链接
echo "[v2raya-install] 创建软链接到 /usr/local/bin..."
ln -sf "$INSTALL_DIR/v2ray" /usr/local/bin/v2ray
ln -sf "$INSTALL_DIR/v2rayA" /usr/local/bin/v2rayA

echo "[v2raya-install] 安装完成 ✅"
echo "[v2raya-install] 可执行文件："
echo "  - /usr/local/bin/v2ray → $INSTALL_DIR/v2ray"
echo "  - /usr/local/bin/v2rayA → $INSTALL_DIR/v2rayA"
echo "[v2raya-install] 数据文件已复制到：$INSTALL_DIR"
echo "[v2raya-install] 如需启动，请运行：v2rayA"
