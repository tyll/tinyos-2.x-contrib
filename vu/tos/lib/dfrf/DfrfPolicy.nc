/*
 * Copyright (c) 2009, Vanderbilt University
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 *
 * IN NO EVENT SHALL THE VANDERBILT UNIVERSITY BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE VANDERBILT
 * UNIVERSITY HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * THE VANDERBILT UNIVERSITY SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE VANDERBILT UNIVERSITY HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.
 *
 */

/**
 * FloodingPolicy interface allows to tailor FloodRouting engine for different
 * routing strategies.
 * The flood routing engine keeps several data packets in a table. Each data
 * packet has an assigned priority field. The engine periodically scans this
 * table and selects a few packets based on their priority, packs them into a
 * single TOS_Msg and sends them. The
 *
 * 1.	A packet is NOT selected for sending if its priority is odd.
 * 2.	The packets with the least value of priority are preferred for sending.
 *
 * When a new data packet arrives, first we check if the same packet is already
 * in the table based on the first unique bytes. If it is not there, then we
 * select an unused or existing packet slot and replace its content. This selection
 * is based on the following rule:
 *
 * 3.	A packet with priority 0xFF is considered unused.
 * 4.	The packet with the largest value of priority is selected for overwrite.
 *
 * The FloodingPolicy implementor has to write a small state-machine. It must
 * ensure that the message is sent (even number), and then remembered for some
 * time (odd number) to avoid resending sent packets, and finally it has to
 * set the priority to 0xFF to free up resources and forget old packets.
 *
 * @author Miklos Maroti
 * @author Brano Kusy, kusy@isis.vanderbilt.edu
 * @author Janos Sallai
 */

interface DfrfPolicy
{
	/**
	 * Fired by the flood routing engine to get the "location" of
	 * this node. The meaning of the "location" is policy dependent:
	 * it can be a constant value, hop count from a root, 2D offset
	 * of the physical location from some center, or something else.
	 */
	command uint16_t getLocation();

	/**
	 * Fired by the flood routing engine when data has been successfully
	 * sent. The policy implementation should change the priority so it
	 * does not send the same packets in an infinite loop.
	 * IMPORTANT: This command is called when the packet was sent, and by
	 * this time the priority might not be the same as it was when this
	 * packet was selected for sending. In particular, the packet
	 * can be odd, if the old even value was changed in received() or age().
	 *
	 * @param priority The old priority of the data packet.
	 * @return The new priority of the data packet. Return 0xFF to drop
	 *	this packet.
	 */
	command uint8_t sent(uint8_t priority);

	/**
	 * Fired by the flood routing enginge when a data packet is received.
	 * The policy implementation can indicate to drop this packet.
	 *
	 * @param location The location of the sender.
	 * @return FALSE to drop this packet, or TRUE to start searching
	 *	for a match and the packet table.
	 */
	command bool accept(uint16_t location);

	/**
	 * Fired by the flood routing engine when a data packet is received,
	 * and this policy returned SUCCESS in accept(). The policy
	 * implementation can change the priority of the packet.
	 *
	 * @param location The location of the sender.
	 * @param priority 0x00 if this data packet is new at this node,
	 *	or the existing priority of the matching packet.
	 * @return The new priority of the data packet. Return 0xFF to drop
	 *	this packet.
	 */
	command uint8_t received(uint16_t location, uint8_t priority);

	/**
	 * Fired by the flood routing engine when a data packet is aged.
	 * The policy implementation should "increase" the priority and
	 * eventually set it to 0xFF (free).
	 *
	 * @param priority The old priority of the data packet.
	 * @return The new priority of the data packet. Return 0xFF to drop
	 *	this packet.
	 */
	command uint8_t age(uint8_t priority);
}
