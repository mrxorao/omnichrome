#!/usr/bin/env bash
# Auto-restore and keep Chrome maximized

export DISPLAY=:99

while true; do
    # Search for Chrome windows and activate/unminimize them if they exist
    if command -v xdotool >/dev/null 2>&1; then
        WIDS=$(xdotool search --class "google-chrome" 2>/dev/null || true)
        for wid in $WIDS; do
            xdotool windowactivate "$wid" 2>/dev/null || true
        done
    fi
    sleep 2
done
