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

#ifndef TASKPRIORITY_H_
#define TASKPRIORITY_H_

  /*calculate the Number of tasks for each priority queue*/
  enum
  {
    NUM_VERYLOW_TASKS = uniqueCount("TaskPriority<TASKVERYLOW>"),
    NUM_LOW_TASKS = uniqueCount("TaskPriority<TASKLOW>"),
    NUM_HIGH_TASKS = uniqueCount("TaskPriority<TASKHIGH>"),
    NUM_BASIC_TASKS = uniqueCount("TinySchedulerC.TaskBasic"),
    NUM_VERYHIGH_TASKS = uniqueCount("TaskPriority<TASKVERYHIGH>"),
    NO_TASK = 255,
  };
  
  	
    /*calculates the Index of each priority at compile time. If there are no tasks for a priority queue
     * than that queue is ignored and the index of the higher queues are decremented*/
    enum{
	VERYLOW=(NUM_VERYLOW_TASKS>0)?0:NO_TASK,
	LOW=(NUM_LOW_TASKS>0)?(1-(VERYLOW==NO_TASK)?1:0):NO_TASK,
	BASIC=(NUM_BASIC_TASKS>0)?(2-(((VERYLOW==NO_TASK)?1:0) + ((LOW==NO_TASK)?1:0))):NO_TASK,
	HIGH=(NUM_HIGH_TASKS>0)?(3- (((VERYLOW==NO_TASK)?1:0) + ((LOW==NO_TASK)?1:0) + ((BASIC==NO_TASK)?1:0))):NO_TASK,
	VERYHIGH=(NUM_VERYHIGH_TASKS>0)?(4-(((VERYLOW==NO_TASK)?1:0) + ((HIGH==NO_TASK)?1:0) + ((LOW==NO_TASK)?1:0) + ((BASIC==NO_TASK)?1:0))):NO_TASK,
	NUM_PRIORITIES=(5-(((VERYLOW==NO_TASK)?1:0) + ((HIGH==NO_TASK)?1:0) + ((LOW==NO_TASK)?1:0) + ((BASIC==NO_TASK)?1:0) + ((VERYHIGH==NO_TASK)?1:0))),
	MAX_NON_PREEMPTIVE=(3-(((HIGH==NO_TASK)?1:0) + ((LOW==NO_TASK)?1:0) + ((BASIC==NO_TASK)?1:0))),
	HIGHER_PREEMPTIVE_INDEX=(MAX_NON_PREEMPTIVE+1),
	LOWER_PREEMPTIVE_INDEX=1,
	HIGH_MASK = (HIGH==NO_TASK)?0:((0|1)<<1),
	BASIC_MASK = (BASIC==NO_TASK)?HIGH_MASK:((HIGH_MASK|1)<<1),
	MASK = (LOW==NO_TASK)?BASIC_MASK:((BASIC_MASK|1)<<1),
  };
  
  enum{
	VERYLOWCASE=(VERYLOW!=NO_TASK)?VERYLOW:NO_TASK,
	LOWCASE=(LOW!=NO_TASK)?LOW:NO_TASK-1,
	BASICCASE=(BASIC!=NO_TASK)?BASIC:NO_TASK-2,
	HIGHCASE=(HIGH!=NO_TASK)?HIGH:NO_TASK-3,
	VERYHIGHCASE=(VERYHIGH!=NO_TASK)?VERYHIGH:NO_TASK-4,	
  };
  
 // (HIGH==NO_TASK)?NO_TASK-4:HIGH:
  
  
  /** context structure definition */
	typedef struct context_s {
	   /** Stack pointer */
	   uint16_t *sp;
	   /** Pointer to stack memory for de-allocating */
	   uint16_t *stack;
	} context_t;
	
	
	enum{
		BASE_CONTEXT=0,
		PREEMPTING_CONTEXT=1,
		HIGHER_PREEMPT_CONTEXT=2,
		NUM_CONTEXTS=3,
	};

#endif /*TASKPRIORITY_H_*/
