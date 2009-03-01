/*
 * Copyright (c) 2007, Vanderbilt University
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
 * Author: Miklos Maroti
 */

#include <HplRF212.h>

configuration RF212LayerC
{
	provides
	{
		interface RadioState;
		interface RadioSend;
		interface RadioReceive;
		interface RadioCCA;
	}

	uses interface RF212Config;
}

implementation
{
	components RF212LayerP, HplRF212C, BusyWaitMicroC, TaskletC, MainC, RadioAlarmC, RF212PacketC, LocalTimeMicroC as LocalTimeRadioC;

	RadioState = RF212LayerP;
	RadioSend = RF212LayerP;
	RadioReceive = RF212LayerP;
	RadioCCA = RF212LayerP;

	RF212Config = RF212LayerP;

	RF212LayerP.PacketLinkQuality -> RF212PacketC.PacketLinkQuality;
	RF212LayerP.PacketTransmitPower -> RF212PacketC.PacketTransmitPower;
	RF212LayerP.PacketRSSI -> RF212PacketC.PacketRSSI;
	RF212LayerP.PacketTimeSyncOffset -> RF212PacketC.PacketTimeSyncOffset;
	RF212LayerP.PacketTimeStamp -> RF212PacketC;
	RF212LayerP.LocalTime -> LocalTimeRadioC;

	RF212LayerP.RadioAlarm -> RadioAlarmC.RadioAlarm[unique("RadioAlarm")];
	RadioAlarmC.Alarm -> HplRF212C.Alarm;

	RF212LayerP.SELN -> HplRF212C.SELN;
	RF212LayerP.SpiResource -> HplRF212C.SpiResource;
	RF212LayerP.SpiByte -> HplRF212C;
	RF212LayerP.HplRF212 -> HplRF212C;

	RF212LayerP.SLP_TR -> HplRF212C.SLP_TR;
	RF212LayerP.RSTN -> HplRF212C.RSTN;

	RF212LayerP.IRQ -> HplRF212C.IRQ;
	RF212LayerP.Tasklet -> TaskletC;
	RF212LayerP.BusyWait -> BusyWaitMicroC;

#ifdef RF212_DEBUG
	components DiagMsgC;
	RF212LayerP.DiagMsg -> DiagMsgC;
#endif

	MainC.SoftwareInit -> RF212LayerP.SoftwareInit;

	components RealMainP;
	RealMainP.PlatformInit -> RF212LayerP.PlatformInit;
}
