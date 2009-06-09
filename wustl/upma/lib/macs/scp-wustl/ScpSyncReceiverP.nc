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
 * Handles SCP time synchronization information in incoming packets.
 *
 * @author Greg Hackmann
 */
module ScpSyncReceiverP
{
	provides interface AsyncReceive as Receive;
	provides interface Packet;
	
	uses interface ScpSyncSender;
	uses interface State as SendState;
	uses interface AsyncReceive as SubReceive;
	uses interface Alarm<TMilli, uint16_t> as LplAlarm;
	uses interface Alarm<TMilli, uint16_t> as SendAlarm;
	uses interface AMPacket;
	uses interface Packet as SubPacket;
	uses interface AsyncStdControl as ScpBoot;
}
implementation
{
	norace message_t * msg_;
	
	task void updateBufferTask()
	{
		call SubReceive.updateBuffer(msg_);
	}
	
	task void sendSyncTask()
	{
		call ScpSyncSender.sendSyncPacket();
		call SubReceive.updateBuffer(msg_);
	}
	
	async event void SubReceive.receive(message_t * msg, void * payload, uint8_t len)
	{
		int16_t diff;
		uint8_t offset;
		ScpSyncMsg * sync;
		
		msg_ = msg;
		if(call AMPacket.type(msg) == AM_PREAMBLEPACKET)
		{
			post updateBufferTask();
			return;
		}
		if(call AMPacket.type(msg) == AM_SCPBOOTMSG)
		{
			post sendSyncTask();
			return;
		}
		// Throw away preamble packets
		
		offset = len - call AMPacket.headerSize() - sizeof(ScpSyncMsg);
		// Figure out where the payload ends, then back up to the start of the
		// footer

		sync = (ScpSyncMsg *)(payload + offset);
		// Point to the ScpSyncMsg footer
		diff = (int16_t)(call LplAlarm.getAlarm() - call LplAlarm.getNow() - sync->time);
		// Figure out how far off our alarm is from theirs
		
		// If there's a difference, and their alarm has some time left on it
		if(diff != 0 && sync->time > 0)
		{
			call LplAlarm.stop();
			call LplAlarm.start(sync->time);
			// Restart our LPL alarm to match theirs
			
			// If there's enough time left on the LPL alarm to do another send
			if(sync->time > TX_TIME_SCHED)
			{
				call SendAlarm.stop();
				call SendAlarm.start(sync->time - TX_TIME_SCHED);
				// Restart the send alarm
			}
			
			call ScpBoot.stop();
			if(call SendState.getState() == S_BOOTING)
				call SendState.toIdle();
			// Move out of the bootstrapping phase
		}
		
		if(call AMPacket.type(msg) == AM_SCPSYNCMSG)
			post updateBufferTask();
		else
			signal Receive.receive(msg, payload, len - sizeof(ScpSyncMsg));
		// For all non-sync messages, push the event (minus the footer) up to
		// the upper layer
	}
		
	command void Receive.updateBuffer(message_t * msg)
	{
		call SubReceive.updateBuffer(msg);
	}
	
	command void * Packet.getPayload(message_t * msg, uint8_t len)
	{
		return call Packet.getPayload(msg, len);
	}

	command void Packet.clear(message_t * msg)
	{
		call SubPacket.clear(msg);
	}

	command uint8_t Packet.payloadLength(message_t * msg)
	{
		if(call AMPacket.type(msg) == AM_PREAMBLEPACKET)
			return call SubPacket.payloadLength(msg);
		
		return call SubPacket.payloadLength(msg) - sizeof(ScpSyncMsg);
	}

	command void Packet.setPayloadLength(message_t * msg, uint8_t len)
	{
		if(call AMPacket.type(msg) == AM_PREAMBLEPACKET)
			call SubPacket.setPayloadLength(msg, len);
		else
			call SubPacket.setPayloadLength(msg, len + sizeof(ScpSyncMsg));
	}
	
	command uint8_t Packet.maxPayloadLength()
	{
		return call SubPacket.maxPayloadLength() - sizeof(ScpSyncMsg);
	}
	
	async event void LplAlarm.fired()
	{
	}
	
	async event void SendAlarm.fired()
	{
	}
}
