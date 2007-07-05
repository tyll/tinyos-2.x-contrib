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
  * New Priority Task component. Every module that uses a priority task <BR>
  * must first define a priority task in the module: <BR>
  * <CODE>uses interface TaskBasic</CODE><BR>
  * and wire it to the appropriate generic task componet<BR>
  * <CODE>new component HighTaskC() </CODE><BR>
  * <CODE>component.TaskBasic -> HighTaskC</CODE><BR> 
  *
  * @author Cormac Duffy 
  * @date   April 26 2007
  * @see    TaskQueueP
  * @see    SchedulerPriorityC
  */ 
#include "TaskPriority.h"
generic configuration LowTaskC() {
  provides interface TaskBasic;
}
implementation {
  components LowTaskImplP;
  TaskBasic = LowTaskImplP.TaskBasic[unique("TaskPriority<TASKLOW>")];
}
