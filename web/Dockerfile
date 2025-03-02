FROM ghcr.io/ngc7331/linuxserver-baseimage-alpine:3.21
ARG TARGETARCH

RUN apk add --no-cache \
        nodejs && \
    node --version

# install mcsm
ENV MCSM_PATH=/opt/mcsm
ARG MCSM_VERSION=10.5.0
RUN mkdir -p ${MCSM_PATH} && \
    curl -Ljo mcsm.tar.gz https://github.com/MCSManager/MCSManager/releases/download/v${MCSM_VERSION}/mcsmanager_linux_release.tar.gz && \
    tar -xvf mcsm.tar.gz mcsmanager/web --strip-components=1 && \
    rm mcsm.tar.gz && \
    mv ./web ${MCSM_PATH}/web && \
    chown root:root -R ${MCSM_PATH}

COPY root/ /

ENV TZ=Asia/Shanghai
ENV PUID=0
ENV PGID=0
VOLUME [ "${MCSM_PATH}/web/data", "${MCSM_PATH}/web/logs" ]
EXPOSE 23333
