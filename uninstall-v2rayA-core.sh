#!/bin/bash
set -e

echo "[v2rayA-uninstall] Starting full uninstallation of v2rayA and v2ray-core..."

# Stop and disable systemd service
echo "[v2rayA-uninstall] Stopping and disabling v2rayA service..."
systemctl stop v2rayA || true
systemctl disable v2rayA || true

# Remove systemd service file
echo "[v2rayA-uninstall] Removing systemd service file..."
rm -f /etc/systemd/system/v2rayA.service
systemctl daemon-reexec
systemctl daemon-reload

# Remove binaries
echo "[v2rayA-uninstall] Removing binaries from /usr/local/bin..."
rm -f /usr/local/bin/v2ray
rm -f /usr/local/bin/v2raya

# Remove data files
echo "[v2rayA-uninstall] Removing data files from /usr/local/share/v2ray..."
rm -rf /usr/local/share/v2ray

# Optional: remove config directory if unused
if [ -d /etc/v2raya ]; then
  echo "[v2rayA-uninstall] Optional: config directory /etc/v2raya still exists. You may remove it manually if needed."
fi

# Final message
echo "[v2rayA-uninstall] ✅ Uninstallation complete"
echo "[v2rayA-uninstall] All binaries, data files, and service definitions have been removed"
