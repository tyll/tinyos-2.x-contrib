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
module ScpBootP
{
	provides interface AsyncSend as Send;
	provides interface AsyncStdControl;

	uses interface AsyncSend as SubSend;
	uses interface Resend;
	uses interface AMPacket;
	uses interface Alarm<TMilli, uint16_t> as BootAlarm;
	uses interface State as BootState;
	uses interface Scp;
}
implementation
{
	message_t boot;
	
	enum
	{
		S_IDLE = 0,
		S_BOOTING = 1,
	};
	
	void send();
	void resend();
	
	async command error_t AsyncStdControl.start()
	{
		if(call BootState.requestState(S_BOOTING) != SUCCESS)
			return EBUSY;
			
		call AMPacket.setType(&boot, AM_SCPBOOTMSG);
		call AMPacket.setSource(&boot, TOS_NODE_ID);
		call AMPacket.setDestination(&boot, AM_BROADCAST_ADDR);

		call BootAlarm.start(call Scp.getWakeupInterval() * 2);
		send();
		
		return SUCCESS;
	}
	
	async command error_t AsyncStdControl.stop()
	{
		call BootState.toIdle();
		return SUCCESS;
	}
	
	async event void BootAlarm.fired()
	{
		call BootState.toIdle();
	}

	task void doSend()
	{
		send();
	}
	
	void send()
	{
		if(call SubSend.send(&boot, call AMPacket.headerSize()) != SUCCESS)
			post doSend();
	}
	
	task void doResend()
	{
		resend();
	}
	
	void resend()
	{
		if(call Resend.resend() != SUCCESS)
			post doResend();
	}
	
	async command error_t Send.send(message_t * msg, uint8_t len)
	{
		return call SubSend.send(msg, len);
	}
	
//	task void updateBufferTask()
//	{
//		call SubSend.updateBuffer(&boot);
//	}
	
	async event void SubSend.sendDone(message_t * msg, error_t error)
	{
		if(msg == &boot)
		{
//			post updateBufferTask();
			if(!call BootState.isIdle())
				resend();
		}
		else
			signal Send.sendDone(msg, error);
	}

	async command void * Send.getPayload(message_t * msg, uint8_t len)
	{
		return call SubSend.getPayload(msg, len);
	}
	
	async command uint8_t Send.maxPayloadLength()
	{
		return call SubSend.maxPayloadLength();
	}
	
	async command error_t Send.cancel(message_t * msg)
	{
		return call SubSend.cancel(msg);
	}
}
