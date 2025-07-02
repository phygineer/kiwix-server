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

# Set working dir for data
WORKDIR /data
EXPOSE 8080

# 🧠 Run the loop, then kiwix-serve
CMD sh -c 'rm -f library.xml && find . -type f -name "*.zim" | while read -r f; do kiwix-manage library.xml add $f; done && kiwix-serve --port=8080 --library library.xml'

