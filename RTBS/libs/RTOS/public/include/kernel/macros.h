/**
 *
 * macros.h
 *
 * Defines the open macros for SmartOS. These macros are used by applications
 *
 * @author EAS Group - ITI - TU Graz for the RTOS Lab
 *
 * */


#ifndef __OS_MACROS__H__
#define __OS_MACROS__H__

#include <kernel/ostypes.h>


/* ======================== HELPER MACROS ======================================================= */

/** Returns the minimum of the two given parameters.
 *  CAUTION: the two parameters are type independent. Nevertheless, both shuld be of the same type to avoid problems. */
#define min(x, y)              ((x)<(y)?(x):(y))

/** Returns the maximum of the two given parameters.
 *  CAUTION: the two parameters are type independent. Nevertheless, both shuld be of the same type to avoid problems. */
#define max(x, y)              ((x)>(y)?(x):(y))

/** Returns the sign of the given parameter:
 *     1 for x >= 0
 *    -1 for x < 0
 */
#define sign(x) ((x>=0)?1:-1)

/** Returns the absolute value of the given (numeric) value. */
#define abs(x) (((x)< 0)?(-(x)):(x))



/* ======================== KERNEL CONSTANTS ==================================================== */

#define NIL_ID			((1 << (sizeof(TaskId_t)*8))-1)		///< the maximum task ID
#define IRQ_STACKSIZE	(8)									///< the task stack overhead for the kernel
//#define IRQ_STACKSIZE	(150)									///< TODO TODO FIXME FIXME

/** This is a special time code temporally limited functions indicating
 *  to wait infinitely. */
#define __DEADLINE_INFINITE		((const Time_t *) 0)

/** This is a special time code temporally limited functions indicating
 *  that the deadline is already set in the callers TCB. */
#define __DEADLINE_PRESET		((const Time_t *) 2)

/* ======================== TASK DECLARATION MACROS ============================================= */

/** Creates the TCB and the stack for a task.
 *  Additionally, it emits a forward declaration for the corresponding task entry function.
 *
 *  The stack is defined in RAM section .os_stacks as
 *    static uint16_t __stack_<_name>[<_stacksize>]
 *  The TCB is defined and initialized in section _section as
 *    Task_t __task_<_name>
 *  The entry function is forward declared as
 *    void <_name>(void)
 *
 *  @param _name        is the name of the task and its entry function
 *  @param _stacksize   is the stack size in machine words
 *  @param _priority    is the task's base priority
 *  @param _section     is the section in which the TCB is placed
 */
#define __OS_DECLARE_TASK(_name, _stacksize, _priority, _section)					\
  static uint16_t __stack_##_name[_stacksize] __attribute__((section(".os_stacks")));	\
  void _name(void);																		\
  Task_t __task_##_name __attribute__((section(_section))) = {			\
	.prioActive		= _priority,						\
    .prioBase		= _priority,						\
    .nResources		= 0,								\
    .name			= #_name,							\
    .stackLA		= &__stack_##_name[0],				\
    .stackHA		= &__stack_##_name[_stacksize-1],	\
    .memberlist		= NULL,								\
    .timeout		= 0,								\
    .next			= NIL_ID,							\
    .next_timeout	= NIL_ID,							\
    .entry			= &_name,							\
}

/** Macro for declaration of tasks.
 *
 *  @param _name        is the name of the task and its entry function
 *  @param _stacksize   is the stack size in machine words (will be extended by IRQ_STACKSIZE)
 *  @param _priority    is the base and current priority
 */
#define OS_DECLARE_TASK(_name, _stacksize, _priority)  \
    __OS_DECLARE_TASK(_name, ((_stacksize) + IRQ_STACKSIZE), _priority, ".os_tasks")


/** Macro for defining a task entry function.
 *  CAUTION: Entry functions may never return!
 *  Usage:
 *    OS_TASKENTRY(taskname) { ... }
 */
#define OS_TASKENTRY(taskname) void __attribute__((noreturn)) taskname(void)


/* ======================== EVENT DECLARATION MACROS ============================================= */

/** Creates the ECB for an event.
 *  The ECB is defined and initialized as Event_t <_name>
 *
 *  @param _name  is the name of the event
 *  @param _init  is the initial value of the event (0 = unset, 1 = set)
 */
#define __OS_DECLARE_EVENT(_name, _init)	\
  Event_t _name = {							\
    .value		= _init,					\
    .waitqueue	= NIL_ID,					\
}

/** Macro to declare and initialize an initially *unset* event
 *  \see __OS_DECLARE_EVENT
 *  @param _name  is the event's name
 */
#define OS_DECLARE_EVENT(_name)			__OS_DECLARE_EVENT(_name, 0)

/** Macro to declare and initialize an initially *set* event
 *  \see __OS_DECLARE_EVENT
 *  @param _name  is the event's name
 */
#define OS_DECLARE_ACTIVE_EVENT(_name)	__OS_DECLARE_EVENT(_name, 1)

/** Macro for importing externally defined events
 *  @param _name  is the name of the event
 */
#define OS_IMPORT_EVENT(_name)			extern Event_t _name



/** Creates the ICB for an interrupt.
 *
 *  The ICBs are defined and initialized in section os_irqs as
 *    const IRQHandler_t __softirq_HANDLER<_hname>
 *  In fact, each ICB has its own section depending on its number: os_irqs.os_irq_<number>
 *
 *  CAUTION: ICBs are constant!
 *
 *  @param _irqno        is the irq number (either hard or soft irq)
 *  @param _handler     is the pointer to the interrupt service routine (ISR)
 *
 */
#define OS_DECLARE_IRQ_HANDLER(_irqno, _handler)												\
	extern void __hwirq_##_irqno();																\
	void _handler();																			\
	const IRQHandler_t __irqHandler_##_irqno __attribute__((section(".os_irq_"#_irqno))) = { 	\
			.handler 		= &_handler,		                    							\
	};																							\
	__attribute__((interrupt(_irqno), naked)) void hwirq_##_irqno() {							\
		__hwirq_##_irqno();																		\
	}

/* ======================== RESOURCE DECLARATION MACROS ============================================= */

/** Creates and initializes the RCB for a resource.
 *
 *  The RCBs are defined in section ".os_resources"
 *
 *  @param _name        the resource name
 *
 */
#define OS_DECLARE_RESOURCE(_name)									\
	Resource_t _name __attribute__((section(".os_resources"))) = {  \
		.counter  = 0,												\
		.owner = NIL_ID,      										\
		.prioCeiling  = 0,     										\
		.name  = #_name,      										\
	}


/** Registers a task to use a resource.
 *
 *  Automatically calculates and stores the resource ceiling priority
 *
 *  @param _taskName        is the task name
 *  @param _resourceName    is the resource name
 *
 */
#define OS_REGISTER_RESOURCE(_taskName, _resourceName)  					\
		_resourceName.prioCeiling = 										\
			max(_resourceName.prioCeiling, __task_##_taskName.prioBase)

#endif
