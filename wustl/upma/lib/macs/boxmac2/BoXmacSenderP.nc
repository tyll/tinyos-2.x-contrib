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
 * Sends packets with prefixed preambles, according to the X-MAC
 * protocol.
 *
 * @author Greg Hackmann
 */
module BoXmacSenderP
{
	provides interface AsyncSend as Send;
	provides interface StdControl;
	
	uses interface AsyncSend as SubSend;
	uses interface State as SendState;
	uses interface PreambleSender;
	uses interface SplitControl as SenderControl;
	uses interface FixedSleepLplListener;
	
	uses interface PacketAcknowledgements;

	uses interface LowPowerListening;
	uses interface SystemLowPowerListening;
	uses interface Leds;
	uses interface AMPacket;
}
implementation
{
	enum
	{
		S_IDLE = 0,
		S_PREAMBLE = 1,
		S_NO_PREAMBLE = 2,
		S_STOPPED = 3,
	};

	message_t * msg_;
	uint8_t len_;

	task void doStart()
	{
		call SenderControl.start();
	}
	
	async command error_t Send.send(message_t * msg, uint8_t len)
	{
		if(call SendState.getState() == S_STOPPED)
			return EOFF;
		// Make sure that the radio isn't off
		
		// Try to move to the preamble state			
		if(call SendState.requestState(S_PREAMBLE) == SUCCESS)
		{
			call FixedSleepLplListener.cancelTimeout();
			atomic
			{
				msg_ = msg;
				len_ = len;
			}
			
			post doStart();
			return SUCCESS;
			// Save the parameters and start the radio
		}
		
		return FAIL;
	}
	
	event void SenderControl.startDone(error_t err)
	{
		uint16_t ms;
		message_t * msg;
		uint8_t len;
		
		atomic
		{
			msg = msg_;
			len = len_;
		}
		// Get the parameters
		
		if(err != SUCCESS)
		{
			call SendState.toIdle();
			signal Send.sendDone(msg, err);
			return;
		}
		// If we couldn't turn on the radio, give up
	
		ms = call LowPowerListening.getRemoteWakeupInterval(msg);
		if(ms == 0)
			ms = call SystemLowPowerListening.getDefaultRemoteWakeupInterval();

		if(ms == 0)
		{
			call SendState.forceState(S_NO_PREAMBLE);
			err = call SubSend.send(msg, len);
			if(err != SUCCESS)
			{
				call SendState.toIdle();
				signal Send.sendDone(msg, err);
			}
			// If no preamble, then bypass the PreambleSender and
			// just send the message once
		}
		else
		{
			call PacketAcknowledgements.requestAck(msg);
			// Turn on ACKing for the packet
			call PreambleSender.sendPreamble(msg, len, ms + 20, TRUE);
			// Send the preamble for the sleep time, plus a 20 ms guard time
		}
	}

	async command error_t Send.cancel(message_t *msg)
	{
		return FAIL;
	}
	
	async command uint8_t Send.maxPayloadLength()
	{
		return call SubSend.maxPayloadLength();
	}

	async command void * Send.getPayload(message_t * msg, uint8_t len)
	{
		return call SubSend.getPayload(msg, len);
	}
	
	async event void SubSend.sendDone(message_t * msg, error_t err)
	{
		// Only do something if we're using the PreambleSender
		if(call SendState.getState() == S_NO_PREAMBLE)
		{
			call SendState.toIdle();
			call FixedSleepLplListener.startTimeout();
			signal Send.sendDone(msg, err);
		}
	}
	
	async event resend_result_t PreambleSender.resendPreamble(message_t * msg)
	{
		return call PacketAcknowledgements.wasAcked(msg) ? DO_NOT_RESEND :
			RESEND_WITH_CCA;
		// Stop the preamble if the message was ACKed, or resend with CCA
		// otherwise
	}
	
	async event void PreambleSender.preambleDone(message_t * msg, error_t err)
	{
		call SendState.toIdle();
		call FixedSleepLplListener.startTimeout();
		signal Send.sendDone(msg, err);
		// Move to the idle state, then tell the upper layer we're done
	}
	
	event void SenderControl.stopDone(error_t err)
	{
		if(call SendState.getState() != S_IDLE)
			call SenderControl.start();
		// If we need the radio to stay on, start it back up
	}
	
	command error_t StdControl.start()
	{
		if(call SendState.getState() != S_STOPPED)
			return FAIL;
		// If the radio's busy, give up
			
		call SendState.forceState(S_IDLE);
		return SUCCESS;
		// Move to the idle state
	}
	
	command error_t StdControl.stop()
	{
		if(call SendState.getState() != S_IDLE)
			return FAIL;
		// If the radio's busy, give up
			
		call SendState.forceState(S_STOPPED);
		return SUCCESS;
		// Move to the stopped state
	}
}
