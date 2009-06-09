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
 * Automatically adjusts the radio power based on periodic LPL checks.
 *
 * @author Greg Hackmann
 */
module PeriodicLplListenerP
{
	provides interface AsyncReceive as Receive;
	
	uses interface ChannelPoller;
	uses interface RadioPowerControl;
	uses interface AsyncReceive as SubReceive;
	uses interface State as SendState;
	uses interface AMPacket;
}
implementation
{
	async event void ChannelPoller.activityDetected(bool detected)
	{
#ifndef FORCE_RADIO_ON
		if(!(call SendState.isIdle()))
			return;
		// Don't do anything if the radio is being used
		
		if(!detected)
			call RadioPowerControl.stop();
		// Stop the radio if the channel is free
#endif
	}
	
	event void RadioPowerControl.startDone(error_t error) { }
	event void RadioPowerControl.stopDone(error_t error) { }
	
	command void Receive.updateBuffer(message_t * msg)
	{
		call SubReceive.updateBuffer(msg);
	}

	async event void SubReceive.receive(message_t * msg, void * payload, uint8_t len)
	{
		signal Receive.receive(msg, payload, len);
	}	
}
