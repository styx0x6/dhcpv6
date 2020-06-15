FROM alpine:latest

LABEL description="Lightweight DCHPv6 service based on dnsmasq & webproc"
LABEL maintainer="styx0x6 <https://github.com/styx0x6>"

# Set args
ARG WEBPROC_VERSION="0.4.0"
ARG WEBPROC_URL="https://github.com/jpillora/webproc/releases/download/v${WEBPROC_VERSION}/webproc_${WEBPROC_VERSION}_linux_amd64.gz"

# Set env
ENV WP_MAX_LINES="5000"
ENV DNSMASQ_LOG="/var/log/dnsmasq.log"
ENV DNSMASQ_CONF_SRV="/etc/dnsmasq.d/0.service.conf"
ENV DNSMASQ_CONF_DHCP="/etc/dnsmasq.d/1.dhcpv6.conf"
# webproc specific env
ENV PORT="6789"
ENV HTTP_USER=""
ENV HTTP_PASS=""

# Fetch binaries
RUN apk update && \
    apk add --no-cache dnsmasq && \
    apk add --no-cache --virtual .tmp-tools-package curl && \
    curl -sL $WEBPROC_URL | gzip -d - > /usr/local/bin/webproc && \
    chmod +x /usr/local/bin/webproc && \
    apk del .tmp-tools-package

# Deploy default configuration for dnsmasq
RUN mkdir -p /etc/default
COPY etc/default/dnsmasq /etc/default/dnsmasq

COPY etc/dnsmasq.conf /etc/dnsmasq.conf
COPY etc/dnsmasq.d/0.service.conf $DNSMASQ_CONF_SRV
COPY etc/dnsmasq.d/1.dhcpv6.conf $DNSMASQ_CONF_DHCP

COPY entrypoint.sh /entrypoint.sh

# Expose service ports
EXPOSE $PORT/tcp
EXPOSE 547/udp

# Entrypoint
ENTRYPOINT ["/entrypoint.sh"]