ARG BUILD_FROM=ghcr.io/hassio-addons/base-nodejs:0.2.2
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Build arguments
ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_DESCRIPTION
ARG BUILD_NAME
ARG BUILD_REF
ARG BUILD_REPOSITORY
ARG BUILD_VERSION

# Redirect log output to the add-on log
RUN \
sed -i 's#access_log /proc/1/fd/1#access_log /share/nginxproxymanager/logs/dead-host-{{ id }}_access.log#g' /opt/nginx-proxy-manager/templates/dead_host.conf  && \
sed -i 's#error_log /proc/1/fd/1#error_log /share/nginxproxymanager/logs/dead-host-{{ id }}_error.log#g' /opt/nginx-proxy-manager/templates/dead_host.conf && \
sed -i 's#access_log /proc/1/fd/1#access_log /share/nginxproxymanager/logs/redirection-host-{{ id }}_access.log#g' /opt/nginx-proxy-manager/templates/redirection_host.conf && \
sed -i 's#error_log /proc/1/fd/1#error_log /share/nginxproxymanager/logs/redirection-host-{{ id }}_error.log#g' /opt/nginx-proxy-manager/templates/redirection_host.conf && \
sed -i 's#access_log /proc/1/fd/1#access_log /share/nginxproxymanager/logs/proxy-host-{{ id }}_access.log#g' /opt/nginx-proxy-manager/templates/proxy_host.conf && \
sed -i 's#error_log /proc/1/fd/1#error_log /share/nginxproxymanager/logs/proxy-host-{{ id }}_error.log#g' /opt/nginx-proxy-manager/templates/proxy_host.conf

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
