FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive \
    DISPLAY=:99 \
    RESOLUTION_WIDTH=1366 \
    RESOLUTION_HEIGHT=768 \
    TZ=UTC

# Install system dependencies, Xvfb, Openbox, x11vnc, noVNC, websockify, fonts (including emojis & CJK), and utilities
RUN apt-get update && apt-get install -y --no-install-recommends \
    xvfb \
    openbox \
    x11vnc \
    novnc \
    websockify \
    supervisor \
    curl \
    wget \
    gnupg \
    ca-certificates \
    tzdata \
    locales \
    fonts-liberation \
    fonts-dejavu \
    fonts-noto-color-emoji \
    fonts-noto-cjk \
    procps \
    net-tools \
    socat \
    && rm -rf /var/lib/apt/lists/*

# Install official Google Chrome Stable
RUN curl -fsSL https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/google-chrome.gpg \
    && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list \
    && apt-get update && apt-get install -y --no-install-recommends google-chrome-stable \
    && rm -rf /var/lib/apt/lists/*

# Create profile, download, and supervisor directories
RUN mkdir -p /data/profile /data/profile/Downloads /var/log/supervisor /etc/supervisor/conf.d

# Copy configuration scripts and entrypoints
COPY supervisord.conf /etc/supervisor/supervisord.conf
COPY entrypoint.sh /entrypoint.sh
COPY launch-chrome.sh /launch-chrome.sh
COPY launch-x11vnc.sh /launch-x11vnc.sh
RUN chmod +x /entrypoint.sh /launch-chrome.sh /launch-x11vnc.sh

# Symlink to access noVNC directly via root path or vnc.html
RUN ln -s /usr/share/novnc/vnc.html /usr/share/novnc/index.html

EXPOSE 6080 5900 9222

ENTRYPOINT ["/entrypoint.sh"]
