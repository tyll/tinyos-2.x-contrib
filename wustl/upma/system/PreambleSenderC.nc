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
 * Assists with sending preambles, by repeatedly sending a packet for the
 * specified time interval.
 *
 * @author Greg Hackmann
 */
configuration PreambleSenderC
{
	provides interface AsyncSend as Send;
	provides interface PreambleSender;
	provides interface SplitControl;
	provides interface CcaControl[am_id_t amId];
	
	uses interface RadioPowerControl;
	uses interface AsyncSend as SubSend;
	uses interface Resend;
	uses interface Alarm<TMilli, uint16_t> as PreambleAlarm;
	uses interface CcaControl as SubCcaControl[am_id_t amId];
}
implementation
{
	components PreambleSenderP as Sender;
	components LedsC;
	components new StateC() as PreambleState, new StateC() as RadioState;
	components RandomC;
	
	Send = Sender;
	PreambleSender = Sender;
	SplitControl = Sender;
	CcaControl = Sender;
	
	Sender.RadioPowerControl = RadioPowerControl;
	Sender.SubSend = SubSend;
	Sender.Resend = Resend;
	Sender.PreambleAlarm = PreambleAlarm;
	Sender.PreambleState -> PreambleState;
	Sender.RadioState -> RadioState;
	Sender.Leds -> LedsC;
	Sender.SubCcaControl = SubCcaControl;
	Sender.Random -> RandomC;
}
