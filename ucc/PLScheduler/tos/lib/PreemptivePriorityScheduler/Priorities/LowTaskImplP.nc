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
  * Provides a static interface to wire each Task Queue to the Scheduler. It is necessary
  * to provide this wiring statically, (instead of using generic configurations/components)
  * to ensure the nesc compiler only includes Queues for the Task Priorities needed.
  * <BR>
  *
  * @author Cormac Duffy 
  * @date   April 26 2007
  * @see    TaskQueueP
  * @see    SchedulerPriorityC
  */ 

#include "TaskPriority.h"
configuration LowTaskImplP {
  provides interface TaskBasic[uint8_t id];
}
implementation {
  components new TaskQueueP(NUM_LOW_TASKS, LOW) as taskHandler;
  components PrioritySchedulerC;
  TaskBasic = taskHandler;
  PrioritySchedulerC.TaskQueueControl[LOW] -> taskHandler.TaskQueueControl;
  components LedsC;
  taskHandler.Leds -> LedsC;
}
