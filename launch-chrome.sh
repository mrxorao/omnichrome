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

# Determine default startup URL
ENGINE_CHOICE=$(echo "${SEARCH_ENGINE:-google}" | tr '[:upper:]' '[:lower:]')
case "$ENGINE_CHOICE" in
    duckduckgo|ddg)
        DEFAULT_URL="https://duckduckgo.com"
        ;;
    bing)
        DEFAULT_URL="https://www.bing.com"
        ;;
    *)
        DEFAULT_URL="https://www.google.com"
        ;;
esac

TARGET_URL="${HOMEPAGE_URL:-$DEFAULT_URL}"

exec google-chrome-stable \
    --no-sandbox \
    --test-type \
    --disable-dev-shm-usage \
    --disable-gpu \
    --disable-software-rasterizer \
    --renderer-process-limit=3 \
    --js-flags="--max-old-space-size=512" \
    --aggressive-cache-discard \
    --disk-cache-size=104857600 \
    --enable-features=MemorySaverMode,AutomaticTabDiscarding \
    --disable-features=TranslateUI,BackForwardCache \
    --disable-background-networking \
    --disable-sync \
    --no-first-run \
    --no-default-browser-check \
    --remote-debugging-port=9223 \
    --remote-allow-origins=* \
    --user-data-dir=/data/profile \
    --window-size="${RESOLUTION_WIDTH:-1366},${RESOLUTION_HEIGHT:-768}" \
    --window-position=0,0 \
    --start-maximized \
    $EXTRA_ARGS \
    "$TARGET_URL"
