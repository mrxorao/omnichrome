# docker-chrome-novnc-mcp

A lightweight, robust, and fully persistent Google Chrome Docker environment featuring **real-time interactive GUI via noVNC**, **Openbox window management**, **remote debugging via Chrome DevTools Protocol (CDP)**, and seamless **Playwright MCP / AI automation** support.

---

## ✨ Features

* **Official Google Chrome Stable:** Always clean, modern, and up-to-date.
* **Interactive Web GUI (noVNC):** Access your browser live from any web browser without installing additional clients.
* **Direct VNC Support:** Connect with RealVNC, TigerVNC, or any standard VNC viewer.
* **Persistent User Profile & Downloads:** Cookies, sessions, extensions, history, and downloads persist safely on the host machine.
* **CDP Automation Bridge:** Pre-configured `socat` bridge on port `9222` for Playwright, Puppeteer, Selenium, and MCP agents.
* **Auto-Update with Safe Fallback:** Optional automatic Chrome upgrade on container startup without breaking on network outages.
* **Dynamic Proxy Support:** Built-in HTTP and SOCKS proxy support via environment variables.
* **Optional VNC Authentication:** Secure your VNC/noVNC session with a password when deploying to VPS/Cloud.
* **Full Multilingual & Emoji Font Support:** Includes `fonts-noto-color-emoji`, `fonts-noto-cjk`, and configurable timezones (`TZ=UTC`).

---

## 🚀 Quick Access

| Service | Address / Port | Description |
| :--- | :--- | :--- |
| **noVNC Web Interface** | [http://localhost:6080/vnc.html?autoconnect=true&resize=scale](http://localhost:6080/vnc.html?autoconnect=true&resize=scale) | Interactive browser view |
| **Direct VNC** | `localhost:5900` | Native VNC client connection |
| **CDP Endpoint** | `http://localhost:9222` | Playwright MCP / AI automation bridge |
| **Profile Data** | `./data/default` | Chrome user profile directory on host |
| **Downloads Folder** | `./data/default/Downloads` | Persistent downloaded files on host |

---

## 📥 How to Install & Run

### Option 1: Single-File Setup with `docker-compose.yml` (Easiest - No Dockerfile Needed)

Create a `docker-compose.yml` file on your server or PC with the following content:

```yaml
services:
  chrome:
    image: xorao/docker-chrome-novnc-mcp:latest
    container_name: chrome-default
    restart: unless-stopped
    ports:
      - "6080:6080" # noVNC Web UI (http://localhost:6080)
      - "5900:5900" # Direct VNC (localhost:5900)
      - "9222:9222" # CDP Remote Debugging (http://localhost:9222)
    environment:
      - DISPLAY=:99
      - RESOLUTION_WIDTH=1366
      - RESOLUTION_HEIGHT=768
      - TZ=UTC
      - AUTO_UPDATE=true
      - PROXY_SERVER= # Optional: http://user:pass@ip:port
      - VNC_PASSWORD= # Optional: Set a password for public VPS
    volumes:
      - ./data/default:/data/profile
    shm_size: "2gb"
```

Then simply start it with:
```bash
docker compose up -d
```
*(Docker will pull the pre-built image from Docker Hub and start immediately).*

---

### Option 2: Standalone `docker run` (Zero Files Needed)

Run everything directly in a single command line without creating any files:

```bash
docker run -d \
  --name chrome-default \
  --restart unless-stopped \
  -p 6080:6080 \
  -p 5900:5900 \
  -p 9222:9222 \
  --shm-size=2gb \
  -e TZ=UTC \
  -e AUTO_UPDATE=true \
  -v $(pwd)/data/default:/data/profile \
  xorao/docker-chrome-novnc-mcp:latest
```

---

### Option 3: Clone Repository & Build Locally

If you want to modify the source code or `Dockerfile`:

```bash
git clone https://github.com/mrxorao/docker-chrome-novnc-mcp.git
cd docker-chrome-novnc-mcp
docker compose up -d --build
```

---

## 🛠️ Management Commands

```bash
# Stop the container
docker compose down

# Restart the container
docker compose restart

# View live logs
docker compose logs -f

# Pull and update to the latest image
docker compose pull && docker compose up -d
```

---

## 🤖 Playwright MCP Integration

To connect Antigravity, Claude Desktop, Cursor, or any MCP client to this Chrome container, configure your `mcp_config.json`:

```json
{
  "mcpServers": {
    "browser": {
      "command": "node",
      "args": [
        "./node_modules/@playwright/mcp/cli.js",
        "--cdp-endpoint",
        "http://localhost:9222"
      ]
    }
  }
}
```

Or test with Playwright directly:
```bash
npm install
node examples/playwright_example.js
```

---

## 📁 Persistent Storage Architecture

* **Profile Data:** Stored in `./data/default`. All logins, cookies, history, and installed extensions persist across container updates.
* **Downloads:** All files downloaded inside Chrome automatically map to `./data/default/Downloads` on your host system.

---

## 📄 License

This project is open-source and available under the [MIT License](LICENSE).
