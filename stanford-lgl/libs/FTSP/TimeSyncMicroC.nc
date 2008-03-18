/*
 * Copyright (c) 2002, Vanderbilt University
 * All rights reserved.
 *
 * Permission to use, copy,	modify,	and	distribute this	software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided	that the above copyright notice, the following
 * two paragraphs and the author appear	in all copies of this software.
 * 
 * IN NO EVENT SHALL THE VANDERBILT	UNIVERSITY BE LIABLE TO	ANY	PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE VANDERBILT
 * UNIVERSITY HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 * THE VANDERBILT UNIVERSITY SPECIFICALLY DISCLAIMS	ANY	WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF	MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR	PURPOSE.  THE SOFTWARE PROVIDED	HEREUNDER IS
 * ON AN "AS IS" BASIS,	AND	THE	VANDERBILT UNIVERSITY HAS NO OBLIGATION	TO
 * PROVIDE MAINTENANCE,	SUPPORT, UPDATES, ENHANCEMENTS,	OR MODIFICATIONS.
 *
 * Author: Miklos Maroti, Brano	Kusy
 * Date	last modified: 3/17/03
 * Ported to T2: 3/17/08 by Brano Kusy (branislav.kusy@gmail.com)
 */

includes TimeSyncMsg;

configuration TimeSyncMicroC
{
  uses interface Boot;
	provides interface Init;
	provides interface StdControl;
	provides interface GlobalTime;

	//interfaces for extra fcionality: need	not to be wired	
	provides interface TimeSyncInfo;
	provides interface TimeSyncMode;
	provides interface TimeSyncNotify;
}

implementation 
{
	components TimeSyncMicroM as TimeSyncM, NoLedsC as LedsC;

	GlobalTime = TimeSyncM;
	StdControl = TimeSyncM;
  Init = TimeSyncM;
  Boot = TimeSyncM;
	TimeSyncInfo = TimeSyncM;
	TimeSyncMode = TimeSyncM;
	TimeSyncNotify = TimeSyncM;
	
	components new TimerMilliC() as TimerC;
	TimeSyncM.Timer			-> TimerC;
	TimeSyncM.Leds			->  LedsC;

  components CC2420ActiveMessageC as ActiveMessageC;
  TimeSyncM.RadioControl-> ActiveMessageC;
  TimeSyncM.AMSend		-> ActiveMessageC.AMSend[AM_TIMESYNCMSG];
  TimeSyncM.Receive		-> ActiveMessageC.Receive[AM_TIMESYNCMSG];

	components TimeStampingTMicro32C as TimeStampingC;
  components CounterMicro32C, new CounterToLocalTimeC(TMicro);
	TimeSyncM.TimeStamping		-> TimeStampingC;
	CounterToLocalTimeC.Counter -> CounterMicro32C;  
  TimeSyncM.LocalTime             -> CounterToLocalTimeC;

}
