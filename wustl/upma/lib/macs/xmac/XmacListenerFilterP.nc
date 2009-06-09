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
 * Filters incoming packets, and turns off the radio if another node's packets
 * are overheard.
 *
 * @author Greg Hackmann
 */
module XmacListenerFilterP
{
	provides interface AsyncReceive as Receive;
	
	uses interface ChannelMonitor;
	uses interface FixedSleepLplListener;
	uses interface AsyncReceive as SubReceive;
	uses interface RadioPowerControl;
	uses interface State as SendState;
	uses interface AMPacket;
}
implementation
{
	enum
	{
		MAX_INVALID_MESSAGES = 3,
	};
	
	uint16_t invalidMessages = 0;
		
	command void Receive.updateBuffer(message_t * msg)
	{
		call SubReceive.updateBuffer(msg);
	}

	async event void SubReceive.receive(message_t * msg, void * payload, uint8_t len)
	{
		if(!call AMPacket.isForMe(msg) &&
		   (++invalidMessages) > MAX_INVALID_MESSAGES)
		{
			call FixedSleepLplListener.cancelTimeout();
#ifndef FORCE_RADIO_ON
			call RadioPowerControl.stop();
#endif
		}
		// Stop the radio if we overheard someone else's message
		else
		{
			call FixedSleepLplListener.startTimeout();
			signal Receive.receive(msg, payload, len);
		}
		// Otherwise pass the event along
	}
	
	event void RadioPowerControl.startDone(error_t err) { }
	event void RadioPowerControl.stopDone(error_t err) { }
	
	async event void ChannelMonitor.free() { }
	async event void ChannelMonitor.busy() { }
	async event void ChannelMonitor.error() { invalidMessages = 0; }
}
