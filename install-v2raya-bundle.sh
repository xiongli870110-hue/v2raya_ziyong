#!/bin/bash

set -e

echo "[v2raya-install] 开始安装 v2rayA 合成版本包..."

INSTALL_DIR=/opt/v2raya
CORE_DIR=$INSTALL_DIR/v2ray-core
APP_DIR=$INSTALL_DIR/v2rayA
RELEASE_URL=https://github.com/xiongli870110-hue/v2raya_ziyong/releases/download/v2rayA-bundle-v2.2.7.3/v2rayA-bundle.tar.gz
RELEASE_TMP=/tmp/v2rayA-bundle.tar.gz
UNPACK_DIR=/tmp/v2rayA-bundle

# 下载合成包（如缺失）
if [ -f "$RELEASE_TMP" ]; then
  echo "[v2raya-install] 本地已存在 v2rayA-bundle.tar.gz，跳过下载 ✅"
else
  echo "[v2raya-install] 下载合成包..."
  wget -O "$RELEASE_TMP" "$RELEASE_URL"
fi

echo "[v2raya-install] 解压合成包..."
rm -rf "$UNPACK_DIR"
mkdir -p "$UNPACK_DIR"
tar -zxvf "$RELEASE_TMP" -C "$UNPACK_DIR"

# 查找 v2ray 和 v2rayA 主程序
FOUND_V2RAY=$(find "$UNPACK_DIR" -type f -name v2ray -executable | head -n 1)
FOUND_V2RAYA=$(find "$UNPACK_DIR" -type f -name v2rayA -executable | head -n 1)

if [ -z "$FOUND_V2RAY" ] || [ -z "$FOUND_V2RAYA" ]; then
  echo "[错误] 未找到 v2ray 或 v2rayA 主程序，安装失败 ❌"
  exit 1
fi

echo "[v2raya-install] 安装到 $INSTALL_DIR..."
rm -rf "$INSTALL_DIR"
mkdir -p "$CORE_DIR" "$APP_DIR"

cp "$(dirname "$FOUND_V2RAY")"/* "$CORE_DIR/"
cp "$(dirname "$FOUND_V2RAYA")"/* "$APP_DIR/"

# 创建软链接
echo "[v2raya-install] 创建软链接到 /usr/local/bin..."
ln -sf "$CORE_DIR/v2ray" /usr/local/bin/v2ray
ln -sf "$APP_DIR/v2rayA" /usr/local/bin/v2rayA

# 可选：创建默认 config.json（如不存在）
CONFIG_PATH=$CORE_DIR/config.json
if [ ! -f "$CONFIG_PATH" ]; then
  echo "[v2raya-install] 创建默认配置文件 config.json..."
  cat > "$CONFIG_PATH" <<EOF
{
  "log": {
    "loglevel": "warning"
  },
  "inbounds": [{
    "port": 1080,
    "listen": "127.0.0.1",
    "protocol": "socks",
    "settings": {
      "auth": "noauth"
    }
  }],
  "outbounds": [{
    "protocol": "freedom",
    "settings": {}
  }]
}
EOF
fi

echo "[v2raya-install] 安装完成 ✅"
echo "[v2raya-install] 可执行文件软链接已创建："
echo "  - /usr/local/bin/v2ray"
echo "  - /usr/local/bin/v2rayA"
echo "[v2raya-install] 如需启动，请手动运行：v2rayA"
