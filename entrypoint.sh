#!/usr/bin/env bash
set -e

# Ensure required directories and persistent download symlink
mkdir -p /data/profile/Downloads /var/log/supervisor /tmp/.X11-unix /etc/opt/chrome/policies/managed
rm -rf /root/Downloads
ln -sf /data/profile/Downloads /root/Downloads

# Clean stale X11 lock files
rm -f /tmp/.X99-lock /tmp/.X11-unix/X99

# Configure default search engine and homepage dynamically based on SEARCH_ENGINE variable
ENGINE_CHOICE=$(echo "${SEARCH_ENGINE:-google}" | tr '[:upper:]' '[:lower:]')

case "$ENGINE_CHOICE" in
    duckduckgo|ddg)
        ENGINE_NAME="DuckDuckGo"
        SEARCH_URL="https://duckduckgo.com/?q={searchTerms}"
        SUGGEST_URL="https://duckduckgo.com/ac/?q={searchTerms}&type=list"
        ICON_URL="https://duckduckgo.com/favicon.ico"
        DEFAULT_HOME="https://duckduckgo.com"
        ;;
    bing)
        ENGINE_NAME="Bing"
        SEARCH_URL="https://www.bing.com/search?q={searchTerms}"
        SUGGEST_URL="https://www.bing.com/osjson.aspx?query={searchTerms}"
        ICON_URL="https://www.bing.com/favicon.ico"
        DEFAULT_HOME="https://www.bing.com"
        ;;
    *)
        ENGINE_NAME="Google"
        SEARCH_URL="https://www.google.com/search?q={searchTerms}"
        SUGGEST_URL="https://www.google.com/complete/search?client=chrome&q={searchTerms}"
        ICON_URL="https://www.google.com/favicon.ico"
        DEFAULT_HOME="https://www.google.com"
        ;;
esac

FINAL_HOME="${HOMEPAGE_URL:-$DEFAULT_HOME}"

cat <<EOF > /etc/opt/chrome/policies/managed/policies.json
{
  "DefaultSearchProviderEnabled": true,
  "DefaultSearchProviderName": "$ENGINE_NAME",
  "DefaultSearchProviderSearchURL": "$SEARCH_URL",
  "DefaultSearchProviderSuggestURL": "$SUGGEST_URL",
  "DefaultSearchProviderIconURL": "$ICON_URL",
  "HomepageLocation": "$FINAL_HOME",
  "HomepageIsNewTabPage": false
}
EOF

# Auto-update Google Chrome if AUTO_UPDATE=true (with network failure tolerance)
if [ "$AUTO_UPDATE" = "true" ]; then
    echo "[Entrypoint] Checking for Google Chrome updates on boot..."
    (apt-get update -qq && apt-get install --only-upgrade -y --no-install-recommends google-chrome-stable) || echo "[Entrypoint] Notice: Failed to update Google Chrome, booting with installed version."
fi

echo "[Entrypoint] Starting OmniChrome with Search Engine: $ENGINE_NAME and Homepage: $FINAL_HOME..."
exec /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf
