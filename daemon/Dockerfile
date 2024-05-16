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
ENV MCSM_PATH=/opt/mcsm
ARG MCSM_VERSION=10.2.1
RUN mkdir -p ${MCSM_PATH} && \
    curl -Ljo mcsm.tar.gz https://github.com/MCSManager/MCSManager/releases/download/v${MCSM_VERSION}/mcsmanager_linux_release.tar.gz && \
    tar -xvf mcsm.tar.gz ./daemon && \
    rm mcsm.tar.gz && \
    mv ./daemon ${MCSM_PATH}/daemon && \
    chown root:root -R ${MCSM_PATH}

# install openjdk
ARG JDK_VERSION=nojdk
RUN if [ "${JDK_VERSION}" = "nojdk" ]; then \
        echo "skip installing openjdk"; \
    else \
        apt update && \
        apt install -y openjdk-${JDK_VERSION}-jre-headless && \
        apt clean && \
        java -version; \
    fi

COPY root/ /

ENV TZ=Asia/Shanghai
ENV PUID=0
ENV PGID=0
VOLUME [ "${MCSM_PATH}/daemon/data", "${MCSM_PATH}/daemon/logs" ]
EXPOSE 24444 25565-25575
