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
 * Converts an <tt>AsyncSend</tt> interface to a synchronous
 * <tt>Send</tt> interface.
 *
 * @author Greg Hackmann
 */
module AsyncSendAdapterP @safe()
{
	provides interface Send;
	uses interface AsyncSend;
}
implementation
{
	message_t * ONE_NOK msg_;
	uint8_t len_;
	
	task void sendDone_task();
	
	command error_t Send.send(message_t * msg, uint8_t len)
	{
		return call AsyncSend.send(msg, len);
	}
	
	command error_t Send.cancel(message_t * msg)
	{
		return call AsyncSend.cancel(msg);
	}

	async event void AsyncSend.sendDone(message_t * msg, uint8_t len)
	{
		atomic
		{
			msg_ = msg;
			len_ = len;
		}
		post sendDone_task();
		// Save the parameters and start a sync task
	}
	
	task void sendDone_task()
	{
		message_t * msg;
		uint8_t len;
		atomic
		{
			msg = msg_;
			len = len_;
		}
		// Get the parameters back
		
   		signal Send.sendDone(msg, len);
   		// Tell the upper layer that the send is done
	}
	
	command uint8_t Send.maxPayloadLength()
	{
		return call AsyncSend.maxPayloadLength();
	}
	
	command void * Send.getPayload(message_t * msg, uint8_t len)
	{
		return call AsyncSend.getPayload(msg, len);
	}
}
