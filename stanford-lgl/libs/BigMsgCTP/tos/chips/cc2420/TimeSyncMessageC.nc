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

configuration TimeSyncMessageC
{
	provides
	{
		interface TimeSyncSend<T32khz> as TimeSyncSend32khz[am_id_t id];
		interface TimeSyncEvent<T32khz> as TimeSyncEvent32khz;
		interface LocalTime<T32khz> as LocalTime32khz;

		interface SplitControl;
		interface Receive[uint8_t id];
		interface Receive as Snoop[am_id_t id];
		interface Packet;
		interface AMPacket;
		interface PacketAcknowledgements;
	}
}

implementation
{
	components TimeSyncMessageP as TSActiveMessageP, ActiveMessageC, LedsC;
  components Counter32khz32C,	new CounterToLocalTimeC(T32khz) as CounterToLocal32khzC;

	TimeSyncSend32khz = TSActiveMessageP;
	TimeSyncEvent32khz = TSActiveMessageP;
  CounterToLocal32khzC.Counter -> Counter32khz32C;
  LocalTime32khz = CounterToLocal32khzC;

	Packet = TSActiveMessageP;
	TSActiveMessageP.SubSend -> ActiveMessageC.AMSend;
	TSActiveMessageP.SubPacket -> ActiveMessageC.Packet;

	TSActiveMessageP.LocalTime32khz -> CounterToLocal32khzC;
	TSActiveMessageP.Leds -> LedsC;

	SplitControl = ActiveMessageC;
	Receive	= ActiveMessageC.Receive;
	Snoop = ActiveMessageC.Snoop;
	AMPacket = ActiveMessageC;
	PacketAcknowledgements = ActiveMessageC;
	
	components CC2420TransmitC, CC2420PacketC, new CC2420SpiC(), HplCC2420PinsC as Pins;
	TSActiveMessageP.PacketLastTouch -> CC2420TransmitC;
	TSActiveMessageP.PacketTimeStamp -> CC2420PacketC;
	TSActiveMessageP.CC2420Ram  -> CC2420SpiC.TXFIFO_RAM;
  TSActiveMessageP.CSN -> Pins.CSN;
}
