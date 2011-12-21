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
 * Converts an <tt>AsyncReceive</tt> interface to a synchronous
 * <tt>Receive</tt> interface.
 *
 * @author Greg Hackmann
 */
module AsyncReceiveAdapterP @safe()
{
	provides interface Receive;
	uses interface AsyncReceive;
}
implementation
{
	message_t * ONE_NOK msg_;
	void * ONE_NOK payload_;
	uint8_t len_;
	
	task void receiveDone_task();
	
	async event void AsyncReceive.receive(message_t * msg, void * payload, uint8_t len)
	{
		atomic
		{
			msg_ = msg;
			payload_ = payload;
			len_ = len;
		}
		post receiveDone_task();
		// Save the parameters and start a sync task
	}
	
	task void receiveDone_task()
	{
		message_t * msg;
		void * payload;
		uint8_t len;
		atomic
		{
			msg = msg_;
			payload = payload_;
			len = len_;
		}
		// Get the parameters back
		
		call AsyncReceive.updateBuffer(signal Receive.receive(msg, payload, len));
		// Tell the upper layer the message is here, then tell the lower layer
		// about the new buffer
	}
}
