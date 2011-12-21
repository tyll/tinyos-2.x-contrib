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
 * @author Greg Hackmann
 * @version $Revision$
 * @date $Date$
 */
module ScpListenerFilterP
{
	provides interface ChannelPoller;
	provides interface AsyncReceive as Receive;
	
	uses interface ChannelPoller as SubChannelPoller;
	uses interface State as SendState;
	uses interface AsyncReceive as SubReceive;
	uses interface Leds;
}
implementation
{
	uint16_t packetCount = 0;
	
	async event void SubChannelPoller.activityDetected(bool detected)
	{
		uint16_t lastCount;
		atomic
		{
			lastCount = packetCount;
			packetCount = 0;
		}
		
		signal ChannelPoller.activityDetected(detected ||
			(lastCount > 0) ||
			(call SendState.getState() == S_BOOTING));
	}
	
	async command void ChannelPoller.setWakeupInterval(uint16_t ms)
	{
		call SubChannelPoller.setWakeupInterval(ms);
	}
	
	async command uint16_t ChannelPoller.getWakeupInterval()
	{
		return call SubChannelPoller.getWakeupInterval();
	}

	command void Receive.updateBuffer(message_t * msg)
	{
		call SubReceive.updateBuffer(msg);
	}

	async event void SubReceive.receive(message_t * msg, void * payload, uint8_t len)
	{
		atomic packetCount++;
		signal Receive.receive(msg, payload, len);
	}
}
