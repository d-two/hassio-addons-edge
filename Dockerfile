ARG BUILD_FROM=ghcr.io/hassio-addons/base:14.3.1
# hadolint ignore=DL3006

ARG FAIL2BAN_VERSION=1.0.2

FROM ${BUILD_FROM}
ARG FAIL2BAN_VERSION

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apk --update --no-cache add \
    bash \
    curl \
    grep \
    ipset \
    iptables \
    ip6tables \
    kmod \
    nftables \
    openssh-client-default \
    python3 \
    ssmtp \
    tzdata \
    wget \
    whois \
  && apk --update --no-cache add -t build-dependencies \
    build-base \
    py3-pip \
    py3-setuptools \
    python3-dev \
  && pip3 install --no-cache-dir --upgrade pip \
  && pip3 install --no-cache-dir dnspython3 pyinotify \
  && mkdir -p /src/fail2ban \
  && wget https://github.com/fail2ban/fail2ban/archive/refs/tags/${FAIL2BAN_VERSION}.tar.gz -O /src/fail2ban-master.tar.gz \
  && cd /src \
  && tar xfvz fail2ban-master.tar.gz --strip-components 1 -C /src/fail2ban && rm fail2ban-master.tar.gz \
  && cd /src/fail2ban \
  && 2to3 -w --no-diffs bin/* fail2ban \
  && python3 setup.py install --without-tests \
  && apk del build-dependencies \
  && rm -rf /etc/fail2ban/jail.d /root/.cache

COPY rootfs/ /

# Build arguments
ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_DESCRIPTION
ARG BUILD_NAME
ARG BUILD_REF
ARG BUILD_REPOSITORY
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="${BUILD_NAME}" \
    io.hass.description="${BUILD_DESCRIPTION}" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="Franck Nijhof <frenck@addons.community>" \
    org.opencontainers.image.title="${BUILD_NAME}" \
    org.opencontainers.image.description="${BUILD_DESCRIPTION}" \
    org.opencontainers.image.vendor="Home Assistant Community Add-ons" \
    org.opencontainers.image.authors="Franck Nijhof <frenck@addons.community>" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.url="https://addons.community" \
    org.opencontainers.image.source="https://github.com/${BUILD_REPOSITORY}" \
    org.opencontainers.image.documentation="https://github.com/${BUILD_REPOSITORY}/blob/main/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}
