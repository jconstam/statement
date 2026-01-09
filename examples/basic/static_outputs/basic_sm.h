/*------------------------------------------------------------------------------
 INCLUDES
 ------------------------------------------------------------------------------*/

#include <stdbool.h>

#include "basic_sm_interface.h"

/*------------------------------------------------------------------------------
 CONSTANTS
 ------------------------------------------------------------------------------*/

#define BASIC_SM_VERSION_MAJOR 1
#define BASIC_SM_VERSION_MINOR 0

/*------------------------------------------------------------------------------
 MACROS
 ------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
 TYPES
 ------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
 PUBLIC FUNCTIONS
 ------------------------------------------------------------------------------*/

/*!
 * @brief Initialize the basic state machine.
 * @param[in] user_param User-specific data.
 * @return true if initialization was successful, false otherwise.
 */
bool basic_sm__init(void *user_param);

/*!
 * @brief Poll the basic state machine.
 */
void basic_sm__poll(void);

/*!
 * @brief Cleanup the basic state machine.
 */
void basic_sm__cleanup(void);

/*!
 * @brief Function to transition from state IDLE to state A.
 */
void basic_sm__transition__idle_to_a(void);

/*!
 * @brief Function to transition from state A to state B.
 */
void basic_sm__transition__a_to_b(void);

/*!
 * @brief Function to transition from state A to state C.
 */
void basic_sm__transition__a_to_c(void);

/*!
 * @brief Function to transition from state B to state IDLE.
 */
void basic_sm__transition__b_to_idle(void);

/*!
 * @brief Function to transition from state B to state C.
 */
void basic_sm__transition__b_to_c(void);

/*!
 * @brief Function to transition from state C to state IDLE.
 */
void basic_sm__transition__c_to_idle(void);

/*------------------------------------------------------------------------------
 UNIT TEST HELPER FUNCTIONS
 ------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
 END OF FILE
 ------------------------------------------------------------------------------*/
