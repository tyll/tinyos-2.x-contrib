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
 
#include "PreambleSender.h"

/**
 * Assists with sending preambles, by repeatedly sending a packet for the
 * specified time interval.
 *
 * @author Greg Hackmann
 */
interface PreambleSender
{
	/**
	 * Sends a preamble.
	 *
	 * @param 'message_t * ONE msg' the packet to use for the preamble
	 * @param len the length of the preamble packet
	 * @param ms how long to send the preamble, in milliseconds
	 * @param useCca whether to use a CCA check before sending the preamble
	 */
	async command error_t sendPreamble(message_t * msg, uint8_t len,
		uint16_t ms, bool useCca);
	/**
	 * The preamble is complete.
	 *
	 * @param 'message_t * ONE msg' the packet used for the preamble
	 * @param err whether the send was successful
	 */
	async event void preambleDone(message_t * msg, error_t err);
	
	/**
	 * The next preamble packet is about to be sent.
	 *
	 * @param 'message_t * ONE msg' the packet used for the preamble
	 * @return <tt>DO_NOT_RESEND</tt> (cancel the preamble),
	 * <tt>RESEND_WITH_CCA</tt> (send the next packet with a CCA check),
	 * or <tt>RESEND_WITHOUT_CCA</tt> (send the next packet without a CCA check)
	 */
	async event resend_result_t resendPreamble(message_t * msg);
}
