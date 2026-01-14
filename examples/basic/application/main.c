/*------------------------------------------------------------------------------
 INCLUDES
 ------------------------------------------------------------------------------*/

#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#include "main.h"

#include "basic_sm.h"
#include "basic_sm_interface.h"

/*------------------------------------------------------------------------------
 CONSTANTS
 ------------------------------------------------------------------------------*/

#define LOOP_COUNT (20)

/*------------------------------------------------------------------------------
 MACROS
 ------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
 TYPES
 ------------------------------------------------------------------------------*/

typedef struct
{
    int dummy; // cppcheck-suppress unusedStructMember
} basic_sm_data_t;

/*------------------------------------------------------------------------------
 VARIABLES
 ------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
 FORWARD DECLARATIONS
 ------------------------------------------------------------------------------*/

/*!
 * @brief Makes a random choice of whether to take a branch or not.
 * @return true for left, false for right.
 */
static bool left_or_right(void);

/*------------------------------------------------------------------------------
 STATIC FUNCTIONS
 ------------------------------------------------------------------------------*/

static bool left_or_right(void)
{
    return (rand() % 2 == 0); // NOLINT(cert-msc30-c,cert-msc50-cpp,concurrency-mt-unsafe)
}

/*------------------------------------------------------------------------------
 PUBLIC FUNCTIONS
 ------------------------------------------------------------------------------*/

int main(void)
{
    basic_sm_data_t sm_data = {0};

    log_to_console(BASIC_SM_LOG_LEVEL_INFO, "Starting state machine.");

    if (!basic_sm__init(&sm_data))
    {
        log_to_console(BASIC_SM_LOG_LEVEL_ERROR, "State machine initialization failed.");
        return -1;
    }

    for (int i = 0; i < LOOP_COUNT; i++)
    {
        basic_sm__poll();
    }

    basic_sm__cleanup();

    log_to_console(BASIC_SM_LOG_LEVEL_INFO, "State machine execution completed.");

    return 0;
}

bool init_state_machine(void *user_param)
{
    (void)user_param;

    srand((unsigned int)time(NULL)); // NOLINT(cert-msc32-c,cert-msc51-cpp)

    return true;
}

void log_to_console(int level, const char *fmt, ...)
{
    printf("Log level: %d, Message: ", level);
    va_list args;
    va_start(args, fmt);
    vprintf(fmt, args);
    va_end(args);
    printf("\n");
}

void state_idle(void *user_param)
{
    (void)user_param;

    basic_sm__transition__idle_to_a();
}

void state_a(void *user_param)
{
    (void)user_param;

    if (left_or_right())
    {
        basic_sm__transition__a_to_b();
    }
    else
    {
        basic_sm__transition__a_to_c();
    }
}

void state_b(void *user_param)
{
    (void)user_param;

    if (left_or_right())
    {
        basic_sm__transition__b_to_idle();
    }
    else
    {
        basic_sm__transition__b_to_c();
    }
}

void state_c(void *user_param)
{
    (void)user_param;

    basic_sm__transition__c_to_idle();
}

/*------------------------------------------------------------------------------
 UNIT TEST HELPER FUNCTIONS
 ------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
 END OF FILE
 ------------------------------------------------------------------------------*/
