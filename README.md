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

### Prerequisites
* [Docker](https://www.docker.com/) and [Docker Compose](https://docs.docker.com/compose/) installed on your machine.
* [Node.js](https://nodejs.org/) *(Optional, only if running local Playwright scripts or Playwright MCP)*.

---

### Option 1: Quick Start with Docker Compose (Recommended)

1. **Clone the repository:**
   ```bash
   git clone https://github.com/mrxorao/docker-chrome-novnc-mcp.git
   cd docker-chrome-novnc-mcp
   ```

2. **Start the container:**
   ```bash
   docker compose up -d
   ```
   *(Docker Compose will automatically pull the pre-built image from Docker Hub and start in seconds).*

3. **Open the browser:**
   * Navigate to: [http://localhost:6080](http://localhost:6080)

---

### Option 2: Standalone `docker run` (Zero Clone Needed)

You can run the container directly without cloning the repository:

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

### Option 3: Build Locally from Source

If you want to customize the Dockerfile and build locally:

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

# View live container logs
docker compose logs -f

# Force re-download / rebuild latest version
docker compose build --no-cache
docker compose up -d
```

---

## ⚙️ Configuration & Environment Variables

Edit `docker-compose.yml` to customize your environment:

```yaml
services:
  chrome:
    environment:
      # Display & Resolution
      - RESOLUTION_WIDTH=1366
      - RESOLUTION_HEIGHT=768
      - TZ=UTC

      # Automatic Chrome Updates
      - AUTO_UPDATE=true

      # Proxy Configuration (Optional)
      # Supports: http://user:pass@host:port or socks5://host:port
      - PROXY_SERVER=

      # VNC Password Protection (Optional)
      # Leave blank for open local access, or set a password for public VPS
      - VNC_PASSWORD=
```

---

## 🤖 Playwright MCP Integration

To connect Antigravity or any MCP client to this Chrome container, configure your `mcp_config.json`:

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

Or run an automated Playwright test:
```bash
npm install
node examples/playwright_example.js
```

---

## 📁 Persistent Storage Architecture

* **Profile Data:** Stored in `./data/default`. All logins, cookies, history, and installed extensions persist across container rebuilds.
* **Downloads:** All files downloaded inside Chrome automatically map to `./data/default/Downloads` on your host system.

---

## 📄 License

This project is open-source and available under the [MIT License](LICENSE).
