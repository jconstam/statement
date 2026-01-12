/*------------------------------------------------------------------------------
 MULTIPLE INCLUSION GUARD
 -----------------------------------------------------------------------------*/

#pragma once

/*------------------------------------------------------------------------------
 INCLUDES
 ------------------------------------------------------------------------------*/

#include <stdbool.h>
#include <stdio.h>

/*------------------------------------------------------------------------------
 TYPES
 ------------------------------------------------------------------------------*/

typedef enum basic_sm_log_level
{
    BASIC_SM_LOG_LEVEL_DEBUG,
    BASIC_SM_LOG_LEVEL_INFO,
    BASIC_SM_LOG_LEVEL_WARN,
    BASIC_SM_LOG_LEVEL_ERROR
} basic_sm_log_level_t;

/*------------------------------------------------------------------------------
 UTILITY FUNCTIONS
 ------------------------------------------------------------------------------*/

/**
 * @brief Logging interface for the state machine.
 *
 * @param[in] level   Log level (e.g., INFO, WARN, ERROR).
 * @param[in] fmt     Format string for the log message.
 * @param[in] ...     Additional arguments for the format string.
 */
#define basic_sm_interface__log(level, fmt, ...) printf(level, fmt, ##__VA_ARGS__)

/*------------------------------------------------------------------------------
 STATE FUNCTIONS
 ------------------------------------------------------------------------------*/

bool basic_sm_interface__user_init(void *user_param);
void basic_sm_interface__state_idle(void *user_param);
void basic_sm_interface__state_a(void *user_param);
void basic_sm_interface__state_b(void *user_param);
void basic_sm_interface__state_c(void *user_param);

/*------------------------------------------------------------------------------
 END OF FILE
 ------------------------------------------------------------------------------*/
