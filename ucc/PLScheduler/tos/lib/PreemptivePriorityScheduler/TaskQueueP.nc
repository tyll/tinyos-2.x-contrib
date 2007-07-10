/*
 * "Copyright (c) 2007 The Regents of the University College Cork
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 *
 * IN NO EVENT SHALL THE UNIVERSITY COLLEGE CORK BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE UNIVERSITY 
 * COLLEGE CORK HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * THE UNIVERSITY COLLEGE CORK SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE UNIVERSITY COLLEGE CORK HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
 */
 
/**
  * Generic Fifo Task queue. Reinstantiated for each task priority.
  * This component is controled by the PrioritySchedulerC.
  *
  * @param Number of tasks in the queue
  * @param Priority level of the task queue
  * @author Cormac Duffy 
  * @date   April 26 2007
  * @see    PrioritySchedulerC
  */ 
#include "TaskPriority.h"

generic module TaskQueueP(uint8_t NUM_TASKS, uint8_t PRIORITY) {
	provides interface TaskQueueControl;
	provides interface TaskBasic as PTask[uint8_t id]; 
	uses interface Leds; 
}
implementation
{
  uint8_t head, tail;
  uint8_t next[NUM_TASKS];
  

  inline bool isWaiting( uint8_t id)
  {
    return 	(next[id] != NO_TASK) || (tail == id);
  }	
  
  inline bool pushTask(uint8_t id)
  {
  	if( !isWaiting(id) )
    {
      if( head == NO_TASK )
      {
      	head = id;
		tail = id;
      }
      else
      {
		next[tail] = id;
		tail = id;
      }
	  return TRUE;
    }
    else
    {
   		return FALSE;
    }
  }

  inline uint8_t popTask()
  {
  	if( head != NO_TASK)
	    {
	      uint8_t id = head;
	      dbg("Scheduler", "POPTASK %hhu, priority %hhu ....\n",id);
     	  head = next[head];
     	  
	      if( head == NO_TASK )
	      {
			tail = NO_TASK;
	      }
	      next[id] = NO_TASK;
	      //process started is called here over runNextTask function, so that it stays in atomic
	      signal TaskQueueControl.processStarted();
	      return id;
	    }    
	    else
	    	return NO_TASK;
	  return NO_TASK;
  }
  
  command error_t TaskQueueControl.runNextTask(){
  	uint8_t nextTask;
    atomic{nextTask=popTask();}
	    if(nextTask==NO_TASK){
	    	return FALSE;
	    }
	    else{
	    	dbg("Scheduler", "Run Priority %hhu\n", PRIORITY);
	    	//move this statement into POP task so that it runs atomically!
	 		//signal TaskQueueControl.processStarted();
	 		signal PTask.runTask[nextTask]();
	    }
		return TRUE;
	
  }
	
 default event void PTask.runTask[uint8_t id](){}

  command void TaskQueueControl.initialize()
  {
  	int16_t i=0;
  	atomic
    {
  	   if(NUM_TASKS){
     	  tail = NO_TASK;
	  	  head = NO_TASK;
      	  for(i=0;i<NUM_TASKS;i++)
	      	next[i]=NO_TASK;
       }
  	}
  }
  
#ifdef TOSSIM     	    
	
  void sim_scheduler_event_handle(sim_event_t* e);
  /* This simulation state is kept on a per-node basis.
     Better to take advantage of nesC's automatic state replication
     than try to do it ourselves. */
  bool sim_scheduler_event_pending = FALSE;
  sim_event_t sim_scheduler_event;
	
  int sim_config_task_latency() {return 100;}
  
  /* Initialize a scheduler event. This should only be done
   * once, when the scheduler is initialized. */
  void sim_scheduler_event_init(sim_event_t* e) {
    e->mote = sim_node();
    e->force = 0;
    e->data = NULL;
    e->handle = sim_scheduler_event_handle;
    e->cleanup = sim_queue_cleanup_none;
  }
  
  /* Only enqueue the event for execution if it is
     not already enqueued. If there are more tasks in the
     queue, the event will re-enqueue itself (see the handle
     function). */
  
  void sim_scheduler_submit_event() {
    if (sim_scheduler_event_pending == FALSE) {
      sim_scheduler_event_init(&sim_scheduler_event);
      sim_scheduler_event.time = sim_time() + sim_config_task_latency();
      sim_queue_insert(&sim_scheduler_event);
      sim_scheduler_event_pending = TRUE;
    }
  }
  void sim_scheduler_event_handle(sim_event_t* e) {
    sim_scheduler_event_pending = FALSE;

    // If we successfully executed a task, re-enqueue the event. This
    // will always succeed, as sim_scheduler_event_pending was just
    // set to be false.  Note that this means there will be an extra
    // execution (on an empty task queue). We could optimize this
    // away, but this code is cleaner, and more accurately reflects
    // the real TinyOS main loop.
    
  if (call TaskQueueControl.runNextTask()==SUCCESS) {
      sim_scheduler_submit_event();
    }
  }
  #endif



  async command error_t PTask.postTask[uint8_t id]()
  {
  	error_t result;
     atomic {
     	result =  pushTask(id) ? SUCCESS : EBUSY;
     	if(result==SUCCESS)	
     		signal TaskQueueControl.queueNotify();
    	#ifdef TOSSIM     	    
			if(result==SUCCESS){
				dbg("Scheduler", "Post Priority %hhu\n", PRIORITY);
     			sim_scheduler_submit_event();
     		}
	    	else{
	    		dbgerror("SchedulerPriorityP", "Post Priority %hhu with id %hhu, but already posted.\n", PRIORITY, id);
	    	} 
    	#endif     	    
		
    	}
    	return result;
  }
}
