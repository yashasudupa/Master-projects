#ifndef __OS_KERNEL__H__
#define __OS_KERNEL__H__

#include <kernel/macros.h>
#include <kernel/debug.h>


/* ============================================================================= */
/* ============ Public kernel functions implemented in kernel.c ================ */
/* ============================================================================= */


/**
 * Starts the OS kernel by doing the following:
 *		1. Stop whatchdog timer
 * 	  	2. Initialize sysclk and UART
 *    	3. Initialize tasks and the task control blocks (TCB).
 *    	4. Initialize the system timer
 *    	5. set os_running = 1
 *    	6. invoke the dispatcher
 *
 *  CAUTION: Once the OS implementation is complete, this function will never return since the scheduler won't do so!
 *  */
extern void os_run(void);







/* ========== Syscall wrappers */
extern			void 		syscall_mystery(void);
//extern			void		syscall_sys_updateTimer();
extern 			Result_t 	syscall_CAS(int* p, int oldVal, int newVal);

/** Suspends the calling task until the requested event becomes set or the specified deadline is reached.
 * 	The function immediately returns indicating success if the event is already set.
 * 	Independent from whether the event was already set or became set before the deadline, it will
 * 	eventually be consumed by the task. I.e., the event will be cleared immediately and no further task will
 * 	be resumed.
 *
 * 	Consequently, setting an event will only resume the first task in its waitqueue (priority queue).
 * 	In case there is no task in the waitqueue it will remain set until the next task starts waiting for it.
 *
 *  If event == NULL is passed, the calling task will simply sleep until the deadline is reached.
 *  Apart, there are some special values for the deadline-pointer:
 *    __DEADLINE_INFINITE   (0) the task will wait without time limitation
 *    __DEADLINE_PRESET     (2) the deadline is already preset in the task's TCB (running_task->time_out)
 *
 *  @asserts if (event == NULL) and (*deadline == __DEADLINE_INFINITE)
 *  	(otherwise the task would be removed from any memberlist/timeout-queue and be deactivated forever.)
 *
 *  @returns 0/failure on timeout (i.e., if the deadline was reached before the event has occurred)
 *  		 1/success on event (i.e., the event was set before the deadline was reached)
 */
extern 			Result_t	syscall_waitEventUntil(Event_t *event, const Time_t *deadline);

/** Sets the specified event.
 *  An event is always binary (set or not set), thus, setting it several times will not accumulate.
 *
 *  If no task is currently waiting for the event, the event will be set and remains set
 *  until it is cleared or another task consumes it.
 *  If at least one task is already waiting for the event, the event remains unset and
 *  the first task in the specific waitqueue will be resumed.
 *
 *  Note: Resumption of a waiting task might cause a context switch depending on the priority of the currently running task.
 *
 *  Passing the NULL-event will be silently ignored.
 */
extern 			void 		syscall_setEvent(Event_t *event);

/** Makes a resource allocation request using the Highest Locker Protocol. The request will
 * 	always succeed, or assert if something goes wrong. If the request succeeds, the task's
 * 	active priority is adjusted, the task is set as the resource owner and the resource
 * 	counter is incremented.
 *
 *  @asserts if (resource == NULL)
 *  @asserts if caller task is not registered to use resource and the allocation would
 *  			disturb	the HLP
 *  @asserts if resource is already allocated to another task
 */
extern 			void 	syscall_getResource(Resource_t *resource);

/** Releases the specified resource. A resource is only completely released once
 *  its counter reachs 0. In that case, the task's active priority is readjusted
 *  and the resource owner set to NIL_ID.
 *
 *	If the resource is not allocated or is allocated to another task, releasing it
 *	will be silently ignored.
 *
 *
 *  @asserts if (resource == NULL)
 *
 */
extern 			void 	syscall_releaseResource(Resource_t *resource);

/* ========== Syscall helper functions */
static inline	void 		mystery(void)							{ syscall_mystery(); }
//static inline	void 		sys_updateTimer(void)							{ syscall_sys_updateTimer(); }
static inline	Result_t 	CAS(int* p, int oldVal, int newVal)		{ return syscall_CAS(p, oldVal, newVal); }

/** Waits for an event with a timeout relative to the current time.
 *
 *  Uses the task's TCB timeout to store the next timeout of the caller task and passes
 *  __DEADLINE_PRESET to indicate to waitEventUntil that the deadline is preset.
 */
extern Result_t	waitEventFor(Event_t *event, Delay_t timeout);

/** see syscall_waitEventUntil */
extern Result_t waitEventUntil(Event_t *event, const Time_t *deadline);


/** Infinitely waits for the event. Passes __DEADLINE_INFINITE to waitEventUntil
 *  to indicate that.
 * */
extern Result_t waitEvent(Event_t *event);

/** see syscall_setEvent */
extern void 	setEvent(Event_t *event);

/** Clears the event */
extern void 	clearEvent(Event_t *event);

/** Checks if the event is currently set.
 *
 *   @returns 0 if event is not set
 *			  1 if event is set
 * */
extern Result_t	checkEvent(Event_t* event);

/** Sleeps for a relative timeout */
extern void		sleep(Delay_t timeout);

/** Sleeps until an absolute deadline */
extern void		sleepUntil(Time_t *deadline);

/** Busy wait for a relative timeout */
extern void		busyDelay(Delay_t timeout);

/** Busy wait until an absolute deadline */
extern void		busyDelayUntil(Time_t *deadline);

/* Makes a request to resource */
extern void 	getResource(Resource_t *resource);


/* Releases resource */
extern void 	releaseResource(Resource_t *resource);

/* ========== Various functions */

/** This function immediately resets the CPU by writing the Watchdog timer with an invalid password. */
static inline void os_reset() { WDTCTL = 0x00; }



/** Puts the current OS time into the pointed variable.
 * 	In case a NULL pointer is passed, the function will simply return.
 * 	@parm time pointer to the address which will finally hold the 64 bit timeline.
 */
extern void getCurrentTime(Time_t *time);

/** Prints some system information to the standard out stream */
extern void os_printSystemInformation();

#endif
