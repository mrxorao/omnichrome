#!/usr/bin/env bash
# Auto-restore Chrome ONLY when no window is active

export DISPLAY=:99

while true; do
    if command -v xdotool >/dev/null 2>&1; then
        ACTIVE_WID=$(xdotool getactivewindow 2>/dev/null || true)
        if [ -z "$ACTIVE_WID" ]; then
            WID=$(xdotool search --class "google-chrome" 2>/dev/null | head -n 1 || true)
            if [ -n "$WID" ]; then
                xdotool windowactivate "$WID" 2>/dev/null || true
            fi
        fi
    fi
    sleep 5
done
