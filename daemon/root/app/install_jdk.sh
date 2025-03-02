#!/bin/bash

set -e

VERSION=$1
SUFFIX="-headless"

if [ -z "${VERSION}" ]; then
  exit 0
fi

if [ "${VERSION}" = "8" ]; then
  SUFFIX=""
elif [ "${VERSION}" = "22" ] || [ "${VERSION}" = "23" ]; then
  echo "Warning: openjdk22/23 is not stable yet, use with caution"
  sed -n "s;v3.21/main;edge/testing;p" /etc/apk/repositories >> /etc/apk/repositories
fi

apk add --no-cache openjdk${VERSION}-jre${SUFFIX}

ln -s /usr/lib/jvm/java-${VERSION}-openjdk/bin/java /usr/bin/java${VERSION}

# sanity check
java${VERSION} -version
