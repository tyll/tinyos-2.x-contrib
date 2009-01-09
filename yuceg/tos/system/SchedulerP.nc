/*
 * "Copyright (c) 2000-2003 The Regents of the University  of California.  
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 * 
 * IN NO EVENT SHALL THE UNIVERSITY OF CALIFORNIA BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE UNIVERSITY OF
 * CALIFORNIA HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 * THE UNIVERSITY OF CALIFORNIA SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE UNIVERSITY OF CALIFORNIA HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
 *
 * Copyright (c) 2002-2003 Intel Corporation
 * All rights reserved.
 *
 * This file is distributed under the terms in the attached INTEL-LICENSE     
 * file. If you do not find these files, copies can be found by writing to
 * Intel Research Berkeley, 2150 Shattuck Avenue, Suite 1300, Berkeley, CA, 
 * 94704.  Attention:  Intel License Inquiry.
 */

/* 
 * Copyright (c) 2006, Cleveland State University
 * All rights reserved.
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 * 
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *     * Neither the name of Cleveland State University nor the
 *       names of its contributors may be used to endorse or promote products
 *       derived from this software without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS ``AS IS'' 
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS AND CONTRIBUTORS BE 
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
 * ARISING IN ANY WAY OUT OF THE USE # OF THIS SOFTWARE, EVEN IF ADVISED OF 
 * THE POSSIBILITY OF SUCH DAMAGE.
 */
 
/*
 * Author: William P. McCartney
 * Last modified: Nov 15, 2006
 */

/**
 * SchedulerP implements the modified Cooperative TinyOS scheduler.
 *
 * @author Philip Levis
 * @author Cory Sharp
 * @author Meysam Khezri <meysam.khezri@gmail.com>
 * @date   January 19 2005
 */
 
 
#include "hardware.h"
#include "job.h"
#include "context_switch.h"
#include "Timer.h"


module SchedulerP {
  provides interface Scheduler;
  provides interface TaskBasic[uint8_t id];
  provides interface Job[uint8_t id];
  provides interface JobControl;
  uses interface McuSleep;
}
implementation
{
  enum
  {
    NUM_TASKS = uniqueCount("TinySchedulerC.TaskBasic"),
	NUM_JOBS = uniqueCount("TinySchedulerC.Job"),
    NO_TASK = 255,
	NO_JOB = 255,
  };
  
  volatile uint8_t m_head;
  volatile uint8_t m_tail;
  volatile uint8_t m_next[NUM_TASKS];
  volatile uint8_t j_head;
  volatile uint8_t j_tail;
  volatile uint8_t j_next[NUM_JOBS];
  volatile job_t   j_list[NUM_JOBS];
  
  volatile uint8_t jobCounter = 0;
  volatile uint8_t taskCounter = 0;
  volatile bool preempt = FALSE;
  
  volatile job_t * current_job;
  // holds next job in taskLoop function. declared globally beacause of job_wrapper
  volatile uint8_t nextJob = NO_JOB;
  //system stack pointer;
  volatile uint16_t * sys_sp ;

  // Helper functions (internal functions) intentionally do not have atomic
  // sections.  It is left as the duty of the exported interface functions to
  // manage atomicity to minimize chances for binary code bloat.

  // move the head forward
  // if the head is at the end, mark the tail at the end, too
  // mark the task as not in the queue
  
  inline uint8_t popTask()
  { 
    if( m_head != NO_TASK )
    {
      uint8_t id = m_head;
      m_head = m_next[m_head];
      if( m_head == NO_TASK )
      {
		m_tail = NO_TASK;
      }
      m_next[id] = NO_TASK;
      taskCounter--;
      return id;
    }
    else
    {
      return NO_TASK;
    }
  }
  
  bool isWaiting( uint8_t id )
  {
    return (m_next[id] != NO_TASK) || (m_tail == id);
  }

  bool pushTask( uint8_t id )
  {
    if( !isWaiting(id) )
    {
      if( m_head == NO_TASK )
      {
		m_head = id;
		m_tail = id;
      }
      else
      {
		m_next[m_tail] = id;
		m_tail = id;
      }
	  taskCounter++;
	  preempt = TRUE;
      return TRUE;
    }
    else
    {
      return FALSE;
    }
  }
  
  void yield() __attribute__((noinline))
  {
		PUSH_STATUS();
		PUSH_GPR();
		atomic{SWAP_STACK_PTR(current_job->sp,sys_sp);}
		POP_GPR();
		POP_STATUS();
		return;
  }
  
  void platform_switch_to_job() __attribute__((noinline))
  {
		PUSH_STATUS();
		PUSH_GPR();
		atomic {SWAP_STACK_PTR(sys_sp,current_job->sp);}
		POP_GPR();
		POP_STATUS();
		return;
  }
   
  void remove_job(){
    atomic{
      current_job->state = NULL_STATE;
	  ((jobCounter) ? jobCounter-- : 0);
	  preempt = ((jobCounter > 1) || (taskCounter > 0));
	}
    yield();
  }
   
  void __attribute__((naked))  job_wrapper(){
    signal Job.runJob[nextJob]();
    remove_job();
  }
  
  inline uint8_t popJob()
  {
    if( j_head != NO_JOB )
    {
      uint8_t id = j_head;
      j_head = j_next[j_head];
      if( j_head == NO_JOB )
      {
		j_tail = NO_JOB;
      }
      j_next[id] = NO_JOB;
      return id;
    }
    else
    {
      return NO_JOB;
    }
  }
  
  bool pushJob( uint8_t id )
  {
	uint8_t i;
	if ( j_list[id].state != READY_STATE )
	{
		if( j_head == NO_JOB )
		{
			j_head = id;
			j_tail = id;
		}
		else
		{
			j_next[j_tail] = id;
			j_tail = id;
		}
		if ( j_list[id].state != RUNNING_STATE )
		{
			PREPARE_STACK();
		}
		jobCounter++;
		preempt = ((jobCounter > 1) || (taskCounter > 0));
		j_list[id].state = READY_STATE;
		return TRUE;
	}
	else
		return FALSE;
  }

  command void Scheduler.init()
  {
	atomic
    {
		memset( (void *)m_next, NO_TASK, sizeof(m_next) );
		m_head = NO_TASK;
		m_tail = NO_TASK;
		memset( (void *)j_next, NO_JOB, sizeof(j_next) );
		j_head = NO_JOB;
		j_tail = NO_JOB;
		memset( (void *)j_list, 0, sizeof(job_t) * NUM_JOBS);
    }
  }
  
  command bool Scheduler.runNextTask()
  {
    uint8_t nextTask;
    atomic
    {
      nextTask = popTask();
      if( nextTask == NO_TASK )
      {
		return FALSE;
      }
    }
    signal TaskBasic.runTask[nextTask]();
    return TRUE;
  }

  command void Scheduler.taskLoop()
  {
    for (;;)
    {
		uint8_t nextTask = NO_TASK;
		atomic
		{
			while ((nextTask = popTask()) == NO_TASK &&
				(nextJob = popJob()) == NO_JOB)
			{
				call McuSleep.sleep();
			}
		}
		if (nextTask != NO_TASK) {
			signal TaskBasic.runTask[nextTask]();
		}
		else if (nextJob != NO_JOB) {
			atomic {
				current_job = &j_list[nextJob];
				current_job->state = RUNNING_STATE;
			}
			platform_switch_to_job();
		}
    }
  }

  /**
   * Return SUCCESS if the post succeeded, EBUSY if it was already posted.
   */
  
  async command error_t TaskBasic.postTask[uint8_t id]()
  {
    atomic { return pushTask(id) ? SUCCESS : EBUSY; }
  }

  default event void TaskBasic.runTask[uint8_t id]()
  {
  }
  
  async command error_t Job.postJob[uint8_t id](uint16_t * s_addr) 
  {
    atomic { 
		j_list[id].sp = s_addr;
		j_list[id].state = NULL_STATE;
		j_list[id].id = id;
		return pushJob(id) ? SUCCESS : EBUSY; 
	}
  }
  
  inline default event void Job.runJob[uint8_t id]()
  {
  }
  
  inline command void Job.yield[uint8_t id]() 
  {
	if ( current_job->id == id )
	{
		atomic {
			pushJob(id);
		}
		yield();
	}
  }
  
  inline command void Job.cyield[uint8_t id]() 
  {
    bool flag;
	if ( current_job->id == id )
	{
		atomic {flag = preempt;}
		if (flag)
		{
			atomic {
				pushJob(id);
			}
			yield();
		}
	}
  }
  
  command uint8_t Job.getID[uint8_t id]()
  {
	return id;
  }
  
  inline command void JobControl.suspend(uint8_t id)
  {
	if ( current_job->id == id )
	{  
		yield();
	}
  }
  
  command void JobControl.resume(uint8_t id) 
  {
	atomic {
		pushJob(id);
	}
  }

}

