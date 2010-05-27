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
 * Author: Miklos Maroti, Janos Sallai
 */

#include <RadioConfig.h>

configuration Cc2420XRadioC
{
	provides 
	{
		interface SplitControl;

#ifndef IEEE154FRAMES_ENABLED
		interface AMSend[am_id_t id];
		interface Receive[am_id_t id];
		interface Receive as Snoop[am_id_t id];
		interface SendNotifier[am_id_t id];

		interface AMPacket;
		interface Packet as PacketForActiveMessage;
#endif

#ifndef TFRAMES_ENABLED
		interface Ieee154Send;
		interface Receive as Ieee154Receive;
		interface SendNotifier as Ieee154Notifier;

		interface Resource as SendResource[uint8_t clint];

		interface Ieee154Packet;
		interface Packet as PacketForIeee154Message;
#endif

		interface PacketAcknowledgements;
		interface LowPowerListening;

#ifdef PACKET_LINK
		interface PacketLink;
#endif

		interface RadioChannel;

		interface PacketField<uint8_t> as PacketLinkQuality;
		interface PacketField<uint8_t> as PacketTransmitPower;
		interface PacketField<uint8_t> as PacketRSSI;

		interface LocalTime<TRadio> as LocalTimeRadio;
		interface PacketTimeStamp<TRadio, uint32_t> as PacketTimeStampRadio;
		interface PacketTimeStamp<TMilli, uint32_t> as PacketTimeStampMilli;
	}
}

implementation
{
	components Cc2420XRadioP, RadioAlarmC;

#ifdef RADIO_DEBUG
	components AssertC;
#endif

	Cc2420XRadioP.Ieee154PacketLayer -> Ieee154PacketLayerC;
	Cc2420XRadioP.RadioAlarm -> RadioAlarmC.RadioAlarm[unique("RadioAlarm")];
	Cc2420XRadioP.PacketTimeStamp -> TimeStampingLayerC;
	Cc2420XRadioP.Cc2420XPacket -> Cc2420XDriverLayerC;

// -------- Active Message

#ifndef IEEE154FRAMES_ENABLED
	components ActiveMessageLayerC;
	ActiveMessageLayerC.Config -> Cc2420XRadioP;
	ActiveMessageLayerC.SubSend -> AutoResourceAcquireLayerC;
	ActiveMessageLayerC.SubReceive -> TinyosNetworkLayerC.TinyosReceive;
	ActiveMessageLayerC.SubPacket -> TinyosNetworkLayerC.TinyosPacket;

	AMSend = ActiveMessageLayerC;
	Receive = ActiveMessageLayerC.Receive;
	Snoop = ActiveMessageLayerC.Snoop;
	SendNotifier = ActiveMessageLayerC;
	AMPacket = ActiveMessageLayerC;
	PacketForActiveMessage = ActiveMessageLayerC;
#endif

// -------- Automatic RadioSend Resource

#ifndef IEEE154FRAMES_ENABLED
#ifndef TFRAMES_ENABLED
	components new AutoResourceAcquireLayerC();
	AutoResourceAcquireLayerC.Resource -> SendResourceC.Resource[unique(RADIO_SEND_RESOURCE)];
#else
	components new DummyLayerC() as AutoResourceAcquireLayerC;
#endif
	AutoResourceAcquireLayerC.SubSend -> TinyosNetworkLayerC.TinyosSend;
#endif

// -------- RadioSend Resource

#ifndef TFRAMES_ENABLED
	components new SimpleFcfsArbiterC(RADIO_SEND_RESOURCE) as SendResourceC;
	SendResource = SendResourceC;

// -------- Ieee154 Message

	components Ieee154MessageLayerC;
	Ieee154MessageLayerC.Ieee154PacketLayer -> Ieee154PacketLayerC;
	Ieee154MessageLayerC.Ieee154Packet -> Ieee154PacketLayerC;
	Ieee154MessageLayerC.SubSend -> TinyosNetworkLayerC.Ieee154Send;
	Ieee154MessageLayerC.SubReceive -> TinyosNetworkLayerC.Ieee154Receive;
	Ieee154MessageLayerC.RadioPacket -> TinyosNetworkLayerC.Ieee154Packet;

	Ieee154Send = Ieee154MessageLayerC;
	Ieee154Receive = Ieee154MessageLayerC;
	Ieee154Notifier = Ieee154MessageLayerC;
	Ieee154Packet = Ieee154PacketLayerC;
	PacketForIeee154Message = Ieee154MessageLayerC;
#endif

// -------- Tinyos Network

	components TinyosNetworkLayerC;

	TinyosNetworkLayerC.SubSend -> UniqueLayerC;
	TinyosNetworkLayerC.SubReceive -> LowPowerListeningLayerC;
	TinyosNetworkLayerC.SubPacket -> Ieee154PacketLayerC;

// -------- IEEE 802.15.4 Packet

	components Ieee154PacketLayerC;
	Ieee154PacketLayerC.SubPacket -> LowPowerListeningLayerC;

// -------- UniqueLayer Send part (wired twice)

	components UniqueLayerC;
	UniqueLayerC.Config -> Cc2420XRadioP;
	UniqueLayerC.SubSend -> LowPowerListeningLayerC;

// -------- Low Power Listening 

#ifdef LOW_POWER_LISTENING
	#warning "*** USING LOW POWER LISTENING LAYER"
	components LowPowerListeningLayerC;
	LowPowerListeningLayerC.Config -> Cc2420XRadioP;
#ifdef Cc2420X_HARDWARE_ACK
	LowPowerListeningLayerC.PacketAcknowledgements -> Cc2420XDriverLayerC;
#else
	LowPowerListeningLayerC.PacketAcknowledgements -> SoftwareAckLayerC;
#endif
#else	
	components LowPowerListeningDummyC as LowPowerListeningLayerC;
#endif
	LowPowerListeningLayerC.SubControl -> MessageBufferLayerC;
	LowPowerListeningLayerC.SubSend -> PacketLinkLayerC;
	LowPowerListeningLayerC.SubReceive -> MessageBufferLayerC;
	LowPowerListeningLayerC.SubPacket -> PacketLinkLayerC;
	SplitControl = LowPowerListeningLayerC;
	LowPowerListening = LowPowerListeningLayerC;

// -------- Packet Link

#ifdef PACKET_LINK
	components PacketLinkLayerC;
	PacketLink = PacketLinkLayerC;
#ifdef Cc2420X_HARDWARE_ACK
	PacketLinkLayerC.PacketAcknowledgements -> Cc2420XDriverLayerC;
#else
	PacketLinkLayerC.PacketAcknowledgements -> SoftwareAckLayerC;
#endif
#else
	components new DummyLayerC() as PacketLinkLayerC;
#endif
	PacketLinkLayerC.SubSend -> MessageBufferLayerC;
	PacketLinkLayerC.SubPacket -> TimeStampingLayerC;

// -------- MessageBuffer

	components MessageBufferLayerC;
	MessageBufferLayerC.RadioSend -> TrafficMonitorLayerC;
	MessageBufferLayerC.RadioReceive -> UniqueLayerC;
	MessageBufferLayerC.RadioState -> TrafficMonitorLayerC;
	RadioChannel = MessageBufferLayerC;

// -------- UniqueLayer receive part (wired twice)

	UniqueLayerC.SubReceive -> TrafficMonitorLayerC;

// -------- Traffic Monitor

#ifdef TRAFFIC_MONITOR
	components TrafficMonitorLayerC;
#else
	components new DummyLayerC() as TrafficMonitorLayerC;
#endif
	TrafficMonitorLayerC.Config -> Cc2420XRadioP;
	TrafficMonitorLayerC -> CollisionAvoidanceLayerC.RadioSend;
	TrafficMonitorLayerC -> CollisionAvoidanceLayerC.RadioReceive;
	TrafficMonitorLayerC -> Cc2420XDriverLayerC.RadioState;

// -------- CollisionAvoidance

#ifdef SLOTTED_MAC
	components SlottedCollisionLayerC as CollisionAvoidanceLayerC;
#else
	components RandomCollisionLayerC as CollisionAvoidanceLayerC;
#endif
	CollisionAvoidanceLayerC.Config -> Cc2420XRadioP;
#ifdef Cc2420X_HARDWARE_ACK
	CollisionAvoidanceLayerC.SubSend -> CsmaLayerC;
	CollisionAvoidanceLayerC.SubReceive -> Cc2420XDriverLayerC;
#else
	CollisionAvoidanceLayerC.SubSend -> SoftwareAckLayerC;
	CollisionAvoidanceLayerC.SubReceive -> SoftwareAckLayerC;
#endif

// -------- SoftwareAcknowledgement

#ifndef Cc2420X_HARDWARE_ACK
	components SoftwareAckLayerC;
	SoftwareAckLayerC.Config -> Cc2420XRadioP;
	SoftwareAckLayerC.SubSend -> CsmaLayerC;
	SoftwareAckLayerC.SubReceive -> Cc2420XDriverLayerC;
	PacketAcknowledgements = SoftwareAckLayerC;
#endif

// -------- Carrier Sense

	components new DummyLayerC() as CsmaLayerC;
	CsmaLayerC.Config -> Cc2420XRadioP;
	CsmaLayerC -> Cc2420XDriverLayerC.RadioSend;
	CsmaLayerC -> Cc2420XDriverLayerC.RadioCCA;

// -------- TimeStamping

	components TimeStampingLayerC;
	TimeStampingLayerC.LocalTimeRadio -> Cc2420XDriverLayerC;
	TimeStampingLayerC.SubPacket -> MetadataFlagsLayerC;
	PacketTimeStampRadio = TimeStampingLayerC;
	PacketTimeStampMilli = TimeStampingLayerC;

// -------- MetadataFlags

	components MetadataFlagsLayerC;
	MetadataFlagsLayerC.SubPacket -> Cc2420XDriverLayerC;

// -------- Cc2420X Driver

#ifdef Cc2420X_HARDWARE_ACK
	components Cc2420XDriverHwAckC as Cc2420XDriverLayerC;
	PacketAcknowledgements = Cc2420XDriverLayerC;
	Cc2420XDriverLayerC.Ieee154PacketLayer -> Ieee154PacketLayerC;
#else
	components Cc2420XDriverLayerC;
#endif
	Cc2420XDriverLayerC.Config -> Cc2420XRadioP;
	Cc2420XDriverLayerC.PacketTimeStamp -> TimeStampingLayerC;
	PacketTransmitPower = Cc2420XDriverLayerC.PacketTransmitPower;
	PacketLinkQuality = Cc2420XDriverLayerC.PacketLinkQuality;
	PacketRSSI = Cc2420XDriverLayerC.PacketRSSI;
	LocalTimeRadio = Cc2420XDriverLayerC;
}
