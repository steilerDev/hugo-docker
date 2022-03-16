FROM debian:bullseye

ENV HUGO_VERSION 0.87.0
ENV HUGO_BINARY hugo_extended_${HUGO_VERSION}_Linux-64bit.deb
ENV NODE_VERSION 14.17.5
ENV NODE_BASE node-v${NODE_VERSION}-linux-x64
ENV NODE_BINARY_BASE /tmp/${NODE_BASE}/bin/

# Create working directory
VOLUME ["/src", "/site"]

# Install stuff and remove caches
RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get -y upgrade && \
    apt-get install \
        --no-install-recommends \
        --fix-missing \
        --assume-yes \
            apt-utils git ca-certificates asciidoc curl xz-utils imagemagick libstdc++6 && \
    apt-get clean autoclean && \
    apt-get autoremove && \
    rm -rf /var/lib/{apt,dpkg,cache,log} /tmp/* /var/tmp/*

# Download and install hugo
ADD https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/${HUGO_BINARY} /tmp/hugo.deb
RUN dpkg -i /tmp/hugo.deb && \
    rm /tmp/hugo.deb

# Installing staticrypt to protect member page
RUN curl https://nodejs.org/dist/v${NODE_VERSION}/${NODE_BASE}.tar.xz /tmp/node.tar.xz | tar -xJ -C /tmp
RUN ${NODE_BINARY_BASE}/node ${NODE_BINARY_BASE}/npm install -g staticrypt

# Applying fs patch for assets
ADD rootfs.tar.gz /
RUN chmod +x /opt/hugo/*.sh

ENTRYPOINT ["/opt/hugo/entry.sh"]