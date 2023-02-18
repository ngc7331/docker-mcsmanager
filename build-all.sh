#!/bin/bash

if [[ -z $DOCKERHUB_USER || -z $DOCKERHUB_PASS ]]; then
    echo "Please set DOCKERHUB_USER and DOCKERHUB_PASS in your env" && exit 1
fi

# daemon
JDK_VERSIONS="8 11 17"
MCSM_DAEMON_VERSION=$(curl "https://raw.githubusercontent.com/MCSManager/MCSManager-Daemon-Production/master/package.json" | jq -r ".version")

for i in $JDK_VERSIONS; do
    echo "=== Building mcsmanager-daemon:$MCSM_DAEMON_VERSION-jdk$i"

    docker build -f ./dockerfile-daemon \
                 -t $DOCKERHUB_USER/mcsmanager-daemon:$MCSM_DAEMON_VERSION-jdk$i \
                 -t $DOCKERHUB_USER/mcsmanager-daemon:latest-jdk$i \
                 --build-arg JDK_VERSION=$i \
                 . || echo "=== Build Failed ==="
done

docker tag $DOCKERHUB_USER/mcsmanager-daemon:latest-jdk17 $DOCKERHUB_USER/mcsmanager-daemon:latest

# web
MCSM_WEB_VERSION=$(curl "https://raw.githubusercontent.com/MCSManager/MCSManager-Web-Production/master/package.json" | jq -r ".version")

echo "=== Building mcsmanager-web:$MCSM_WEB_VERSION"

docker build -f ./dockerfile-web \
             -t $DOCKERHUB_USER/mcsmanager-web:$MCSM_WEB_VERSION \
             -t $DOCKERHUB_USER/mcsmanager-web:latest \
             . || echo "=== Build Failed ==="

# push
echo "=== Pushing to Docker Hub ==="

echo $DOCKERHUB_PASS | docker login --username $DOCKERHUB_USER --password-stdin
docker push -a $DOCKERHUB_USER/mcsmanager-daemon
docker push -a $DOCKERHUB_USER/mcsmanager-web
