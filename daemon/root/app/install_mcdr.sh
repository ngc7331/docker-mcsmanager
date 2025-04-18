#!/bin/bash

set -e

if [ -z "$(which python3)" ]; then
  apk add --no-cache python3 py3-pip py3-psutil
fi

VENV_PATH="${MCSM_PATH}/daemon/data/venv/mcdreforged"
PYTHON="${VENV_PATH}/bin/python3"

# install mcdr
if [ ! -f "${PYTHON}" ]; then
  echo "Creating virtualenv for MCDR..."
  python3 -m venv --system-site-packages "${VENV_PATH}"
fi

${PYTHON} -m pip install --upgrade mcdreforged

chown abc:abc "${VENV_PATH}"

# Create alias
cat << EOF > /usr/bin/mcdreforged
#!/bin/bash
${PYTHON} -m mcdreforged "\$@"
EOF

chmod +x /usr/bin/mcdreforged

mcdreforged --version
