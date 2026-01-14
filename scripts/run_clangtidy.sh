#!/usr/bin/bash

if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <root_path> <config_file_path> <project_path>"
    exit 1
fi

ROOT_PATH=$(realpath "${1}")
if [ ! -d "${ROOT_PATH}" ]; then
    echo "Could not find script path \"${1}\""
    exit 1
fi
echo "Using root path \"${ROOT_PATH}\""

CONFIG_FILE_PATH=$(realpath "${2}")
if [ ! -f "${CONFIG_FILE_PATH}" ]; then
    echo "Could not find config file path \"${2}\""
    exit 1
fi
echo "Using config file path \"${CONFIG_FILE_PATH}\""

PROJECT_PATH=$(realpath "${3}")
if [ ! -d "${PROJECT_PATH}" ]; then
    echo "Could not find project path \"${3}\""
    exit 1
fi
echo "Using project path \"${PROJECT_PATH}\""

echo "Setting up clang-tidy configuration file"
cp -v "${CONFIG_FILE_PATH}" "${ROOT_PATH}"

echo "Running clang-tidy"
clang-tidy \
    "${PROJECT_PATH}/application"/* \
    "${PROJECT_PATH}/interface"/* \
    "${PROJECT_PATH}/static_outputs"/* \
    -- \
    -I"${PROJECT_PATH}/application/" \
    -I"${PROJECT_PATH}/interface/" \
    -I"${PROJECT_PATH}/static_outputs/" \
    -I"${PROJECT_PATH}/unit_test/support/" \
    -DUNIT_TEST
RESULT=$?

echo "Cleaning Up"
rm -v "${ROOT_PATH}/clang-tidy-checks.py"
rm -v "${ROOT_PATH}/.clang-tidy"

echo "Done"
exit ${RESULT}
