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
 * Provides the X-MAC MAC layer.
 *
 * @author Greg Hackmann
 */
configuration MacC
{
	provides interface AsyncReceive as Receive;
	provides interface AsyncSend as Send;
	provides interface SplitControl;
	provides interface CcaControl[am_id_t amId];
	
	uses interface RadioPowerControl;
	uses interface ChannelMonitor;
	uses interface AsyncReceive as SubReceive;
	uses interface AsyncSend as SubSend;
	uses interface Resend;
	uses interface PacketAcknowledgements;
	uses interface AMPacket;
	uses interface CcaControl as SubCcaControl[am_id_t amId];
}
implementation
{
	components MacControlC;
	components XmacSenderC as Sender;
	components XmacListenerC as Listener;
 	components XmacSplitControlC;
	components ChannelPollerC;
	components new StateC() as SendState;
	
	components new VirtualizedAlarmMilli16C() as PreambleAlarm;
	components new VirtualizedAlarmMilli16C() as LplAlarm;
	components new VirtualizedAlarmMilli16C() as TimeoutAlarm;

	Receive = Listener;
	Send = Sender;
	SplitControl = XmacSplitControlC;
	CcaControl = Sender;
	
	MacControlC.SubLpl -> ChannelPollerC;
	
	Sender.RadioPowerControl = RadioPowerControl;
	Sender.SubSend = SubSend;
	Sender.SubCcaControl = SubCcaControl;
	Sender.Resend = Resend;
	Sender.PacketAcknowledgements = PacketAcknowledgements;
	Sender.LowPowerListening -> ChannelPollerC;
	Sender.SendState -> SendState;
	Sender.AMPacket = AMPacket;
	Sender.PreambleAlarm -> PreambleAlarm;
	Sender.FixedSleepLplListener -> Listener;
	
	Listener.ChannelMonitor = ChannelMonitor;
	Listener.ChannelPoller -> ChannelPollerC;
	Listener.PollerControl -> ChannelPollerC;
	Listener.RadioPowerControl = RadioPowerControl;
	Listener.SubReceive = SubReceive;
	Listener.SendState -> SendState;
	Listener.AMPacket = AMPacket;
	Listener.TimeoutAlarm -> TimeoutAlarm;

	ChannelPollerC.ChannelMonitor = ChannelMonitor;
	ChannelPollerC.Alarm -> LplAlarm;
	
	XmacSplitControlC.RadioPowerControl = RadioPowerControl;
	XmacSplitControlC.SenderControl -> Sender;
	XmacSplitControlC.ChannelPollerControl -> ChannelPollerC;
}
