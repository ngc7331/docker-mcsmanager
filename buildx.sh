#!/bin/bash

PLATFORMS=linux/amd64,linux/arm64

DOCKER_USER=ngc7331
DOCKER_REPO=mcsmanager

VERSION=10.2.1

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
JDK_DEFAULT=17
JDK_VERSIONS=(nojdk 8 17)
for JDK in ${JDK_VERSIONS[@]}; do
    echo "-> JDK: ${JDK}"

    if [ "${JDK}" = "nojdk" ]; then
        TAG_SUFFIX=(-nojdk)
    else
        TAG_SUFFIX=(-jdk${JDK})
    fi

    if [ "${JDK}" = "${JDK_DEFAULT}" ]; then
        TAG_SUFFIX+=("")
    fi

    docker buildx build \
        --platform ${PLATFORMS} \
        --build-arg MCSM_VERSION="${VERSION}" \
        --build-arg JDK_VERSION="${JDK}" \
        ${TAG_SUFFIX[@]/#/"-t ${DOCKER_USER}/${DOCKER_REPO}-daemon:latest"} \
        ${TAG_SUFFIX[@]/#/"-t ${DOCKER_USER}/${DOCKER_REPO}-daemon:${VERSION}"} \
        --push .
done
cd -
