
#ifndef __LIB_PMM__H__
#define __LIB_PMM__H__

#include <kernel/kernel.h>

/** Sets the core voltage to the specified level.
 * 	According to the manual this will be done step by step.
 *
 *	@param	the desired voltage level. Must be in range [0:3]
 *	@return 0 on failure or unsupported level
 *			1 on success
 */
Result_t PMM_setVCore(uint16_t level);

#endif
