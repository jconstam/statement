#!/usr/bin/bash

if [ $# -ne 3 ]; then
    echo "Usage: $0 <xml_file> <field_path> <expected_value>"
    exit 1
fi

XML_FILE=$1
if [ ! -f "$XML_FILE" ]; then
    echo "Error: File '$XML_FILE' not found!"
    exit 1
fi

FIELD_PATH=$2
EXPECTED_VALUE_STRING=$3

PARSE_COMMAND="cat \"${XML_FILE}\" | xq . | sed 's/@//' | sed 's/-//' | jq '.${FIELD_PATH}' | sed 's/\"//g'"
FIELD_VALUE_STRING=$(eval "${PARSE_COMMAND}")
PARSE_STATUS=$?
if [ ${PARSE_STATUS} -ne 0 ]; then
    echo "Error: Failed to parse XML file '$XML_FILE'. Ensure 'jq' and 'xq' are installed."
    exit 1
fi

COMPARE_COMMAND="bc -l <<< \"${EXPECTED_VALUE_STRING} - ${FIELD_VALUE_STRING}\""
RESULT=$(eval "${COMPARE_COMMAND}")
COMPARE_STATUS=$?
if [ ${COMPARE_STATUS} -ne 0 ]; then
    echo "Error: Comparison failed between expected value '$EXPECTED_VALUE_STRING' and field value '${FIELD_VALUE_STRING}'."
    exit 1
elif [ "${RESULT}" == 0 ]; then
    echo "Success: Field '$FIELD_PATH' has the expected value '$EXPECTED_VALUE_STRING'."
    exit 0
else
    echo "Failure: Field '$FIELD_PATH' has value '$FIELD_VALUE_STRING', expected '$EXPECTED_VALUE_STRING'."
    exit 1
fi
