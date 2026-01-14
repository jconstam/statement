cmake_minimum_required(VERSION 3.28)

set(PROJECT_NAME statement_example_basic)

project(${PROJECT_NAME} C)

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall -Wextra -Werror -pedantic")

set(SOURCES
    static_outputs/basic_sm.c
    application/main.c
)

include_directories(
    static_outputs
    interface
    application
)

add_executable(${PROJECT_NAME} ${SOURCES})
