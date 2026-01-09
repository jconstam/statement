#!/usr/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <venv_path> <force>"
    exit 1
fi

VENV_PATH=$1
FORCE=$2

if [ ! -d "${VENV_PATH}" ] || [ "${FORCE}" -eq 1 ]; then
    NEED_CREATE=1
else
    NEED_CREATE=0
fi

PIP_INSTALL_FLAGS="--requirement requirements.txt"
if [ "${NEED_CREATE}" -eq 1 ]; then
    PIP_INSTALL_FLAGS="${PIP_INSTALL_FLAGS} --no-cache-dir --force-reinstall"

    echo "Force removing existing virtual environment at ${VENV_PATH}"
    rm -rf "${VENV_PATH}"
    echo "Creating virtual environment"
    python3 -m venv "${VENV_PATH}"
fi

echo "Activating virtual environment"
# shellcheck source=/dev/null
source "${VENV_PATH}/bin/activate"

if [ "${NEED_CREATE}" -eq 1 ]; then
    echo "Installing dependencies"
    # shellcheck disable=SC2086
    pip install ${PIP_INSTALL_FLAGS}
fi
