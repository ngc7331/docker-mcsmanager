#!/bin/bash

set -e

VERSION=$1
SUFFIX="-headless"

if [ -z "${VERSION}" ]; then
  echo "Skipping JDK installation..."
  exit 0
fi

echo "Installing JDK ${VERSION}..."
if [ "${VERSION}" = "8" ]; then
  SUFFIX=""
elif [ "${VERSION}" = "22" ]; then
  echo "Warning: openjdk22 is not stable yet, use with caution"
  sed -n "s;v3.20/main;edge/testing;p" /etc/apk/repositories >> /etc/apk/repositories
fi

apk add --no-cache openjdk${VERSION}-jre${SUFFIX}
java -version
