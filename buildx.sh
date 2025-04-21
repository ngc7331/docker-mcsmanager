#!/bin/bash

set -e

PLATFORMS=linux/amd64,linux/arm64,linux/riscv64

DOCKER_USER=ngc7331
DOCKER_REPO=mcsmanager

VERSION=$(grep -oP "(?<=mcsmanager version: ).*" README.md)

echo === build web ===
cd web
docker buildx build \
    --platform ${PLATFORMS} \
    --build-arg MCSM_VERSION=${VERSION} \
    -t ${DOCKER_USER}/${DOCKER_REPO}-web:latest \
    -t ${DOCKER_USER}/${DOCKER_REPO}-web:${VERSION} \
    --push .
cd -

echo === build daemon ===
cd daemon
JDK_DEFAULT=21
JDK_VERSIONS=(nojdk 21 22)
for JDK in ${JDK_VERSIONS[@]}; do
    echo "-> JDK: ${JDK}"

    if [ "${JDK}" = "nojdk" ]; then
        TAG_SUFFIX=(-nojdk)
        PREINSTALL_JDK_VERSION=""
    else
        TAG_SUFFIX=(-jdk${JDK})
        PREINSTALL_JDK_VERSION=${JDK}
    fi

    if [ "${JDK}" = "${JDK_DEFAULT}" ]; then
        TAG_SUFFIX+=("")
    fi

    # remove linux/riscv64 for lower JDK versions
    if [ "${JDK}" != "nojdk" ] && [ "${JDK}" -le 21 ]; then
        PLATFORMS=${PLATFORMS/,linux\/riscv64/}
    fi

    docker buildx build \
        --platform ${PLATFORMS} \
        --build-arg MCSM_VERSION="${VERSION}" \
        --build-arg PREINSTALL_JDK_VERSION="${PREINSTALL_JDK_VERSION}" \
        ${TAG_SUFFIX[@]/#/"-t ${DOCKER_USER}/${DOCKER_REPO}-daemon:latest"} \
        ${TAG_SUFFIX[@]/#/"-t ${DOCKER_USER}/${DOCKER_REPO}-daemon:${VERSION}"} \
        --push .
done
cd -
