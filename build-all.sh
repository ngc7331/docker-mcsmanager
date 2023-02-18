#!/bin/bash

if [[ -z $DOCKERHUB_USER || -z $DOCKERHUB_PASS ]]; then
    echo "Please set DOCKERHUB_USER and DOCKERHUB_PASS in your env" && exit 1
fi

JDK_VERSIONS="8 11 17"
MCSM_VERSION=$(curl "https://raw.githubusercontent.com/MCSManager/MCSManager-Daemon-Production/master/package.json" | jq -r ".version")

# build
for i in $JDK_VERSIONS; do
    docker build -f ./dockerfile-daemon \
                 -t $DOCKERHUB_USER/mcsmanager-daemon:$MCSM_VERSION-jdk$i \
                 -t $DOCKERHUB_USER/mcsmanager-daemon:latest-jdk$i \
                 --build-arg JDK_VERSION=$i \
                 . || echo "Build FAILED"
done

docker tag $DOCKERHUB_USER/mcsmanager-daemon:latest-jdk17 $DOCKERHUB_USER/mcsmanager-daemon:latest

# push
echo $DOCKERHUB_PASS | docker login --username $DOCKERHUB_USER --password-stdin
docker push -a $DOCKERHUB_USER/mcsmanager-daemon
