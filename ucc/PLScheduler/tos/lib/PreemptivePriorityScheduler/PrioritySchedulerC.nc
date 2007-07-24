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
 * SchedulerPriorityC Implements a priority task queue. Up to five priorities.
 * The Scheduler will only implement queues for the required priorities. If a queue
 * is not being used by any task of that priority, then the queue is not compiled in 
 * to the code.
 *
 * @author Cormac Duffy
 * @date   October 15 2006
 */

#include "hardware.h"
#include "TaskPriority.h"
#include "context_switch.h"


module PrioritySchedulerC {
  provides interface Scheduler;
  uses interface TaskQueueControl[uint8_t id];
  uses interface McuSleep;
  uses interface Leds;
}
implementation
{
  int8_t pIndex=0;
  volatile uint16_t *stack_addr;
  volatile uint8_t idex, oldWaiting;
  volatile norace uint8_t lowerPriorityContext=0;
  volatile norace uint8_t tasksWaiting=0;
  volatile norace uint8_t tasksProcessing;
  norace static context_t contexts[NUM_CONTEXTS]; // Our array of system thread data structs

  
  void preemption_handler()__attribute__ ((C, spontaneous)){
  	
  	if(tasksWaiting>= (1<<VERYHIGH)){
  		while(call TaskQueueControl.runNextTask[VERYHIGH]() != FALSE);
  		tasksWaiting &= ~(1<<VERYHIGH);
  		tasksProcessing &= ~(1<<VERYHIGH);
  		if(lowerPriorityContext){
		  	POP_CONTEXT(PREEMPTING_CONTEXT);
 		}
		else{
		  	POP_CONTEXT(BASE_CONTEXT);
		}
  	}else{
  		
  		pIndex = MAX_NON_PREEMPTIVE;
	
		while(tasksWaiting & MASK){
  			switch(tasksWaiting & MASK){
  				case 8: case 9: case 10: case 11: case 12: case 13: case 14: case 15:
  			     	if(call TaskQueueControl.runNextTask[3]() == FALSE)
  			     		tasksWaiting &= ~(1<<3);
  			     	tasksProcessing &= ~(1<<3);
  			     break;
  			    case 4: case 5: case 6: case 7:   
  			     	if(call TaskQueueControl.runNextTask[2]() == FALSE)
  			     		tasksWaiting &= ~(1<<2);
  			     	tasksProcessing &= ~(1<<2);
  			  	 break;
  			    case 2: case 3: 
  			    	if(call TaskQueueControl.runNextTask[1]() == FALSE)
  			     		tasksWaiting &= ~(1<<1);
  			     	tasksProcessing &= ~(1<<1);
  			  	 break;
  			}
  		}
  		lowerPriorityContext=0;
  		POP_CONTEXT(BASE_CONTEXT);
	}
  }
  
  command void Scheduler.init()__attribute__((noinline))
  { 
  	uint8_t i=0;
  	for(i=0;i<NUM_PRIORITIES;i++){
  		call TaskQueueControl.initialize[i]();
  	}
  }
  
  
  
  default command void TaskQueueControl.initialize[uint8_t id](){}
  
  void inline handleTask(){
  	   switch(tasksWaiting){ 
     	case 16: case 17: case 18: case 19: case 20: case 21: case 22: case 23: case 24: case 25: case 26: case 27: case 28: case 29: case 30: case 31:
     		if(call TaskQueueControl.runNextTask[4]() == FALSE)
     			tasksWaiting &= ~(1<<4);
     		tasksProcessing &= ~(1<<4);
     		
     	break;
     	case 8: case 9: case 10: case 11: case 12: case 13: case 14: case 15:
     		if(call TaskQueueControl.runNextTask[3]() == FALSE)
     			tasksWaiting &= ~(1<<3);
     		tasksProcessing &= ~(1<<3);
     		
  	 	break;
     	case 4: case 5: case 6: case 7:   
     		if(call TaskQueueControl.runNextTask[2]() == FALSE)
     			tasksWaiting &= ~(1<<2);
     		tasksProcessing &= ~(1<<2);
  	   		
     	break;
     	case 2: case 3: 
     		if(call TaskQueueControl.runNextTask[1]() == FALSE)
     			tasksWaiting &= ~(1<<1);
     		tasksProcessing &= ~(1<<1);
  			
     	break;
     	case 1:
     		if(call TaskQueueControl.runNextTask[0]() == FALSE)
     			tasksWaiting &= ~1;
     		tasksProcessing &= ~1;
     		
     	break;
     }
  }

  //command inline bool Scheduler.runNextTask(){
  command bool Scheduler.runNextTask()__attribute__((noinline)){
	 handleTask();
     return tasksWaiting;
  }
  
  
  void SwitchMe(uint8_t id)__attribute__((noinline)){
  	atomic{
  	oldWaiting = tasksWaiting;
  	tasksWaiting|=(1<<id);
  	if(oldWaiting ==tasksWaiting)//if task already waiting then return
  		return;
  		
  	switch(id){
	  		//preempts all other tasks 
		  	case VERYHIGHCASE:
			/* CONDITIONS FOR VERYHIGH PREEMPTION:
		  	 * - VERYHIGH Task is not currently running
		  	 * - OTHER tasks (medium, low, high, verylow) are running.
		  	 * TASKSPROCESSING LESS THAN 1<<VERYHIGH
		  	 * TASKSPROCESSING > 0*/		  		
		  		if(tasksProcessing < (1<<HIGHER_PREEMPTIVE_INDEX)&&tasksProcessing > 0 ){
		  			GET_SP(stack_addr);
					stack_addr -=CONTEXT_DIFF;    
					
					/* check if any LOW/BASIC/HIGH tasks have preempted a VERYLOW TASK
					 * if preemption has already occured than the HIGHER_PREEMPT_CONTEXT
					 * will have to be initialised from PREEMPTING_CONTEXT instead of BASE_CONTEXT*/
					if(lowerPriorityContext==0){
						CONTEXT_SWITCH_PREAMBLE(BASE_CONTEXT,HIGHER_PREEMPT_CONTEXT);
						PUSH_CONTEXT(BASE_CONTEXT);
					}
					else{
						CONTEXT_SWITCH_PREAMBLE(PREEMPTING_CONTEXT,HIGHER_PREEMPT_CONTEXT);
						PUSH_CONTEXT(PREEMPTING_CONTEXT);
					}
					POP_CONTEXT(HIGHER_PREEMPT_CONTEXT);
		  		}
		  			
		  	break;
		  	case BASICCASE:case LOWCASE: case HIGHCASE:
		  	  		
			/*
		  	 * CONDITIONS FOR PREEMPTION:
		  	 * - A VERYLOW task is defined, (VERYLOW != 255)
		  	 * - VERYHIGH Task is not currently running
		  	 * - OTHER tasks (medium, low, high) are not running.
		  	 * - VERTLOW Task is running
		  	 * TASKS_PROCESSING MUST EQUAL 1<<VERYLOW
		  	 */
		  		if(VERYLOW!=255){
		  			if(tasksProcessing == LOWER_PREEMPTIVE_INDEX){
		  				lowerPriorityContext=1;
						GET_SP(stack_addr);			  			
						stack_addr -=CONTEXT_DIFF;    
						CONTEXT_SWITCH_PREAMBLE(BASE_CONTEXT,PREEMPTING_CONTEXT);
						PUSH_CONTEXT(BASE_CONTEXT);
						POP_CONTEXT(PREEMPTING_CONTEXT);
			  		}
		  		}
		  	
		  	break;
		}
  	}
  }
  
  async event void TaskQueueControl.queueNotify[uint8_t id]()__attribute__((noinline)){
  	  	SwitchMe(id);
  }
  
  async event inline void TaskQueueControl.processStarted[uint8_t id](){
    tasksProcessing|=(1<<id);
  };
  
  command void Scheduler.taskLoop(){
    	for (;;)
	    {
	    	handleTask();
	    	while(!tasksWaiting){
		    	atomic{
		         call McuSleep.sleep();
				}
	    	}
	    }		    
	}
	
	default command error_t TaskQueueControl.runNextTask[uint8_t id](){return FAIL;}
}

