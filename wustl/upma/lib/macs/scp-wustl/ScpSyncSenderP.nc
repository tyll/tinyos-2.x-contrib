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
 
#include "ScpSyncMsg.h"
#include "ScpConstants.h"

/**
 * Stamps outgoing packets with SCP time synchronization information.
 *
 * @author Greg Hackmann
 */
module ScpSyncSenderP
{
	provides interface AsyncSend as Send;
	provides interface Interval as SyncInterval;
	provides interface StdControl;
	provides interface ScpSyncSender;

	uses interface Alarm<TMilli, uint16_t> as LplAlarm;
	uses interface Alarm<TMilli, uint16_t> as SyncAlarm;
	uses interface AsyncSend as SubSend;
	uses interface Leds;
	uses interface AMPacket;
	uses interface AsyncStdControl as ScpBoot;
}
implementation
{  
	uint16_t ms_ = 0;
	message_t sync, boot;
	bool piggybacked = FALSE;
	bool running_ = FALSE;
	
	async command void SyncInterval.set(uint16_t ms)
	{
		atomic
		{
			ms_ = ms;
			piggybacked = FALSE;
		}
		// Save the new interval, and forget that we piggybacked anything
		
		if(running_)
			call SyncAlarm.start(ms);
		// Restart the alarm if we're running
	}
	
	async command uint16_t SyncInterval.get()
	{
		atomic return ms_;
	}

	void addSyncFooter(message_t * msg, uint8_t len)
	{
		ScpSyncMsg * syncMsg = (ScpSyncMsg *)(call SubSend.getPayload(msg, len + sizeof(ScpSyncMsg)) + len);
		// Point to the sync message at the end of the payload
		uint16_t timeLeft = call LplAlarm.getAlarm(), now = call LplAlarm.getNow();
		// Get the alarm's contents
		syncMsg->time =  (timeLeft > now) ? timeLeft - now : 0;
		// If there's at least 1 ms left on the alarm, put that into the footer;
		// otherwise, just use 0 to flag the sync message as invalid
	}
	
	async command error_t Send.send(message_t * msg, uint8_t len)
	{
		if(call AMPacket.type(msg) == AM_PREAMBLEPACKET)
			return call SubSend.send(msg, len);
		// Pass preamble packets straight through
		
		atomic piggybacked = TRUE;
		// Record that we've piggypacked a sync message
		addSyncFooter(msg, len - call AMPacket.headerSize());
		return call SubSend.send(msg, len + sizeof(ScpSyncMsg));
		// Apply the sync footer and send the message
	}

	async command void * Send.getPayload(message_t * msg, uint8_t len)
	{
		return call SubSend.getPayload(msg, len);
	}
	
	async command error_t Send.cancel(message_t * msg)
	{
		return call SubSend.cancel(msg);
	}

	async command uint8_t Send.maxPayloadLength()
	{
		return call SubSend.maxPayloadLength() - sizeof(ScpSyncMsg);
	}
	
	async command void ScpSyncSender.sendSyncPacket()
	{
		call AMPacket.setType(&sync, AM_SCPSYNCMSG);
		call AMPacket.setSource(&sync, TOS_NODE_ID);
		call AMPacket.setDestination(&sync, AM_BROADCAST_ADDR);
		call Send.send(&sync, call AMPacket.headerSize());
		// Create an explicit sync message with no payload, and pass
		// it through our normal sending routines
	}
	
	async event void SyncAlarm.fired()
	{
		call SyncAlarm.start(ms_);
		// Restart the sync alarm
		
		// If we haven't piggybacked a sync message in the last interval
		if(!piggybacked)
			call ScpSyncSender.sendSyncPacket();

		atomic piggybacked = FALSE;
		// Reset the piggyback flag
	}

	async event void LplAlarm.fired() { }

	async event void SubSend.sendDone(message_t * msg, error_t err)
	{
		if(msg != &sync)
			signal Send.sendDone(msg, err);
		// If the event isn't referring to our explicit sync message, then
		// pass the event along
	}	
	
	command error_t StdControl.start()
	{
		atomic
		{
			running_ = TRUE;			
			if(ms_ > 0)
				call SyncAlarm.start(ms_);
			// Note that we're running, and restart the alarm if possible
		}
		
		call ScpBoot.start();
		return SUCCESS;
	}

	command error_t StdControl.stop()
	{
		call SyncAlarm.stop();
		call ScpBoot.stop();
		atomic running_ = FALSE;
		// Stop the alarm and note that we're not running
		return SUCCESS;
	}
}
