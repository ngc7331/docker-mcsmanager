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

# install git
RUN apt update && \
    apt install -y git

# install mcsm
RUN git clone --single-branch -b master --depth 1 https://github.com/MCSManager/MCSManager-Web-Production $INSTALL_PATH/web && \
    cd $INSTALL_PATH/web && \
    npm i --production

ENV TZ=Asia/Shanghai
VOLUME [ "$INSTALL_PATH/web/data", "$INSTALL_PATH/web/logs" ]
EXPOSE 23333
WORKDIR $INSTALL_PATH/web
CMD [ "node", "app.js" ]
