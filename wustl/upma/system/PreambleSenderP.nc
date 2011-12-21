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
module PreambleSenderP @safe()
{
	provides interface AsyncSend as Send;
	provides interface PreambleSender;
	provides interface SplitControl;
	provides interface CcaControl[am_id_t amId];

	uses interface RadioPowerControl;
	uses interface AsyncSend as SubSend;
	uses interface Resend;
	uses interface Alarm<TMilli, uint16_t> as PreambleAlarm;
	uses interface State as PreambleState;
	uses interface State as RadioState;
	uses interface Leds;
	uses interface CcaControl as SubCcaControl[am_id_t amId];
	uses interface Random;
}
implementation
{	
	enum
	{
		S_OFF = 0,
		S_ON = 1
	};
	
	enum
	{
		S_IDLE = 0,
		S_STARTING = 1,
		S_LPL_FIRST_MESSAGE = 2,
		S_LPL_SENDING = 3,
		S_LPL_LAST_MESSAGE = 4,
		S_LPL_CLEAN_UP = 5,
		S_STOPPING = 6
	};
	
	message_t * ONE_NOK msg_;
	uint8_t len_;
	uint16_t ms_;
	norace bool useCca_;
	
	void send();
	void resend();
	void startRadio();
	void stopRadio();
	
	async event uint16_t SubCcaControl.getInitialBackoff[am_id_t amId](message_t *
		msg, uint16_t defaultBackoff)
	{
		if(call PreambleState.getState() == S_LPL_SENDING)
			defaultBackoff = call Random.rand16() % 10;
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
		if(call PreambleState.getState() == S_LPL_SENDING)
			defaultBackoff = call Random.rand16() % 10;
		return signal CcaControl.getCongestionBackoff[amId](msg, defaultBackoff);
	}
	
	default async event uint16_t CcaControl.getCongestionBackoff[am_id_t amId](message_t *
		msg, uint16_t defaultBackoff)
	{
		return defaultBackoff;
	}
	
	default async event bool CcaControl.getCca[am_id_t amId](message_t * msg,
		bool defaultCca)
	{
		return defaultCca;
	}

	async event bool SubCcaControl.getCca[am_id_t amId](message_t * msg, bool
		defaultCca)
	{
		if(call PreambleState.isIdle())
			return signal CcaControl.getCca[amId](msg, defaultCca);
		else
			return useCca_;
		// If we're busy sending the preamble, then leave the CCA decision to
		// our discretion; otherwise, pass it through
	}	
	
	async command error_t PreambleSender.sendPreamble(message_t * msg,
		uint8_t len, uint16_t ms, bool useCca)
	{
		if(call PreambleState.requestState(S_LPL_FIRST_MESSAGE) != SUCCESS)
			return FAIL;
		// Try to move into the appropriate state
		
		atomic
		{
			msg_ = msg;
			len_ = len;
			ms_ = ms;
			useCca_ = useCca;
		}
		// Save the parameters
		
		send();
		return SUCCESS;
		// Send the first preamble
	}
	
	async command error_t Send.send(message_t * msg, uint8_t len)
	{
		return call SubSend.send(msg, len);
	}
	
	async command error_t Send.cancel(message_t * msg)
	{
		return call SubSend.cancel(msg);
	}
	
	async command uint8_t Send.maxPayloadLength()
	{
		return call SubSend.maxPayloadLength();
	}
	
	async command void * Send.getPayload(message_t * msg, uint8_t len)
	{
		return call SubSend.getPayload(msg, len);
	}
	
	void signalPreambleDone(message_t * ONE msg, error_t err)
	{
//		atomic
//		{
			call PreambleState.toIdle();
			call PreambleAlarm.stop();
//		}
		signal PreambleSender.preambleDone(msg, err);
	}

	async event void SubSend.sendDone(message_t * msg, error_t err)
	{
		uint8_t state;
		uint16_t ms;
		bool running;
		
		state = call PreambleState.getState();
		atomic ms = ms_;
		
		switch(state)
		{
		case S_LPL_FIRST_MESSAGE:
			call PreambleAlarm.start(ms);
			call PreambleState.forceState(S_LPL_SENDING);
			// Start the alarm and note that we're sending the rest of the
			// preambles.  Then fall through to the regular preamble-sending
			// case.
		case S_LPL_SENDING:
			// If we're still supposed to send preambles
			atomic running = call PreambleAlarm.isRunning();
			if(running)
			{
				resend_result_t result = signal PreambleSender.resendPreamble(msg);
				if(result == DO_NOT_RESEND)
				{
					signalPreambleDone(msg, err);
					return;
				}
				// See if we should resend the preamble
				
				useCca_ = (result == RESEND_WITH_CCA);
				resend();
				return;
				// Resend it with the appropriate CCA flag
			}
			signalPreambleDone(msg, err);
			return;
			// Otherwise, signal that the preamble's done
			
		case S_LPL_CLEAN_UP:
			signalPreambleDone(msg, err);
			return;
			// Signal that the preamble's done
			
		default:
			signal Send.sendDone(msg, err);
			return;
			// We're not doing anything with preambles, so just pass the
			// signal along
		}
	}

	async event void PreambleAlarm.fired()
	{
//		atomic
//		{
			if(call PreambleState.getState() == S_LPL_SENDING)
			{	
				call PreambleState.forceState(S_LPL_CLEAN_UP);
//				if(signal PreambleSender.resendPreamble(msg_))
//					send();
			}
//		}
	}
	
	task void sendLater()
	{
		send();
	}
 
 	void send()
 	{
 		message_t * msg;
 		uint8_t len;
 		
 		atomic
 		{
 			msg = msg_;
 			len = len_;
 		}
 		// Get the parameters
 		
 		if(call SubSend.send(msg, len) != SUCCESS)
 			post sendLater();
 		// Try to send; post a task to do it later if we fail
	}
 	
	task void resendLater()
 	{
 		resend();
 	}
 	
 	void resend()
 	{
 		if(call Resend.resend() != SUCCESS)
 			post resendLater();
 		// Try to resend; post a task to do it later if we fail
 	}
 	
 	command error_t SplitControl.start()
 	{
 		if(call RadioState.getState() == S_ON)
 		{
 			signal SplitControl.startDone(SUCCESS);
 			return SUCCESS;
 		}
 		// If the radio's already on, do nothing
 		
 		if(call PreambleState.requestState(S_STARTING) != SUCCESS)
 			return FAIL;
 		// Try to move to the starting state 

 		startRadio();
 		return SUCCESS;
 		// Actually start the radio
 	}
 	
 	command error_t SplitControl.stop()
 	{
 		if(call RadioState.getState() == S_OFF)
 		{
 			signal SplitControl.stopDone(SUCCESS);
			return SUCCESS;
		}
 		// If the radio's already off, do nothing
 		
 		if(call PreambleState.requestState(S_STOPPING) != SUCCESS)
 			return FAIL;
 		// Try to move to the stopping state 

 		stopRadio();
 		return SUCCESS;
 		// Actually stop the radio
 	}

 	event void RadioPowerControl.startDone(error_t error)
	{
		if(!error)
			call RadioState.forceState(S_ON);
		// If it succeeded, note that the radio is on
		
		if(call PreambleState.getState() == S_STARTING)
		{
			call PreambleState.toIdle();
			signal SplitControl.startDone(error);
		}
		// If we asked for the radio to turn on, then move to the idle state
		// and signal success
	}
		
	event void RadioPowerControl.stopDone(error_t error)
	{
		if(!error)
			call RadioState.forceState(S_OFF);
		// If it succeeded, note that the radio is off
		
		if(call PreambleState.getState() == S_STOPPING)
		{
			call PreambleState.toIdle();
			signal SplitControl.stopDone(error);
		}
		// If we asked for the radio to turn off, then move to the idle state
		// and signal success
	}
	
	task void startRadioLater()
	{
		startRadio();
	}
	
	void startRadio()
	{
		if(call RadioPowerControl.start() != SUCCESS)
			post startRadioLater();
	}
	
	task void stopRadioLater()
	{
		stopRadio();
	}
	
	void stopRadio()
	{
		if(call RadioPowerControl.stop() != SUCCESS)
			post stopRadioLater();
	}
}
