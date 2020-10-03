/*
 * queues.c
 *
 *  Created on: 21-April-2017
 *      Author: Group_23
 */

#include<kernel/kernel.h>
#include<msp430f5529.h>
#include"kernel_intern.h"
#include<assert.h>

//Helping variables
uint16_t os_kernel_mode;
Task_t* os_runningTask;
TaskId_t os_readyQueue;
TaskId_t os_timeoutQueue;
uint8_t os_timeoutQueueDirty;


// Function to get the reference of tasks
Task_t* get_task_from_id(TaskId_t task_id) {

     // if we get the NIL_ID just return a
     if(task_id == NIL_ID)
       return NULL;

    // not existing task_id
   if (task_id >= os_taskCount)
       return NULL;

    return &os_tasks[task_id];
  }

//------------------------------------------------------------------------------
///
/// Function to insert a Task into a given member list.
/// Description is written in kernel_intern.h
///
//
void insert_into_memberlist(TaskId_t task_id, TaskId_t *list) {
  // assert if the given memberlist is a NULL pointer
  ASSERT(list != NULL, "list is a NULL pointer.");

  // search for the given task via the task_id
  Task_t* task = get_task_from_id(task_id);

  // if the task is not found (not sure what to do.)
  ASSERT(task != NULL, "the given task is not found in the os_tasks array.\n");

  // if the list is the NIL_ID the given task will become the queues head
  if(*list == NIL_ID) {
    *list = task->id;
    task->memberlist = list;
    task->next = NIL_ID;
    return;
  }

  // if the task is already in the given member list then return
  if(task->memberlist == list)
    return;

  // search for the head task in the memberlist
  Task_t* head = get_task_from_id(*list);
  ASSERT(head != NULL, "the head task of the list is not in the os_tasks array.\n");

  // search for the corretc location where the given task should be inserted
  Task_t* next = head;
  Task_t* prev = NULL;
  while((next != NULL) && (next->prioActive >= task->prioActive)) {
    prev = next;
    next = get_task_from_id(next->next);
  }

  // set all necessary TCB entries
  if(next == head) {                // task gets head of list
    task->memberlist = list;
    task->next = head->id;
    *list = task->id;
  } else if(next == NULL) { // task gets tail of list
    prev->next = task->id;
    task->next = NIL_ID;
    task->memberlist = list;
  } else {                          // task is in the middle of the queue
    prev->next = task->id;
    task->next = next->id;
    task->memberlist = list;
  }
  return;
}

//------------------------------------------------------------------------------
///
/// Function to remove a Task from its current member list.
/// Description is written in kernel_intern.h
///
//
void remove_from_memberlist(TaskId_t task_id) {
  // assert if the idle task should be removed
  ASSERT(task_id != 0, "can't remove the IDLE-Task from the given list.\n");

  // search for the given task via the task_id
  Task_t* task = get_task_from_id(task_id);

  // if the task is not found (not sure what to do.)
  ASSERT(task != NULL, "given task is not found in the os_tasks array.\n");

  // if the task is in no memberlist
  if(task->memberlist == NULL)
    return;

  if(task->id == *task->memberlist) {
    // set the *memberlist to the next task in the queue
    *(task->memberlist) = task->next;
    // printfx("hi %d\n", task->next);
    // set the memberlist to the NULL pointer
    task->memberlist = NULL;
    return;
  }

  // search for the head of the memberlist
  Task_t* head = get_task_from_id(*task->memberlist);
  ASSERT(head != NULL, "head task of the memberlist is not in the os_tasks array.\n");

  Task_t* prev = head;
  while((prev != NULL) && (prev->next != task->id))
    prev = get_task_from_id(prev->next);

  // assert if the given task is not in the memberlist (this should never be the case)
  ASSERT(prev->next != NIL_ID, "the given task is not in the memberlist.\n");

  // set all necessary TCB entries
  if(task->next == NIL_ID) {  // last entry
    prev->next = NIL_ID;
    task->memberlist = NULL;
  } else {                    // middle entry
    Task_t* next = get_task_from_id(task->next);
    prev->next = next->id;
    task->next = NIL_ID;
    task->memberlist = NULL;
  }
  return;
}

//------------------------------------------------------------------------------
///
/// Function to insert a Task into the timeout queue.
/// Description is written in kernel_intern.h
///
//
void insert_into_timeout_queue(TaskId_t task_id) {
  // get task from the given task_id
  Task_t *task = get_task_from_id(task_id);
  ASSERT(task != NULL, "given task is not in os_tasks array.\n");

  // if the timeout queue is empty
  if(os_timeoutQueue == NIL_ID) {
    os_timeoutQueue = task->id;
    task->next_timeout = NIL_ID;
    os_timeoutQueueDirty = 1;
    return;
  }

  // get the head of the global timeout queue
  Task_t *tq_head = get_task_from_id(os_timeoutQueue);

  // check if the task is already in the timeout-queue
  Task_t *next = tq_head;
  while((next != NULL) && (next->id != task->id))
    next = get_task_from_id(next->next_timeout);

  if(next != NULL)
    PANIC("task %d is already in the timeout-queue", task_id);

  // task is not in the timeout-queue -> must be inserted
  next = tq_head;
  Task_t* prev = NULL;
  while((next != NULL) && (next->timeout <= task->timeout)) {
    prev = next;
    next = get_task_from_id(next->next_timeout);
  }

  // set all necessary TCB entries
  if(next == tq_head) {                       // task gets head
    os_timeoutQueue = task->id;
    task->next_timeout = tq_head->id;
    os_timeoutQueueDirty = 1;
  } else if(next->next_timeout == NIL_ID) {   // task gets tail
    next->next_timeout = task->id;
    task->next_timeout = NIL_ID;
  } else {                                    // task is in the middle of the queue
    prev->next_timeout = task->id;
    task->next_timeout = next->id;
  }
  return;
}
