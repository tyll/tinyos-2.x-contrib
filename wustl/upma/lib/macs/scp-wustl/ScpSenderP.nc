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
 
#include "ScpConstants.h"

/**
 * Sends packets with prefixed preambles, according to the SCP
 * protocol.
 *
 * @author Greg Hackmann
 */
module ScpSenderP
{
	provides interface AsyncSend as Send;
	provides interface Scp;
	provides interface StdControl;
	provides interface CcaControl[am_id_t amId];
	
	uses interface AsyncSend as SubSend;
	uses interface Resend;
	uses interface PacketAcknowledgements;
	uses interface ChannelMonitor;

	uses interface PreambleSender;
	uses interface SplitControl as SenderControl;

	uses interface State as SendState;
	uses interface Alarm<TMilli, uint16_t> as SendAlarm;
	uses interface Alarm<TMilli, uint16_t> as AdaptiveAlarm;
	uses interface ChannelPoller;
	uses interface AMPacket;
	uses interface Random;
	uses interface CcaControl as SubCcaControl[am_id_t amId];
}
implementation
{
	message_t * msg_;
	uint8_t len_;
	
	uint8_t adaptiveSlotsLeft;
	bool waitFirstSlot = FALSE;

	message_t preamble;
	norace uint8_t preambleLen;
	
	norace uint16_t preambleBackoff;
	norace uint16_t packetBackoff;

	void sendPacket();
	task void sendPacketLater();
	
	task void doStop();
	
	async command void Scp.setWakeupInterval(uint16_t ms)
	{
		call SendAlarm.start(ms - TX_TIME_SCHED);
		call ChannelPoller.setWakeupInterval(ms);
		// Intercept the command and reset the send alarm, offset by the
		// appropriate interval
	}
	
	async command uint16_t Scp.getWakeupInterval()
	{
		return call ChannelPoller.getWakeupInterval();
	}
	
	async command error_t Send.send(message_t * msg, uint8_t len)
	{
		atomic
		{
			uint8_t state = call SendState.getState();
			
			if(state == S_STOPPED)
				return EOFF;
			if(state == S_BOOTING)
				return ERETRY;
			// Make sure the radio isn't off, and that we're not busy
			// bootstrapping SCP
			if(state != S_IDLE)
				return FAIL;
			// Make sure that we're not busy
			
			call AMPacket.setType(&preamble, AM_PREAMBLEPACKET);
			call AMPacket.setSource(&preamble, TOS_NODE_ID);
			call AMPacket.setDestination(&preamble, call AMPacket.destination(msg));
			preambleLen = call AMPacket.headerSize();
			// Construct a preamble packet containing just the header

			msg_ = msg;
			len_ = len;
			call SendState.forceState(S_BUFFERED);
			// Save the parameters and note that we have something to send
		}

		return SUCCESS;
	}
	
	task void doStart()
	{
		call SenderControl.start();
	}

	async event void SendAlarm.fired()
	{
		call SendAlarm.start(call Scp.getWakeupInterval());
		// Reset the alarm

		if(call SendState.getState() != S_BUFFERED)
			return;
		// If there's nothing buffered, we're done
		
		call AdaptiveAlarm.start(HI_RATE_POLL_PERIOD + MAX_UCAST_TIME);
		if(waitFirstSlot)
		{
			waitFirstSlot = FALSE;
			atomic adaptiveSlotsLeft = SCP_NUM_HI_RATE_POLL;
			return;
		}
		atomic adaptiveSlotsLeft = 0;
		// Start the adaptive send timer and reset the number of adaptive slots
		
		call SendState.forceState(S_STARTING);			
		post doStart();
		// Start the radio
	}
	
	async event void AdaptiveAlarm.fired()
	{
		atomic
		{
			if(adaptiveSlotsLeft == 0)
				return;
			adaptiveSlotsLeft--;
		}
		// Mark another slot as used, and make sure we've got slots left
		
		call AdaptiveAlarm.start(HI_RATE_POLL_PERIOD);
		// Restart the timer
		if(call SendState.getState() != S_BUFFERED)
			return;
		// Make sure we've got a packet buffered and the radio is idle
		
		// If there's not enough time left to send the next packet
		if((call SendAlarm.getAlarm() - call SendAlarm.getNow()) < MAX_UCAST_TIME)
		{
			call AdaptiveAlarm.stop();
			waitFirstSlot = TRUE;
			return;
			// Stop the adaptive slots, and wait until the first adaptive slot
			// in the next frame
		}

		call SendState.forceState(S_STARTING);
		post doStart();
		// Start the radio
	}
	
	event void SenderControl.startDone(error_t err)
	{
		uint16_t preambleTime;
		preambleBackoff = (call Random.rand16() % SCP_TONE_CONT_WIN) + 1;
		preambleTime = SCP_TONE_CONT_WIN + MIN_TONE_LEN / 1000 + 1 - preambleBackoff / 8;
		// Calculate the preamble length

		if(call SendState.getState() != S_STARTING)
			return;
		// Make sure we're supposed to be sending the preamble
		
		call SendState.forceState(S_PREAMBLE);
		call PreambleSender.sendPreamble(&preamble, preambleLen,
			preambleTime, FALSE);
		// Send the preamble with an initial CCA check
	}
	
	async event resend_result_t PreambleSender.resendPreamble(message_t * msg)
	{
		return RESEND_WITHOUT_CCA;
	}
	
	async event void PreambleSender.preambleDone(message_t * msg, error_t err)
	{	
		if(err != SUCCESS)
		{
			message_t * payload;
			atomic payload = msg_;
			call SendState.toIdle();
			post doStop();
			signal Send.sendDone(payload, err);
			return;
		}
		// If it didn't work, then shut down the radio and signal failure

		packetBackoff = (call Random.rand16() % SCP_PKT_CONT_WIN) + 1;
		// Calculate a backoff between the preamble and payload
		call SendState.forceState(S_PACKET);
		sendPacket();
	}
	
	task void sendPacketLater()
	{
		sendPacket();
	}

	void sendPacket()
	{
		message_t * msg;
		uint16_t len;
		
		if(call SendState.getState() != S_PACKET)
			return;
		// Make sure we're supposed to be sending the payload

		atomic
		{
			msg = msg_;
			len = len_;
		}
		// Grab the parameters
		
		if(call SubSend.send(msg, len) != SUCCESS)
	 		post sendPacketLater();
	 	// Try sending, and post a task to do it later if we fail
	}
	
	task void doStop()
	{
		call SenderControl.stop();
	}
	
	async event void SubSend.sendDone(message_t * msg, error_t error)
	{
		// Make sure this event is for us
		if(call SendState.getState() == S_PACKET)
		{
			atomic adaptiveSlotsLeft = SCP_NUM_HI_RATE_POLL;

			call SendState.toIdle();
			post doStop();
			signal Send.sendDone(msg, error);
			// Stop the radio, and signal success
		}
	}
	
	event void SenderControl.stopDone(error_t err)
	{
		if(call SendState.getState() != S_IDLE)
			call SenderControl.start();
		// Start the radio back up if we've come busy in the meantime
	}
	
	async command error_t Send.cancel(message_t * msg)
	{
		if(msg != msg_ ||
		   call SendState.getState() != S_BUFFERED)
			return FAIL;
		// Make sure they're trying to cancel the buffered message, and that
		// we haven't actually tried to send it yet
		
		call SendState.toIdle();
		return SUCCESS;
//		return call SenderControl.stop();
		// Move to the idle state, so we won't send the packet after all
	}
	
	async command uint8_t Send.maxPayloadLength()
	{
		return call SubSend.maxPayloadLength();
	}
	
	async command void * Send.getPayload(message_t * msg, uint8_t len)
	{
		return call SubSend.getPayload(msg, len);
	}
	
	command error_t StdControl.start()
	{
//		if(call SendState.getState() != S_STOPPED)
//			return FAIL;
		// Make sure that the radio is off

		call ChannelMonitor.setCheckLength((MAX_TONE_TIME + TX_TIME_SCHED) * 32);
		call SendState.forceState(S_BOOTING);
		return SUCCESS;
		// Move to the bootstrap phase
	}
	
	command error_t StdControl.stop()
	{
		if(call SendState.getState() != S_BOOTING &&
		   call SendState.getState() != S_IDLE)
			return FAIL;
		// Make sure that we're not busy
			
		call SendState.forceState(S_STOPPED);
		return SUCCESS;
		// Move to the off state
	}
	
	async event void ChannelPoller.activityDetected(bool detected) { }
	async event void ChannelMonitor.error() { }
	async event void ChannelMonitor.busy() { }
	async event void ChannelMonitor.free() { }
	
	async event uint16_t SubCcaControl.getInitialBackoff[am_id_t amId](message_t *
		msg, uint16_t defaultBackoff)
	{
		switch(call SendState.getState())
		{
		case S_PREAMBLE:
			return preambleBackoff * 32 / 8;
		case S_PACKET:
			return packetBackoff * 32 / 8;
		// Backoffs are calculated in 8 KHz ticks, so convert to 32 KHz ticks
		default:
			return signal CcaControl.getInitialBackoff[amId](msg, defaultBackoff);
		}
	}
	
	default async event uint16_t CcaControl.getInitialBackoff[am_id_t amId](message_t *
		msg, uint16_t defaultBackoff)
	{
		return defaultBackoff;
	}

	async event uint16_t SubCcaControl.getCongestionBackoff[am_id_t amId](message_t *
		msg, uint16_t defaultBackoff)
	{
		return signal CcaControl.getCongestionBackoff[amId](msg, defaultBackoff);
	}
	
	default async event uint16_t CcaControl.getCongestionBackoff[am_id_t amId](message_t *
		msg, uint16_t defaultBackoff)
	{
		return defaultBackoff;
	}
	
	async event bool SubCcaControl.getCca[am_id_t amId](message_t * msg, bool
		defaultCca)
	{
		return signal CcaControl.getCca[amId](msg, defaultCca);
	}

	default async event bool CcaControl.getCca[am_id_t amId](message_t * msg,
		bool defaultCca)
	{
		return defaultCca;
	}
}
