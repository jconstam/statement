/*------------------------------------------------------------------------------
 MULTIPLE INCLUSION GUARD
 -----------------------------------------------------------------------------*/

#pragma once

/*------------------------------------------------------------------------------
 INCLUDES
 ------------------------------------------------------------------------------*/

#include <stdbool.h>

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
 MOCKED FUNCTIONS
 ------------------------------------------------------------------------------*/

void basic_sm_interface__log(basic_sm_log_level_t level, const char *msg);
bool basic_sm_interface__user_init(void *user_param);
void basic_sm_interface__state_idle(void *user_param);
void basic_sm_interface__state_a(void *user_param);
void basic_sm_interface__state_b(void *user_param);
void basic_sm_interface__state_c(void *user_param);

/*------------------------------------------------------------------------------
 END OF FILE
 ------------------------------------------------------------------------------*/
