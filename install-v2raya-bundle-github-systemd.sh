#!/bin/bash
set -e

echo "[v2raya-install] Starting v2rayA installation..."

# Get the absolute path of this script
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Define paths
LOCAL_BUNDLE="${SCRIPT_DIR}/v2rayA-bundle.tar.gz"
TMP_BUNDLE="/tmp/v2rayA-bundle.tar.gz"
INSTALL_DIR="/opt/v2ray"
SERVICE_FILE="/etc/systemd/system/v2rayA.service"
SHARE_DIR="/usr/local/share/v2ray"

# GitHub release URL
BUNDLE_URL="https://github.com/xiongli870110-hue/v2raya_ziyong/releases/download/v2rayA-bundle-v2.2.7.3/v2rayA-bundle.tar.gz"

echo "[v2raya-fetch] Checking for local offline bundle..."
if [ -f "$LOCAL_BUNDLE" ]; then
  echo "[v2raya-fetch] Found local bundle: $LOCAL_BUNDLE"
  cp "$LOCAL_BUNDLE" "$TMP_BUNDLE"
else
  echo "[v2raya-fetch] Local bundle not found, downloading from GitHub..."
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

cp /tmp/v2rayA-bundle/v2raya_linux_x64_2.2.7.3 "$INSTALL_DIR/v2rayA"
cp /tmp/v2rayA-bundle/v2ray-core/v2ray "$INSTALL_DIR/v2ray"
chmod +x "$INSTALL_DIR/v2rayA" "$INSTALL_DIR/v2ray"

echo "[v2raya-install] Copying .dat files..."
for f in /tmp/v2rayA-bundle/v2ray-core/*.dat; do
  cp "$f" "$INSTALL_DIR/"
done
chmod 644 "$INSTALL_DIR/"*.dat

echo "[v2raya-install] Creating symlinks in /usr/local/bin..."
ln -sf "$INSTALL_DIR/v2ray" /usr/local/bin/v2ray
ln -sf "$INSTALL_DIR/v2rayA" /usr/local/bin/v2rayA

echo "[v2raya-install] Creating symlinks for dat files in $SHARE_DIR..."
mkdir -p "$SHARE_DIR"
ln -sf "$INSTALL_DIR/geoip.dat" "$SHARE_DIR/geoip.dat"
ln -sf "$INSTALL_DIR/geosite.dat" "$SHARE_DIR/geosite.dat"

echo "[v2raya-service] Creating systemd service file: $SERVICE_FILE"
cat <<EOF > "$SERVICE_FILE"
[Unit]
Description=v2rayA Service
After=network.target

[Service]
Type=simple
ExecStart=$INSTALL_DIR/v2rayA
Restart=on-failure
User=root

[Install]
WantedBy=multi-user.target
EOF

echo "[v2raya-service] Reloading systemd daemon..."
systemctl daemon-reexec
systemctl daemon-reload

echo "[v2raya-service] Enabling and starting v2rayA service..."
systemctl enable v2rayA
systemctl start v2rayA

echo "[v2raya-service] Checking service status..."
systemctl status v2rayA --no-pager

echo "[v2raya-deploy] ? Deployment complete"
echo "[v2raya-deploy] v2rayA is installed and running as a systemd service"
echo "[v2raya-deploy] To manage the service:"
echo "  - systemctl start v2rayA"
echo "  - systemctl stop v2rayA"
echo "  - systemctl restart v2rayA"
echo "  - systemctl status v2rayA"
