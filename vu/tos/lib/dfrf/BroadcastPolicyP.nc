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
  *     The BroadcastPolicy module is the most simple policy. It resends every message
  *     it heard exactly once. It remembers the packet for 5 seconds till it last heard
  *     it. This ensures that same data packet is not resent if it has already
  *     passed through this node.
  *
  *	Finite state automaton for the policy based on the priority:
  *
  *	priority states:
  *		even - packet created/received that has not been sent by the current
  *			mote; waiting for sending
  *		odd - packet has been sent by the current mote, but we still keep
  *			it for some time, while it's being broadcasted by the motes
  *			around; to avoid the same packet resending
  *
  *	//after sending, keep the packet in routing buffer for a while
  *	0 --sent--> 3
  *
  *	//when the packet is new (0), and it was received from some neighboring mote,
  *	//decrease its priority over new packets, but still leave it scheduled for
  *	//transmission (even)
  *	0 --received--> 2 --sent--> 3
  *
  *	//aging off the packets that were sent already
  *	3 --tick--> 5 --tick--> 7 --tick--> 9 --tick--> 11 --tick--> 0xFF
  *
  *	//whenever a packet, that already has been sent, is received again
  *	//we reset the timer that purges it from the routing buffer
  *	//this avoids the same message resending
  *	5,7,9,11 --received--> 3
  *
  *
  * @author Miklos Maroti
  * @author Brano Kusy, kusy@isis.vanderbilt.edu
  * @author Janos Sallai
  * @modified Jan05 doc fix
  */

module BroadcastPolicyP
{
	provides interface DfrfPolicy;
	uses interface AMPacket;
}

implementation
{
	//Broadcast policy is not location aware
	command uint16_t DfrfPolicy.getLocation()
	{
		return call AMPacket.address();
	}

	command uint8_t DfrfPolicy.sent(uint8_t priority)
	{
		return 3;
	}

	//Broadcast policy is not location aware
	command bool DfrfPolicy.accept(uint16_t location)
	{
		return TRUE;
	}

	command uint8_t DfrfPolicy.received(uint16_t location, uint8_t priority)
	{
		if( priority <= 2 )
			return 2;
		else
			return 3;
	}

	command uint8_t DfrfPolicy.age(uint8_t priority)
	{
		if( (priority & 0x01) == 0 )
			return priority;
		else if( priority < 11 )
			return priority + 2;
		else
			return 0xFF;
	}
}
