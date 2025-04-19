#!/bin/bash

set -e

/app/install-python.sh "pip psutil"

VENV_PATH="${MCSM_PATH}/daemon/data/venv/mcdreforged"
PYTHON="${VENV_PATH}/bin/python3"

# install mcdr
if [ ! -f "${PYTHON}" ]; then
  echo "[install-mcdr] Creating virtualenv for MCDR..."
  python3 -m venv --system-site-packages "${VENV_PATH}"
fi

echo "[install-mcdr] Installing MCDReforged..."
${PYTHON} -m pip install --upgrade mcdreforged

chown abc:abc "${VENV_PATH}"

echo "[install-mcdr] Creating MCDReforged alias to /usr/bin/mcdreforged..."
# Create alias
cat << EOF > /usr/bin/mcdreforged
#!/bin/bash
${PYTHON} -m mcdreforged "\$@"
EOF

chmod +x /usr/bin/mcdreforged

mcdreforged --version
echo "[install-mcdr] MCDReforged installed successfully."
