/**
 *
 * ostypes.h
 *
 * Defines the open types for SmartOS. These types are used by applications
 *
 * @author EAS Group - ITI - TU Graz for the RTOS Lab
 *
 * */


#ifndef __OS_OSTYPES__H__
#define __OS_OSTYPES__H__

#include <kernel/osarch.h>

/* ======================== BASIC SCALAR DATA TYPES =========================== */

/** The data type for task IDs */
typedef uint8_t		TaskId_t;

/** The data type for resource IDs */
typedef uint8_t		ResourceId_t;

/** The data type for task priorities */
typedef uint8_t		Priority_t;

/** The data type for absolute system times */
typedef uint64_t	Time_t;

/** The data type for relative system times */
typedef uint32_t	Delay_t;


/** The OS default type for returning success or failure including various differentiations.
 *  According to the OS code guidelines, this type shall be used as follows:
 *      1 or SUCCESS		indicates success
 *      >1 					    specific success code
 *      0 or FAILURE		indicates failure or general error
 *      <0 					    specific error code
 *  For portability reasons one should only return values in the range [-256:255]
 */
typedef int		Result_t;
#define FAILURE	(0)       ///< general failure indicator
#define SUCCESS	(1)       ///< general success indicator

/** A boolean type definition for convenience reasons. Supported values are TRUE or 1 and FALSE or 0 respectively.
 *	For performance reasons bool reverts to (signed) int since this the most basic data type. */
typedef int		bool;
#define FALSE	(0)
#define TRUE	(1)

/** null pointer value */
#define NULL	(0)



/** Task Control Block (TCB).
 *  Each task has its own TCB for storing its task context and several other information.
 *  The TCBs are stored in RAM and require sizeof(Task_t) bytes each.
 */
typedef struct {
	uint16_t	reg_context[13];///< Holds the register contents while the task is suspended:
								///<	[0]=SP/R1, [1]=R4, ... , [9]=R12, [10]=R13, [11]=R14, [12]=R15
	TaskId_t	id;				///< the task id (will be set during OS initialization)
	Priority_t 	prioActive;  	///< the task active priority (either prioBase or some resource's ceiling priority)
	Priority_t	prioBase;		///< the task base priority
	uint8_t  	nResources;  	///< number of resources the task currently owns
	char 		*name;			///< The task name (name of the entry function). Required for debugging.
	uint16_t	*stackLA; 		///< This pointer holds the address of the lowest stack word
	uint16_t	*stackHA; 		///< This pointer holds the address of the highest stack word
	TaskId_t	*memberlist;	///< Pointer to the ID of the head-task to which this task currently belongs (or NULL if none).
								///< A task always belongs to at most one task list. Potential values:
								///<  NULL			: task is currently sleeping
								///<  &ready_tasks	: task is ready or even running
								///<  e->waitqueue	: task is waiting for event e
	Time_t 		timeout;		///< Next absolute timeout of this task in [us]
	TaskId_t 	next;			///< Task id of the next task in the task memberlist, or NIL_ID if no successor is available
	TaskId_t 	next_timeout;	///< Task id of the next task in the timeout list, or NIL_ID if no successor is available
	void 		(*entry)(void);	///< The address of the task entry function
} Task_t;


/** Event Control Block (ECB).
 *  Each event has its own ECB.
 *  The ECBs are stored in RAM and require sizeof(Event_t) bytes each.
 */
typedef struct {
  int8_t		value;			///< <=0 if event unavailable (tasks must wait), >0 if event available (no wait necessary)
  TaskId_t		waitqueue;		///< head of the queue (task ID) with waiting tasks sorted by decreasing priority
} Event_t;

typedef struct {
	void (*handler)(unsigned int); 	//< the handler function
} IRQHandler_t;

/**
 * Resource Control Block (RCB)
 * Each resource has its own RCB.
 * The RCBs are stored in RAM and require sizeof(Resource_t) bytes each.
 * */
typedef struct {
	uint8_t			counter;      	//< if 0, resource is free. If >0, resource is allocated <value> times to the same task
	TaskId_t 		owner;       	//< the owner task (NIL_ID for not allocated)
	Priority_t		prioCeiling;    //< will be dynamically changed -> final value is the highest priority among all tasks which use the resource
	char 			*name;   		//< resource name (for debugging only)
} Resource_t;

#endif
