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
 * Controls the radio's CCA and backoff policies.
 *
 * @author Greg Hackmann
 */
interface CcaControl
{
	/**
	 * The initial backoff time for a message must be selected.  If the upper
	 * layer has no need to change the backoff, then return
	 * <tt>defaultBackoff</tt>.
	 *
	 * @param msg the message
	 * @param defaultBackoff the radio-default backoff length
	 * @return the initial backoff length, in 32 Khz increments
	 */
	async event uint16_t getInitialBackoff(message_t * msg, uint16_t defaultbackoff);
	
	/**
	 * The congestion backoff time for a message must be selected.  If the upper
	 * layer has no need to change the backoff, then return
	 * <tt>defaultBackoff</tt>.
	 *
	 * @param msg the message
	 * @param defaultBackoff the radio-default backoff length
	 * @return the congestion backoff length, in 32 Khz increments
	 */	
	async event uint16_t getCongestionBackoff(message_t * msg, uint16_t defaultBackoff);

	/**
	 * Whether to perform CCA before sending a message must be determined.  If
	 * the upper layer has no need to specify this, then return
	 * <tt>defaultCca</tt>.
	 *
	 * @param msg the message
	 * @param defaultCca the radio-default CCA policy
	 * @return whether to perform CCA before sending the message
	 */	
	async event bool getCca(message_t * msg, bool defaultCca);
}
