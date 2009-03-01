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

#include <Timer.h>
#include <AM.h>
#include <HplRF212.h>

configuration RF212TimeSyncMessageC
{
	provides
	{
		interface SplitControl;

		interface Receive[uint8_t id];
		interface Receive as Snoop[am_id_t id];
		interface Packet;
		interface AMPacket;

		interface TimeSyncAMSend<TRF212, uint32_t> as TimeSyncAMSendRadio[am_id_t id];
		interface TimeSyncPacket<TRF212, uint32_t> as TimeSyncPacketRadio;

		interface TimeSyncAMSend<TMilli, uint32_t> as TimeSyncAMSendMilli[am_id_t id];
		interface TimeSyncPacket<TMilli, uint32_t> as TimeSyncPacketMilli;
	}
}

implementation
{
	components RF212TimeSyncMessageP, RF212ActiveMessageC, LocalTimeMilliC, LocalTimeMicroC as LocalTimeRadioC, RF212PacketC;

	TimeSyncAMSendRadio = RF212TimeSyncMessageP;
	TimeSyncPacketRadio = RF212TimeSyncMessageP;

	TimeSyncAMSendMilli = RF212TimeSyncMessageP;
	TimeSyncPacketMilli = RF212TimeSyncMessageP;

	Packet = RF212TimeSyncMessageP;
	RF212TimeSyncMessageP.SubSend -> RF212ActiveMessageC.AMSend;
	RF212TimeSyncMessageP.SubPacket -> RF212ActiveMessageC.Packet;

	RF212TimeSyncMessageP.PacketTimeStampRadio -> RF212ActiveMessageC;
	RF212TimeSyncMessageP.PacketTimeStampMilli -> RF212ActiveMessageC;
	RF212TimeSyncMessageP.LocalTimeRadio -> LocalTimeRadioC;
	RF212TimeSyncMessageP.LocalTimeMilli -> LocalTimeMilliC;

	RF212TimeSyncMessageP.PacketTimeSyncOffset -> RF212PacketC.PacketTimeSyncOffset;

	SplitControl = RF212ActiveMessageC;
	Receive	= RF212ActiveMessageC.Receive;
	Snoop = RF212ActiveMessageC.Snoop;
	AMPacket = RF212ActiveMessageC;
}
