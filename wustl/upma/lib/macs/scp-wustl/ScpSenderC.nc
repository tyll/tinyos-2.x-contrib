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
 * Sends packets with prefixed preambles, according to the SCP
 * protocol.
 *
 * @author Greg Hackmann
 */
configuration ScpSenderC
{
	provides interface AsyncSend as Send;
	provides interface Scp;
	provides interface StdControl;
	provides interface CcaControl[am_id_t amId];
	
	uses interface RadioPowerControl;
	uses interface AsyncSend as SubSend;
	uses interface Resend;
	uses interface State as SendState;
	uses interface PacketAcknowledgements;
	uses interface Alarm<TMilli, uint16_t> as SendAlarm;
	uses interface AMPacket;
	uses interface CcaControl as SubCcaControl[am_id_t amId];
	uses interface ChannelMonitor;
	uses interface ChannelPoller;
}
implementation
{
	components ScpSenderP;
	components PreambleSenderC as Sender;
	components RandomC;
	components new VirtualizedAlarmMilli16C() as PreambleAlarm;
	components new VirtualizedAlarmMilli16C() as AdaptiveAlarm;
	
	Send = ScpSenderP;
	Scp = ScpSenderP;
	StdControl = ScpSenderP;
	CcaControl = ScpSenderP;
	
	ScpSenderP.SubSend -> Sender;
	ScpSenderP.PacketAcknowledgements = PacketAcknowledgements;
	ScpSenderP.SendState = SendState;
	ScpSenderP.SendAlarm = SendAlarm;
	ScpSenderP.AdaptiveAlarm -> AdaptiveAlarm;
	ScpSenderP.AMPacket = AMPacket;
	ScpSenderP.Random -> RandomC;
	ScpSenderP.PreambleSender -> Sender;
	ScpSenderP.SenderControl -> Sender;
	ScpSenderP.ChannelMonitor = ChannelMonitor;
	ScpSenderP.ChannelPoller = ChannelPoller;
	ScpSenderP.SubCcaControl -> Sender;

	Sender.RadioPowerControl = RadioPowerControl;
	Sender.SubSend = SubSend;
	Sender.Resend = Resend;
	Sender.PreambleAlarm -> PreambleAlarm;
	Sender.SubCcaControl = SubCcaControl;
}
