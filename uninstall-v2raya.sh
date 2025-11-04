#!/bin/bash
set -e

# Define paths
INSTALL_DIR="/opt/v2ray"
SERVICE_FILE="/etc/systemd/system/v2rayA.service"

echo "[v2raya-uninstall] Stopping and disabling systemd service..."
systemctl stop v2rayA || echo "[v2raya-uninstall] Service not running"
systemctl disable v2rayA || echo "[v2raya-uninstall] Service not enabled"

echo "[v2raya-uninstall] Removing systemd service file..."
rm -f "$SERVICE_FILE"
systemctl daemon-reload

echo "[v2raya-uninstall] Removing symlinks from /usr/local/bin..."
rm -f /usr/local/bin/v2ray
rm -f /usr/local/bin/v2rayA

echo "[v2raya-uninstall] Removing installation directory: $INSTALL_DIR"
rm -rf "$INSTALL_DIR"

echo "[v2raya-uninstall] ? v2rayA has been fully uninstalled"
