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
 * Provides packet sending commands in an asynchronous fashion.
 *
 * @author Greg Hackmann
 * @see AMSend
 */
interface AsyncSend
{
	/**
	 * Sends a packet over the radio, in split-control fashion.
	 *
	 * @param 'message_t * ONE msg' the packet to send
	 * @param len the packet's length
	 * @return <tt>SUCCESS</tt> if the packet was buffered;
	 * <tt>EOFF</tt> if the radio is off; or <tt>FAIL</tt> if the request could
	 * not otherwise be completed
	 */
	async command error_t send(message_t * msg, uint8_t len);	
	/**
	 * The packet sending operation has completed.
	 *
	 * @param 'message_t * ONE msg' the packet that has been completely processed
	 * @param error <tt>SUCCESS</tt> if the packet was successfully
	 * sent over the radio, or <tt>FAIL</tt> otherwise
	 */
	async event void sendDone(message_t * msg, error_t error);

	/**
	 * Attempts to cancel a packet transmission.
	 *
	 * @param 'message_t * ONE msg' the packet to cancel
	 * @return whether the cancellation succeeded
	 */
	async command error_t cancel(message_t * msg);
	
	/**
	 * Gets the maximum packet payload length.
	 *
	 * @return the maximum packet payload length, in bytes
	 */
	async command uint8_t maxPayloadLength();
	
	/**
	 * Gets the packet payload.
	 *
	 * @param 'message_t * ONE msg' the packet
	 * @return 'void * COUNT_NOK(len)' the packet's payload
	 */
	async command void * getPayload(message_t * msg, uint8_t len);
}
