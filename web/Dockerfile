FROM --platform=${TARGETPLATFORM} ghcr.io/linuxserver/baseimage-ubuntu:jammy
ARG TARGETARCH

ARG NODE_VERSION=20.13.1
RUN if [ "${TARGETARCH}" = "amd64" ]; then \
        curl -Ljo node.tar.gz "https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.gz"; \
    elif [ "${TARGETARCH}" = "arm64" ]; then \
        curl -Ljo node.tar.gz "https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-arm64.tar.gz"; \
    else \
        echo "Unsupported architecture: ${TARGETARCH}"; \
        exit 1; \
    fi && \
    tar -xvf node.tar.gz --directory /usr/local --strip-components 1 && \
    rm node.tar.gz && \
    node --version

# install mcsm
ARG INSTALL_PATH=/opt/mcsm
ARG MCSM_VERSION=10.2.1
RUN mkdir -p ${INSTALL_PATH} && \
    curl -Ljo mcsm.tar.gz https://github.com/MCSManager/MCSManager/releases/download/v${MCSM_VERSION}/mcsmanager_linux_release.tar.gz && \
    tar -xvf mcsm.tar.gz ./web && \
    rm mcsm.tar.gz && \
    mv ./web ${INSTALL_PATH}/web

ENV TZ=Asia/Shanghai
ENV PUID=0
ENV PGID=0
VOLUME [ "${INSTALL_PATH}/web/data", "${INSTALL_PATH}/web/logs" ]
EXPOSE 23333
WORKDIR ${INSTALL_PATH}/web
CMD [ "node", "--max-old-space-size=8192", "--enable-source-maps", "app.js" ]
