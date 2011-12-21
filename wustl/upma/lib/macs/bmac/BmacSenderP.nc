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
 * Sends packets with prefixed preambles, according to the B-MAC
 * protocol.
 *
 * @author Greg Hackmann
 */
module BmacSenderP
{
	provides interface AsyncSend as Send;
	provides interface StdControl;
	provides interface CcaControl[am_id_t amId];

	uses interface AsyncSend as SubSend;
	uses interface State as SendState;
	uses interface PreambleSender;
	uses interface SplitControl as SenderControl;
	uses interface FixedSleepLplListener;
	
	uses interface PacketAcknowledgements;

	uses interface LowPowerListening;
	uses interface SystemLowPowerListening;
	uses interface Leds;
	uses interface CcaControl as SubCcaControl[am_id_t amId];
}
implementation
{
	enum
	{
		S_IDLE = 0,
		S_PREAMBLE = 1,
		S_PAYLOAD = 2,
		S_STOPPED = 3,
	};

	message_t * ONE_NOK msg_;
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
	
		call PacketAcknowledgements.noAck(msg);
		// Turn off ACKing for the packet
		call PreambleSender.sendPreamble(msg, len, ms + 20, TRUE);
		// Send the preamble for the sleep time, plus a 20 ms guard time
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
	
	async event void SubSend.sendDone(message_t * msg, error_t error)
	{
		call SendState.toIdle();
		call FixedSleepLplListener.startTimeout();
		signal Send.sendDone(msg, error);
		// Move to the idle state, then tell the upper layer we're done
	}
	
	async event resend_result_t PreambleSender.resendPreamble(message_t * msg)
	{
		return RESEND_WITHOUT_CCA;
	}
	
	async event void PreambleSender.preambleDone(message_t * msg, error_t err)
	{
		uint8_t len;
		if(err != SUCCESS)
		{
			call SendState.toIdle();
			signal Send.sendDone(msg, err);
			return;
		}
		// If something went wrong, then tell the upper layer
		
		atomic len = len_;
		call SendState.forceState(S_PAYLOAD);
		call PacketAcknowledgements.requestAck(msg);
		call SubSend.send(msg, len);
		// Send the packet again, but with an ACK
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
	
	async event uint16_t SubCcaControl.getInitialBackoff[am_id_t amId](message_t *
		msg, uint16_t defaultBackoff)
	{
		if(call SendState.getState() == S_PREAMBLE)
			return 0;
		else
			return signal CcaControl.getInitialBackoff[amId](msg, defaultBackoff);
	}
	
	default async event uint16_t CcaControl.getInitialBackoff[am_id_t amId](message_t *
		msg, uint16_t defaultBackoff)
	{
		return defaultBackoff;
	}

	async event uint16_t SubCcaControl.getCongestionBackoff[am_id_t amId](message_t *
		msg, uint16_t defaultBackoff)
	{
		if(call SendState.getState() == S_PREAMBLE)
			return 0;
		else
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
