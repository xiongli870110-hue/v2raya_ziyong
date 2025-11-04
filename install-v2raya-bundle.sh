#!/bin/bash
set -e

# 获取当前脚本所在目录
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# 定义安装包路径（优先使用当前目录）
LOCAL_BUNDLE="${SCRIPT_DIR}/v2rayA-bundle.tar.gz"
TMP_BUNDLE="/tmp/v2rayA-bundle.tar.gz"
# 具备魔法网络的环境
#BUNDLE_URL="https://github.com/xiongli870110-hue/v2raya_ziyong/releases/download/v2rayA-bundle-v2.2.7.3/v2rayA-bundle.tar.gz"
# 适合国内用户
BUNDLE_URL="https://github.com/xiongli870110-hue/v2raya_ziyong/releases/download/v2rayA-bundle-v2.2.7.3/v2rayA-bundle.tar.gz"
INSTALL_DIR="/opt/v2ray"

echo "[v2raya-fetch] 检查当前目录是否存在离线安装包..."

if [ -f "$LOCAL_BUNDLE" ]; then
  echo "[v2raya-fetch] ✅ 当前目录已存在离线包：$LOCAL_BUNDLE"
  cp "$LOCAL_BUNDLE" "$TMP_BUNDLE"
else
  echo "[v2raya-fetch] 🌐 当前目录无离线包，尝试联网下载..."
  wget -O "$TMP_BUNDLE" "$BUNDLE_URL"
  echo "[v2raya-fetch] ✅ 下载完成：$TMP_BUNDLE"
fi

echo "[v2raya-fetch] 解压安装包到临时目录..."
rm -rf /tmp/v2rayA-bundle
mkdir -p /tmp/v2rayA-bundle
tar -zxvf "$TMP_BUNDLE" -C /tmp/v2rayA-bundle

echo "[v2raya-install] 安装到 $INSTALL_DIR..."
rm -rf "$INSTALL_DIR"
mkdir -p "$INSTALL_DIR"

cp /tmp/v2rayA-bundle/v2raya_linux_x64_2.2.7.3 "$INSTALL_DIR/v2rayA"
cp /tmp/v2rayA-bundle/v2ray-core/v2ray "$INSTALL_DIR/v2ray"

for f in /tmp/v2rayA-bundle/v2ray-core/*.dat; do
  cp "$f" "$INSTALL_DIR/"
done

echo "[v2raya-install] 创建软链接到 /usr/local/bin..."
ln -sf "$INSTALL_DIR/v2ray" /usr/local/bin/v2ray
ln -sf "$INSTALL_DIR/v2rayA" /usr/local/bin/v2rayA

echo "[v2raya-install] 安装完成 ✅"
echo "[v2raya-install] 可执行文件："
echo "  - /usr/local/bin/v2ray → $INSTALL_DIR/v2ray"
echo "  - /usr/local/bin/v2rayA → $INSTALL_DIR/v2rayA"
echo "[v2raya-install] 数据文件已复制到：$INSTALL_DIR"
echo "[v2raya-install] 如需启动，请运行：v2rayA"
