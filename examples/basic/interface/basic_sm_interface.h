/*------------------------------------------------------------------------------
 MULTIPLE INCLUSION GUARD
 -----------------------------------------------------------------------------*/

#pragma once

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
 UTILITY FUNCTIONS
 ------------------------------------------------------------------------------*/

/**
 * @brief Logging interface for the state machine.
 *
 * @param[in] level   Log level (e.g., INFO, WARN, ERROR).
 * @param[in] msg     Format string for the log message.
 */
#define basic_sm_interface__log(level, msg) log_to_console(level, msg)

/*------------------------------------------------------------------------------
 STATE FUNCTIONS
 ------------------------------------------------------------------------------*/

/**
 * @brief Custom user initialization function for the state machine.
 *
 * @param[in] user_param User-defined parameter passed during initialization.
 *
 * @return true if initialization is successful, false otherwise.
 */
#define basic_sm_interface__user_init(user_param) init_state_machine(user_param)

/*!
 * @brief State function for idle state.
 * @param[in] user_param User-defined parameter.
 */
#define basic_sm_interface__state_idle(user_param) state_idle(user_param)

/*!
 * @brief State function for state A.
 * @param[in] user_param User-defined parameter.
 */
#define basic_sm_interface__state_a(user_param) state_a(user_param)

/*!
 * @brief State function for state B.
 * @param[in] user_param User-defined parameter.
 */
#define basic_sm_interface__state_b(user_param) state_b(user_param)

/*!
 * @brief State function for state C.
 * @param[in] user_param User-defined parameter.
 */
#define basic_sm_interface__state_c(user_param) state_c(user_param)

/*------------------------------------------------------------------------------
 END OF FILE
 ------------------------------------------------------------------------------*/
