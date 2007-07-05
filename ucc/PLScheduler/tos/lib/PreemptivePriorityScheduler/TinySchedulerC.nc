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
  * Replaces the Regular TinySchedulerC component in tinyos, to wire in the
  * PrioritySchedulerC.
  * <BR>
  *
  * @author Cormac Duffy 
  * @date   April 26 2007
  * @see    SchedulerPriorityC
  */ 
#include "TaskPriority.h"
configuration TinySchedulerC {
  provides interface Scheduler;
  provides interface TaskBasic[uint8_t id];
}
implementation {
  components PrioritySchedulerC as Sched;
  components McuSleepC as Sleep;
  components new TaskQueueP(NUM_BASIC_TASKS, BASIC) as taskHandler;
  components LedsC;
  taskHandler.Leds -> LedsC;
  TaskBasic = taskHandler.PTask;
  Sched.TaskQueueControl[BASIC]->taskHandler.TaskQueueControl;
  Sched.McuSleep -> Sleep;
  Scheduler = Sched;
}
