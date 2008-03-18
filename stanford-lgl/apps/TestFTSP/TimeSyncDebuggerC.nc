/*
 * Copyright (c) 2002, Vanderbilt University
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
 * @author: Miklos Maroti, Brano Kusy (kusy@isis.vanderbilt.edu)
 * Ported to T2: 3/17/08 by Brano Kusy (branislav.kusy@gmail.com)
 */

includes TestTimeSyncPollerMsg;

configuration TimeSyncDebuggerC
{
    provides interface Init;
    uses interface Boot;
}

implementation 
{
    components TimeSyncDebuggerM, 
				NoLedsC as LedsC,
#ifdef TS_MICRO
				TimeSyncMicroC as TimeSyncC, TimeStampingTMicro32C as TimeStampingC;
#else
				TimeSyncC, TimeStamping32khz32C as TimeStampingC;
#endif
    Init = TimeSyncDebuggerM;
    Boot = TimeSyncDebuggerM;

		components CC2420ActiveMessageC as ActiveMessageC; 
    TimeSyncDebuggerM.RadioControl 	-> ActiveMessageC;
    TimeSyncDebuggerM.Receive   	-> ActiveMessageC.Receive[AM_TIMESYNCPOLL];
    TimeSyncDebuggerM.AMSend    	-> ActiveMessageC.AMSend[AM_TIMESYNCPOLLREPLY];

    components new TimerMilliC();
    TimeSyncDebuggerM.Timer         	-> TimerMilliC;
    TimeSyncDebuggerM.GlobalTime    	-> TimeSyncC;
    TimeSyncDebuggerM.TimeSyncInfo  	-> TimeSyncC;
    TimeSyncDebuggerM.Leds          	-> LedsC;
    TimeSyncDebuggerM.TimeStamping  	-> TimeStampingC;
}
