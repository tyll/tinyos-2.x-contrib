/*
 * "Copyright (c) 2007 Washington University in St. Louis.
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 *
 * IN NO EVENT SHALL WASHINGTON UNIVERSITY IN ST. LOUIS BE LIABLE TO ANY PARTY
 * FOR DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING
 * OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF WASHINGTON
 * UNIVERSITY IN ST. LOUIS HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * WASHINGTON UNIVERSITY IN ST. LOUIS SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND WASHINGTON UNIVERSITY IN ST. LOUIS HAS NO
 * OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR
 * MODIFICATIONS."
 */
 
/**
 * Stamps outgoing packets with SCP time synchronization information.
 *
 * @author Greg Hackmann
 */
configuration ScpSyncSenderC
{
	provides interface AsyncSend as Send;
	provides interface Interval as SyncInterval;
	provides interface StdControl;
	provides interface ScpSyncSender;
	
	uses interface AsyncSend as SubSend;
	uses interface AMPacket;
	uses interface Alarm<TMilli, uint16_t> as LplAlarm;
}
implementation
{
	components ScpSyncSenderP as Sync;
	components new VirtualizedAlarmMilli16C() as SyncAlarm;
	components LedsC;
	components ScpBootC as Boot;
	
	Send = Sync;
	SyncInterval = Sync;
	StdControl = Sync;
	ScpSyncSender = Sync;
	
	Sync.SubSend = SubSend;
	Sync.LplAlarm = LplAlarm;
	Sync.SyncAlarm -> SyncAlarm;
	Sync.Leds -> LedsC;
	Sync.AMPacket = AMPacket;
	Sync.ScpBoot -> Boot;
}
