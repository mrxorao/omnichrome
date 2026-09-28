#!/usr/bin/env bash
set -e

# Ensure required directories and persistent download symlink
mkdir -p /data/profile/Downloads /var/log/supervisor /tmp/.X11-unix
rm -rf /root/Downloads
ln -sf /data/profile/Downloads /root/Downloads

# Clean stale X11 lock files
rm -f /tmp/.X99-lock /tmp/.X11-unix/X99

# Auto-update Google Chrome if AUTO_UPDATE=true (with network failure tolerance)
if [ "$AUTO_UPDATE" = "true" ]; then
    echo "[Entrypoint] Checking for Google Chrome updates on boot..."
    (apt-get update -qq && apt-get install --only-upgrade -y --no-install-recommends google-chrome-stable) || echo "[Entrypoint] Notice: Failed to update Google Chrome, booting with installed version."
fi

echo "[Entrypoint] Starting supervisor services (Xvfb, Openbox, x11vnc, noVNC, Google Chrome, socat)..."
exec /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf
