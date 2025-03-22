#!/bin/bash

set -e

# ensure deps are installed
apk add --no-cache python3 py3-pip py3-psutil

# install mcdr
# break system dependencies
python3 -m pip install --no-cache-dir --break-system-packages mcdreforged

mcdreforged --version
