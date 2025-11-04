#!/bin/bash
set -e

echo "[v2rayA-install] Starting installation of v2rayA + v2ray-core + .dat files"

# Define the bundle name and remote URL
BUNDLE_NAME="v2rayA-core-bundle.tar.gz"
REMOTE_URL="https://github.com/xiongli870110-hue/v2raya_ziyong/releases/download/v2rayA-core-bundle-v2.2.7.3/$BUNDLE_NAME"

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BUNDLE="$SCRIPT_DIR/$BUNDLE_NAME"

# Check if the bundle exists locally
if [ ! -f "$BUNDLE" ]; then
  echo "[v2rayA-install] ⚠️ Bundle not found locally: $BUNDLE"
  echo "[v2rayA-install] Attempting to download from: $REMOTE_URL"
  wget -O "$BUNDLE" "$REMOTE_URL" || {
    echo "[v2rayA-install] ❌ Failed to download bundle. Please check your network or download manually."
    exit 1
  }
fi

# Create temporary directory for extraction
TMP_DIR="/tmp/v2rayA-core"
rm -rf "$TMP_DIR"
mkdir -p "$TMP_DIR"
echo "[v2rayA-install] Extracting bundle..."
tar -xzvf "$BUNDLE" -C "$TMP_DIR"

# Install v2ray and v2rayA binaries
echo "[v2rayA-install] Installing v2ray and v2raya to /usr/local/bin..."
install -Dm755 "$TMP_DIR/usr/local/bin/v2ray" /usr/local/bin/v2ray
install -Dm755 "$TMP_DIR/usr/local/bin/v2raya" /usr/local/bin/v2raya

# Install .dat files
echo "[v2rayA-install] Installing geoip.dat and geosite.dat to /usr/local/share/v2ray..."
mkdir -p /usr/local/share/v2ray
install -m644 "$TMP_DIR/usr/local/share/v2ray/geoip.dat" /usr/local/share/v2ray/geoip.dat
install -m644 "$TMP_DIR/usr/local/share/v2ray/geosite.dat" /usr/local/share/v2ray/geosite.dat

# Create systemd service file for v2rayA
echo "[v2rayA-install] Creating systemd service for auto-start..."
cat <<EOF > /etc/systemd/system/v2rayA.service
[Unit]
Description=v2rayA Service
After=network.target

[Service]
Type=simple
ExecStart=/usr/local/bin/v2raya
Restart=on-failure
User=root
Environment=V2RAY_LOCATION_CONFIG=/etc/v2raya/config.json

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd and enable service
echo "[v2rayA-install] Enabling and starting v2rayA service..."
systemctl daemon-reexec
systemctl daemon-reload
systemctl enable v2rayA
systemctl restart v2rayA

# Clean up temporary directory
rm -rf "$TMP_DIR"

# Final message
echo "[v2rayA-install] ✅ Installation complete and auto-start enabled"
echo "[v2rayA-install] Executables: /usr/local/bin/v2ray and /usr/local/bin/v2raya"
echo "[v2rayA-install] Data files: /usr/local/share/v2ray/geoip.dat and geosite.dat"
echo "[v2rayA-install] Manage service with: systemctl status|restart|stop v2rayA"
