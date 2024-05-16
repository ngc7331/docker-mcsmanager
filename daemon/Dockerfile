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

ARG INSTALL_PATH=/opt/mcsm
ARG JDK_VERSION

# install git & openjdk
# add bullseye repo for openjdk-17, stretch repo for openjdk-8, openjdk-11 is already included in default buster repo
RUN echo "deb http://deb.debian.org/debian bullseye main" >> /etc/apt/sources.list && \
    echo "deb http://archive.debian.org/debian-archive/debian stretch main" >> /etc/apt/sources.list && \
    apt update && \
    apt install -y git openjdk-$JDK_VERSION-jre-headless

# install mcsm
RUN git clone https://github.com/MCSManager/MCSManager-Daemon-Production $INSTALL_PATH/daemon && \
    cd $INSTALL_PATH/daemon && \
    npm i --production

ENV TZ=Asia/Shanghai
ENV PUID=0
ENV PGID=0
ENV UMASK=022
VOLUME [ "$INSTALL_PATH/daemon/data", "$INSTALL_PATH/daemon/logs" ]
EXPOSE 24444 25565-25575
WORKDIR $INSTALL_PATH/daemon
CMD [ "node", "app.js" ]
