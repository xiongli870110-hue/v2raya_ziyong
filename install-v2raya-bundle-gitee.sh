#!/bin/bash
set -e

# Get the absolute path of this script
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Define paths
LOCAL_BUNDLE="${SCRIPT_DIR}/v2-bundle.bin"         # Local offline bundle (renamed .tar.gz)
TMP_BUNDLE="/tmp/v2rayA-bundle.tar.gz"             # Temporary path for extracted bundle
INSTALL_DIR="/opt/v2ray"                           # Final installation directory

# Remote fallback URL (Gitee-hosted .bin file)
BUNDLE_URL="https://gitee.com/rakerose/doc/raw/master/v2-bundle.bin"

echo "[v2raya-fetch] Checking for local offline bundle..."

# Use local bundle if available
if [ -f "$LOCAL_BUNDLE" ]; then
  echo "[v2raya-fetch] Found local bundle: $LOCAL_BUNDLE"
  cp "$LOCAL_BUNDLE" "$TMP_BUNDLE"
else
  echo "[v2raya-fetch] Local bundle not found, downloading from Gitee..."
  wget -O "$TMP_BUNDLE" "$BUNDLE_URL"
  echo "[v2raya-fetch] Download complete: $TMP_BUNDLE"
fi

echo "[v2raya-fetch] Extracting bundle to temporary directory..."
rm -rf /tmp/v2rayA-bundle
mkdir -p /tmp/v2rayA-bundle
tar -zxvf "$TMP_BUNDLE" -C /tmp/v2rayA-bundle

echo "[v2raya-install] Installing to $INSTALL_DIR..."
rm -rf "$INSTALL_DIR"
mkdir -p "$INSTALL_DIR"

# Copy core binaries
cp /tmp/v2rayA-bundle/v2raya_linux_x64_2.2.7.3 "$INSTALL_DIR/v2rayA"
cp /tmp/v2rayA-bundle/v2ray-core/v2ray "$INSTALL_DIR/v2ray"

# Fix permissions
chmod +x "$INSTALL_DIR/v2rayA" "$INSTALL_DIR/v2ray"

# Copy data files
for f in /tmp/v2rayA-bundle/v2ray-core/*.dat; do
  cp "$f" "$INSTALL_DIR/"
done

echo "[v2raya-install] Creating symlinks in /usr/local/bin..."
ln -sf "$INSTALL_DIR/v2ray" /usr/local/bin/v2ray
ln -sf "$INSTALL_DIR/v2rayA" /usr/local/bin/v2rayA

echo "[v2raya-install] Installation complete"
echo "[v2raya-install] Executables:"
echo "  - /usr/local/bin/v2ray --> $INSTALL_DIR/v2ray"
echo "  - /usr/local/bin/v2rayA --> $INSTALL_DIR/v2rayA"
echo "[v2raya-install] Data files copied to: $INSTALL_DIR"
echo "[v2raya-install] To start, run: v2rayA"
