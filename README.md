Here’s the updated `README.md` including your note about Apple Silicon and architecture flexibility:

---

## 📚 Kiwix Docker Library Server

Serve `.zim` files (offline Wikipedia, Wiktionary, etc.) using [Kiwix Tools](https://wiki.kiwix.org/wiki/Kiwix-tools) inside a lightweight Docker container.

> 🔗 [Explore public Kiwix library](https://library.kiwix.org/#lang=eng)

---

### 🛠 Features

* Automatically scans and adds all `.zim` files from `/zim` folder
* Generates `library.xml` on container startup
* Serves via `kiwix-serve` on port `8080`
* Built for Apple Silicon / ARMv8
  *(You can change the platform in `docker-compose.yml` and update the Dockerfile with the appropriate Kiwix tools archive — see [available builds](https://download.kiwix.org/release/kiwix-tools/))*

---

### 📂 Setup

1. **Put your `.zim` files** inside a `zim/` directory (next to your Docker files):

   ```
   project-root/
   ├── docker-compose.yml
   ├── Dockerfile
   └── zim/
       ├── wikipedia_en.zim
       ├── wiktionary_en.zim
       └── ...
   ```

2. **Build and run**:

   ```bash
   docker-compose up --build -d
   ```

3. **Access your offline library**:

   ```
   http://localhost:8080
   ```

---

### 📦 Docker Compose

```yaml
services:
  kiwix:
    build: .
    container_name: kiwix_library_server
    image: phygineer/kiwix-server:latest
    ports:
      - "8080:8080"
    volumes:
      - ./zim:/data
    platform: linux/arm64
```

---

### 🐳 Dockerfile

```Dockerfile
FROM ubuntu

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && \
    apt-get install -y wget tar curl ca-certificates && \
    apt-get clean

# Set working directory for install
WORKDIR /opt

# Download and install Kiwix tools (ARMv8)
RUN wget -O kiwix.tar.gz https://download.kiwix.org/release/kiwix-tools/kiwix-tools_linux-armv8-3.7.0-2.tar.gz && \
    tar -xzf kiwix.tar.gz && \
    cp kiwix-tools_linux-armv8-3.7.0-2/kiwix-* /usr/local/bin/ && \
    chmod +x /usr/local/bin/kiwix-* && \
    rm -rf kiwix-tools_linux-armv8-3.7.0-2 kiwix.tar.gz

# Working directory for ZIM files
WORKDIR /data
EXPOSE 8080

# Generate library.xml and serve content
CMD sh -c 'rm -f library.xml && find . -type f -name "*.zim" | while read -r f; do kiwix-manage library.xml add "$f"; done && kiwix-serve --port=8080 --library library.xml'
```

---

### ✅ Notes

* Supports any valid `.zim` file from [Kiwix content library](https://wiki.kiwix.org/wiki/Content_in_all_languages)
* No rebuild required when adding new `.zim` files — just restart:

  ```bash
  docker-compose restart
  ```
* For non-ARM systems, update:

  * `platform:` in `docker-compose.yml` (e.g., `linux/amd64`)
  * The Kiwix tools archive URL in the `Dockerfile`

---

Let me know if you want this published as a GitHub repo or containerized with full-text search and multilingual support.
