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
#include "TaskPriority.h"
#include "FakeTask.h"

uint8_t flushed=0;
module PriorityTestC {
	uses {
		interface Timer<TMilli> as Timer;
		interface Leds;
		interface TaskBasic as LowPriority;
		interface TaskBasic as VeryHighPriority;
		interface TaskBasic as VeryLowPriority;
		interface Boot;
	}
}
implementation
{
	
	void waitLongTime(){
        uint32_t i=0;
        multipleFiveHundred(i, 5000);
    }
	
	event void Timer.fired() {
		call VeryLowPriority.postTask();
	}

	event void Boot.booted() {
		call Timer.startPeriodic(500);
	}

	event void LowPriority.runTask() {
		call Leds.led1On();
		call VeryHighPriority.postTask();
		waitLongTime();	
		call Leds.led1Off();
	}
	
	event void VeryHighPriority.runTask() {
		call Leds.led2On();
		waitLongTime();
		call Leds.led2Off();
	}
	
	event void VeryLowPriority.runTask() {
		call Leds.led0On();
		call LowPriority.postTask();
		waitLongTime();
		call Leds.led0Off();
	}
}
