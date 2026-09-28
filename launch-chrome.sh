#!/usr/bin/env bash
set -e

# Clean stale Chrome locks if the container stopped unexpectedly
rm -f /data/profile/Singleton* /data/profile/.org.chromium.Chromium.*

EXTRA_ARGS=""

# Dynamic HTTP/SOCKS proxy support configured via environment variables
if [ -n "$PROXY_SERVER" ]; then
    echo "[Chrome] Enabling proxy: $PROXY_SERVER"
    EXTRA_ARGS="$EXTRA_ARGS --proxy-server=$PROXY_SERVER --proxy-bypass-list=localhost,127.0.0.1,*.local"
elif [ -n "$HTTP_PROXY" ]; then
    echo "[Chrome] Enabling proxy via HTTP_PROXY: $HTTP_PROXY"
    EXTRA_ARGS="$EXTRA_ARGS --proxy-server=$HTTP_PROXY --proxy-bypass-list=localhost,127.0.0.1,*.local"
fi

exec google-chrome-stable \
    --no-sandbox \
    --disable-dev-shm-usage \
    --remote-debugging-port=9223 \
    --remote-allow-origins=* \
    --user-data-dir=/data/profile \
    --window-size="${RESOLUTION_WIDTH:-1366},${RESOLUTION_HEIGHT:-768}" \
    --window-position=0,0 \
    --start-maximized \
    --no-first-run \
    --no-default-browser-check \
    --disable-background-networking \
    --disable-features=TranslateUI \
    --disable-sync \
    $EXTRA_ARGS \
    https://www.google.com
