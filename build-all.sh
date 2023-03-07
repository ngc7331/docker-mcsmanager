#!/bin/bash

if [[ -z $DOCKERHUB_USER || -z $DOCKERHUB_PASS ]]; then
    echo "Please set DOCKERHUB_USER and DOCKERHUB_PASS in your env" && exit 1
fi

if [[ -z $VERSION_FILE ]]; then
    VERSION_FILE=README.md
fi
if [[ -z $GIT_TRACK ]]; then
    GIT_TRACK=false
fi
if [[ -z $FORCED_BUILD ]]; then
    FORCED_BUILD=true
fi

# daemon
JDK_VERSIONS="8 11 17"
MCSM_DAEMON_VERSION=$(curl "https://raw.githubusercontent.com/MCSManager/MCSManager-Daemon-Production/master/package.json" | jq -r ".version")
LATEST_BUILD=$(sed -n "s/Daemon: //p" $VERSION_FILE)

if [[ $MCSM_DAEMON_VERSION != $LATEST_BUILD ]] || $FORCED_BUILD; then
    sed -i "s/Daemon: .*/Daemon: $MCSM_DAEMON_VERSION/" $VERSION_FILE
    if $GIT_TRACK; then
        git add $VERSION_FILE && git commit -m "build: daemon $MCSM_DAEMON_VERSION" && git push
    fi

    for i in $JDK_VERSIONS; do
        echo "=== Building mcsmanager-daemon:$MCSM_DAEMON_VERSION-jdk$i"

        docker build -f ./dockerfile-daemon \
                     -t $DOCKERHUB_USER/mcsmanager-daemon:$MCSM_DAEMON_VERSION-jdk$i \
                     -t $DOCKERHUB_USER/mcsmanager-daemon:latest-jdk$i \
                     --build-arg JDK_VERSION=$i \
                     . || echo "=== Build Failed ==="
    done

    docker tag $DOCKERHUB_USER/mcsmanager-daemon:latest-jdk17 $DOCKERHUB_USER/mcsmanager-daemon:latest
else
    echo "=== No need to build daemon"
fi

# web
MCSM_WEB_VERSION=$(curl "https://raw.githubusercontent.com/MCSManager/MCSManager-Web-Production/master/package.json" | jq -r ".version")
LATEST_BUILD=$(sed -n "s/Web: //p" $VERSION_FILE)

if [[ $MCSM_WEB_VERSION != $LATEST_BUILD ]] || $FORCED_BUILD; then
    sed -i "s/Web: .*/Web: $MCSM_WEB_VERSION/" $VERSION_FILE
    if $GIT_TRACK; then
        git add $VERSION_FILE && git commit -m "build: web $MCSM_WEB_VERSION" && git push
    fi

    echo "=== Building mcsmanager-web:$MCSM_WEB_VERSION"

    docker build -f ./dockerfile-web \
                 -t $DOCKERHUB_USER/mcsmanager-web:$MCSM_WEB_VERSION \
                 -t $DOCKERHUB_USER/mcsmanager-web:latest \
                 . || echo "=== Build Failed ==="
else
    echo "=== No need to build web"
fi

# push
echo "=== Pushing to Docker Hub ==="

echo $DOCKERHUB_PASS | docker login --username $DOCKERHUB_USER --password-stdin
docker push -a $DOCKERHUB_USER/mcsmanager-daemon
docker push -a $DOCKERHUB_USER/mcsmanager-web
