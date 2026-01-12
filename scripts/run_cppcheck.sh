#!/usr/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 <source_dir>"
    exit 1
fi

if [ ! -d "$1" ]; then
    echo "Error: Directory '$1' not found!"
    exit 1
fi

SOURCE_PATH=$(realpath "${1}")

EXCLUDES="| grep -v /build/ | grep -v /build_tests/ | grep -v /unit_test/"

echo "Searching for C files..."
FIND_C_FILES_CMD="find ${SOURCE_PATH} -type f -name *.c ${EXCLUDES}"
C_FILES=$(eval "${FIND_C_FILES_CMD}")
echo "Found C files:"
echo "${C_FILES}"

echo "Searching for H files..."
FIND_H_FILES_CMD="find ${SOURCE_PATH} -type f -name *.h ${EXCLUDES}"
H_FILES=$(eval "${FIND_H_FILES_CMD}")
echo "Found H files:"
echo "${H_FILES}"

echo "Running cppcheck"
# shellcheck disable=SC2086
cppcheck \
    --check-level=exhaustive \
    --inconclusive \
    --enable=all \
    --language=c \
    --std=c99 \
    --force \
    --xml \
    --xml-version=2 \
    --inline-suppr \
    --error-exitcode=2 \
    --suppress=missingInclude \
    --suppress=missingIncludeSystem \
    --suppress=unusedFunction \
    --suppress=checkersReport \
    -UUNIT_TEST \
    ${C_FILES} \
    ${H_FILES}
exit $?
