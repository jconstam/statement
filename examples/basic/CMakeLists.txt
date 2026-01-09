# Set minimum version of cmake
cmake_minimum_required(VERSION 3.28)

# Setup project name
set(PROJECT_NAME statement_example_basic)

# Set project name
project(${PROJECT_NAME} C)

set(SOURCES
    static_outputs/basic_sm.c
    test_code/main.c
)

include_directories(
    static_outputs
    variable_outputs
    test_code
)

add_executable(${PROJECT_NAME} ${SOURCES})
