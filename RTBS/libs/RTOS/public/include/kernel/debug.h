/**
 *
 * debug.h
 *
 * Defines macros for debugging SmartOS. This API might be used by applications
 *
 * @author EAS Group - ITI - TU Graz for the RTOS Lab
 *
 * */



#ifndef __OS_DEBUG__H__
#define __OS_DEBUG__H__

#define OS_ASSERTIONS
/** Selects general runtime assertions for the OS kernel and application code in general.
 *  Remind, that runtime error checking may result in significant increase of execution times and rom/ram requirements.
 *  Thus, the temporal system behaviour might differ between activated and deactivated assertions.
 *
 *  If assertions are enabled, the DBG(x) macro redirects to printf.
 *  The assert(condition) macros check for validity of the condition.
 *  If the check fails, a kernel panic is raised and the system is stopped immediately. */
#if defined(OS_ASSERTIONS)
  #define QASSERT(what)           if (!(what)) PANIC("Assertion failed in %s:%s:%u\n", __FILE__, __FUNCTION__, __LINE__)
  #define ASSERT(what, x...)      if (!(what)) PANIC(x)
  #define DBG(x...)               printf(x)
#else
  #define QASSERT(what)           do {} while(0)
  #define ASSERT(what, x...)      do {} while(0)
  #define DBG(x...)               do {} while(0)
#endif

#define OSMSG(x...)               printf(x)

/** The PANIC macro is available for halting the system in case of unexpected system states.
 *  It first disables interrupts, then passes an information string to the printf function and finally
 *  enters an endless-loop for halting the system.
 *  Since PANIC does explicitly disable interrupts, it requires printf to work without interrupts! */
#define PANIC(x...) do {                     \
  __dint();                                  \
  printf("\n###########\nOS Panic: ");       \
  printf(x);                                 \
  printf("\n###########\n");                 \
  while(1); } while (0);                     \

#endif
