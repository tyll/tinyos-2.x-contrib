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
		interface Timer<TMilli> as Timer1;
		interface Timer<TMilli> as Timer2;
		interface Leds;
		interface TaskBasic as VeryLowPriority;
		interface Boot;
	}
}
implementation
{
	uint8_t count=0;
	uint8_t errorCheck=0;
	uint16_t status_register[3]= {0,0,0};
	uint8_t flushCount=0;
	
	/** Simple 2 second task*/
    void waitLongTime(){
        uint32_t i=0;
        multipleFiveHundred(i, 14000);
    }

	event void Timer1.fired() {
		call Timer1.startPeriodic(3000);
		call VeryLowPriority.postTask();
	}
	event void Timer2.fired() {
		call Leds.led1Toggle();
	}

	event void Boot.booted() {
		call Timer1.startOneShot(100);
		call Timer2.startPeriodic(250);
	}

	event void VeryLowPriority.runTask() {
		call Leds.led0On();
		waitLongTime();
		call Leds.led0Off();
		
	}
}
