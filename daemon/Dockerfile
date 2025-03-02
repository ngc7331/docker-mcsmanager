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
    tar -xvf mcsm.tar.gz mcsmanager/daemon --strip-components=1 && \
    rm mcsm.tar.gz && \
    mv ./daemon ${MCSM_PATH}/daemon && \
    chown root:root -R ${MCSM_PATH} && \
    chmod a+x ${MCSM_PATH}/daemon/lib/*

COPY root/ /

# pre-install openjdk
ARG PREINSTALL_JDK_VERSION
ENV PREINSTALL_JDK_VERSION=${PREINSTALL_JDK_VERSION}
ENV JDK_VERSION=
RUN /app/install_jdk.sh ${PREINSTALL_JDK_VERSION}

ENV TZ=Asia/Shanghai
ENV PUID=0
ENV PGID=0
VOLUME [ "${MCSM_PATH}/daemon/data", "${MCSM_PATH}/daemon/logs" ]
EXPOSE 24444 25565-25575
