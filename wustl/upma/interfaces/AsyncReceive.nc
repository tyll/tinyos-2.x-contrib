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

#include <AM.h>

/**
 * Provides packet reception events in an asynchronous fashion.
 *
 * @author Greg Hackmann
 * @see Receive
 */
interface AsyncReceive
{
	/**
	 * A packet was received over the radio.  After it is processed,
	 * <tt>updateBuffer</tt> should be called.
	 *
	 * @param 'message_t * ONE msg' the packet that was received
	 * @param 'void * COUNT(len) payload' the packet's payload
	 * @param len the packet's length
	 */
	async event void receive(message_t * msg, void * payload, uint8_t len);
	
	/**
	 * Provides a new message buffer to the radio stack.
	 * This should be called (only) after each packet is handled, since
	 * the radio stack may do additional radio-specific event handling
	 * here.
	 *
	 * @param 'message_t * ONE msg' the new message buffer to provide to the radio stack
	 * (possibly the same one passed up from the <tt>receive</tt> event)
	 */
	command void updateBuffer(message_t * msg);
}
