/*
 * Copyright (c) 2010, Vanderbilt University
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

configuration TestHybridAlarmAppC
{
}

implementation
{
	components TestHybridAlarmC as App;
	components MainC;

	components LedsC;
	//components NoLedsC as LedsC;
	components new TimerMilliC() as Timer;
	components new AlarmMicro32C() as AlarmMicro;
	components AlarmHybridMicro32C as AlarmHybrid;

	components NoSleepC;

	// Initialization
	App					-> MainC.Boot;

	// Misc
	App.Leds			-> LedsC;
	App.AlarmHybrid		-> AlarmHybrid;
	App.AlarmMicro		-> AlarmMicro;
	App.Timer			-> Timer;

}
