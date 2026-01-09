/*------------------------------------------------------------------------------
 INCLUDES
 ------------------------------------------------------------------------------*/

#include "main.h"

/*------------------------------------------------------------------------------
 TYPES
 ------------------------------------------------------------------------------*/

typedef enum
{
    BASIC_SM_LOG_LEVEL_DEBUG,
    BASIC_SM_LOG_LEVEL_INFO,
    BASIC_SM_LOG_LEVEL_WARN,
    BASIC_SM_LOG_LEVEL_ERROR
} basic_sm_log_level_t;

/*------------------------------------------------------------------------------
 PUBLIC FUNCTIONS
 ------------------------------------------------------------------------------*/

/**
 * @brief Logging interface for the state machine.
 *
 * @param[in] level   Log level (e.g., INFO, WARN, ERROR).
 * @param[in] fmt     Format string for the log message.
 * @param[in] ...     Additional arguments for the format string.
 */
#define basic_sm__log(level, fmt, ...) log_to_console(level, fmt, ##__VA_ARGS__)

/**
 * @brief Custom user initialization function for the state machine.
 *
 * @param[in] user_param User-defined parameter passed during initialization.
 *
 * @return true if initialization is successful, false otherwise.
 */
#define basic_sm__user_init(user_param) init_state_machine(user_param)

/*------------------------------------------------------------------------------
 END OF FILE
 ------------------------------------------------------------------------------*/
