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
 *
 * @author Octav Chipara
 * @version $Revision$
 * @date $Date$
 */

#include "SenderDispatcher.h"

configuration SSTdmaSchedulerC {
	provides {
		interface Init;
		interface AsyncSend as Send;
		interface AsyncReceive as Receive;
		interface SplitControl;
		interface CcaControl[am_id_t amId];
		interface FrameConfiguration;
	}	
	uses {
		interface AsyncReceive as SubReceive;
		interface AsyncSend as SubSend;
		interface RadioPowerControl;
		interface AMPacket;
		interface Resend;
		interface PacketAcknowledgements;
		interface CcaControl as SubCcaControl[am_id_t];
		interface ChannelMonitor;
	}
}
implementation {
	components MainC;
	components SSTdmaSchedulerP;
	components TDMASlotSenderC;
	components GenericSlotterC;
	components LedsC;
	//components new CsmaSlotSenderC(16 + 24, 8);
	//components new CsmaSlotSenderC(64, 120, 8);
	components new CsmaSlotSenderC(32, 120, 8);
	components SenderDispatcherC;
	components BeaconSlotC;
	components new Alarm32khz32C();
	

	//provides
	Init = SSTdmaSchedulerP.Init;
	SplitControl = SSTdmaSchedulerP.SplitControl;
	Send = SSTdmaSchedulerP.Send;
	Receive = SSTdmaSchedulerP.Receive;
	FrameConfiguration = SSTdmaSchedulerP.Frame;

	//wire-in SchedulerP
	MainC.SoftwareInit -> SSTdmaSchedulerP;

	SSTdmaSchedulerP.GenericSlotter -> GenericSlotterC.AsyncStdControl;
	SSTdmaSchedulerP.Slotter -> GenericSlotterC.Slotter;
	SSTdmaSchedulerP.RadioPowerControl = RadioPowerControl;
	SSTdmaSchedulerP.FrameConfiguration -> GenericSlotterC.FrameConfiguration;
	SSTdmaSchedulerP.Resend = Resend;
	SSTdmaSchedulerP.PacketAcknowledgements = PacketAcknowledgements;
	SSTdmaSchedulerP.AMPacket = AMPacket;
	SSTdmaSchedulerP.Leds -> LedsC;
	SSTdmaSchedulerP.CcaControl = CcaControl;
	
	SenderDispatcherC.SubSend = SubSend;
	SenderDispatcherC.SubCcaControl = SubCcaControl;
	TDMASlotSenderC.SubSend -> SenderDispatcherC.Send[TDMA_SLOT];

	TDMASlotSenderC.SubCcaControl -> SenderDispatcherC.SlotsCcaControl[TDMA_SLOT]; 	
	TDMASlotSenderC.AMPacket = AMPacket;

	SSTdmaSchedulerP.SubSend_TDMA -> TDMASlotSenderC.Send;
	SSTdmaSchedulerP.SubSend_CSMA -> CsmaSlotSenderC.Send;
	SSTdmaSchedulerP.SubSend_Beacon -> BeaconSlotC.Send;
	BeaconSlotC.SubReceive = SubReceive;
	SSTdmaSchedulerP.SubReceive -> BeaconSlotC.Receive;
	SSTdmaSchedulerP.SlotterControl ->GenericSlotterC.SlotterControl;
	
	
	CsmaSlotSenderC.ChannelMonitor = ChannelMonitor;
	CsmaSlotSenderC.AMPacket = AMPacket;
	CsmaSlotSenderC.SubCcaControl -> SenderDispatcherC.SlotsCcaControl[CSMA_SLOT];
	CsmaSlotSenderC.SubSend -> SenderDispatcherC.Send[CSMA_SLOT];
	
	
	//BeaconSlotC.ChannelMonitor = ChannelMonitor;
	BeaconSlotC.AMPacket = AMPacket;
	//BeaconSlotC.Slotter -> GenericSlotterC.Slotter;
	BeaconSlotC.SubCcaControl -> SenderDispatcherC.SlotsCcaControl[BEACON_SLOT];
	BeaconSlotC.SubSend -> SenderDispatcherC.Send[BEACON_SLOT];
	BeaconSlotC.SlotterControl ->GenericSlotterC.SlotterControl;
	BeaconSlotC.SyncAlarm -> Alarm32khz32C;

	//SSTdmaSchedulerP.Pin -> HplMsp430GeneralIOC.Port26;
	//SSTdmaSchedulerP.Boot -> MainC;	
}
