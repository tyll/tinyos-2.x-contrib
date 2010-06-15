/* Copyright (c) 2010, Vanderbilt University
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 * 
 * IN NO EVENT SHALL THE VANDERBILT UNIVERSITY BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE VANDERBILT
 * UNIVERSITY HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 * THE VANDERBILT UNIVERSITY SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE VANDERBILT UNIVERSITY HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.
 *
 * Author:	Sandor Szilvasi
 * Date:	06/14/2010
 */
 
module TestHybridAlarmC
{
	uses interface Boot;

	uses interface Leds;
	uses interface Alarm<TMicro, uint32_t> as AlarmMicro;
	uses interface Alarm<TMicro, uint32_t> as AlarmHybrid;
	uses interface Timer<TMilli> as Timer;
}

implementation
{
	event void Boot.booted()
	{
		call Leds.set(0x00);

		call Timer.startPeriodic(1024);
		call AlarmMicro.startAt(call AlarmMicro.getNow(), 1048576L);
		call AlarmHybrid.startAt(call AlarmHybrid.getNow(), 1048576L);
	}

	/*----------------------------------------------------------------------------
							     Timers and Alarms
	----------------------------------------------------------------------------*/
	async event void AlarmHybrid.fired()
	{
		call Leds.led2Toggle();
		// set delay to 1 sec
		call AlarmHybrid.startAt(call AlarmHybrid.getNow(), 1048576L);
	}

	async event void AlarmMicro.fired()
	{
		call Leds.led1Toggle();
		// set delay to 1 sec
		call AlarmMicro.startAt(call AlarmMicro.getNow(), 1048576L);
		//call AlarmMicro.startAt(call AlarmMicro.getNow(), 1030000L);
	}

	event void Timer.fired()
	{
		call Leds.led0Toggle();
	}

}

