FROM ghcr.io/kiwix/kiwix-tools:3.7.0

# Set working dir for data
WORKDIR /data
EXPOSE 8080

# Generate library.xml based on zim files & then kiwix-serve
CMD sh -c 'rm -f library.xml && find . -type f -name "*.zim" | while read -r f; do kiwix-manage library.xml add $f; done && kiwix-serve --port=8080 --library library.xml'

