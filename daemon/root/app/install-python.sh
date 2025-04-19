#!/bin/bash

set -e

MODULES=($1)

if [ -z "$(which python3)" ]; then
  echo "[install-python] Installing python3..."
  apk add --no-cache python3

  python3 --version
  echo "[install-python] Python3 installed successfully."
fi

for m in "${MODULES[@]}"; do
  if ! python3 -c "import ${m}" 2>/dev/null; then
    echo "[install-python] Installing ${m}..."
    apk add --no-cache "py3-${m}"
  fi
done
