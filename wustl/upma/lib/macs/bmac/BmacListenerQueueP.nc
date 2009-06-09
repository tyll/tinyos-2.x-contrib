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
module BmacListenerQueueP
{
	provides interface AsyncReceive as Receive;
	
	uses interface FixedSleepLplListener;
	uses interface AsyncReceive as SubReceive;
	uses interface RadioPowerControl;
	uses interface State as SendState;
	uses interface Packet;
	uses interface AMPacket;
	uses interface ChannelMonitor;
}
implementation
{
	enum
	{
		MAX_INVALID_MESSAGES = 3,
	};
	
	bool msgQueued;
	message_t queuedMsg;
	void * ONE_NOK queuedPayload;
	uint8_t queuedLength;
	uint16_t invalidMessages = 0;
	
	command void Receive.updateBuffer(message_t * msg)
	{
		if(msg != &queuedMsg)
			call SubReceive.updateBuffer(msg);
	}
	
	void passUpPacket()
	{
		void * payload;
		uint8_t length;
		bool queued;

		atomic queued = msgQueued;
		if(queued)
		{
			atomic
			{
				payload = queuedPayload;
				length = queuedLength;
			}
			signal Receive.receive(&queuedMsg, payload, length);
			atomic msgQueued = FALSE;
		}
    }

	task void detectReceiveDone()
	{
		call FixedSleepLplListener.startTimeout();
		if(call SendState.isIdle())
			call ChannelMonitor.check();
		else passUpPacket();
	}
  
	async event void ChannelMonitor.free()
	{
		passUpPacket();
	}
	
	async event void ChannelMonitor.busy()
	{
		post detectReceiveDone();
	}
  
	async event void ChannelMonitor.error()
	{
		post detectReceiveDone();
	}
	
	message_t * ONE_NOK msg_;
	
	task void updateBuffer()
	{
		message_t * msg;
		atomic msg = msg_;
		call Receive.updateBuffer(msg);
	}

	async event void SubReceive.receive(message_t * msg, void * payload, uint8_t len)
	{
		atomic msg_ = msg;

		if(!call AMPacket.isForMe(msg))
		{
			if((++invalidMessages) > MAX_INVALID_MESSAGES)
			{
				call FixedSleepLplListener.cancelTimeout();
#ifndef FORCE_RADIO_ON
				call RadioPowerControl.stop();
#endif
				post updateBuffer();
				return;
			}
		}
		// Stop the radio if we overheard someone else's message

		invalidMessages = 0;
		call FixedSleepLplListener.startTimeout();
		atomic
		{
			if(!msgQueued)
			{
				memcpy(&queuedMsg, msg, sizeof(message_t));
				queuedPayload = payload;
				queuedLength = len;
				msgQueued = TRUE;
			}
		}

		post updateBuffer();
		post detectReceiveDone();
	}
	
	event void RadioPowerControl.startDone(error_t err) { }
	event void RadioPowerControl.stopDone(error_t err) { }
}
