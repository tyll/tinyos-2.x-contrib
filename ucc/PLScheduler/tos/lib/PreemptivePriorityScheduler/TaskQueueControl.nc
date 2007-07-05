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
  * The TaskQueueControl provides method for the scheduler to intialize a 
  * task queue, and run the next task.
  * 
  * In turn each task queue must notify the scheduler when a new task has been posted with
  * notify function.
  *
  * @author Cormac Duffy 
  * @date   April 26 2007
  * @see    TaskQueueP
  * @see    SchedulerPriorityC
  */ 
interface TaskQueueControl{
	
  /**
   * signal to the scheduler that a new task has been posted
   */
	async event void queueNotify();
	
	/**
	  * signal to the scheduler that a task has begun processing
	  */
	async event inline void processStarted();
	
  
  /**
   * Run the next task in the queue
   * @return result of operation
   */
	command error_t runNextTask();
	
  /**
   * Initialize the task queue
   */
	command void initialize();
}

