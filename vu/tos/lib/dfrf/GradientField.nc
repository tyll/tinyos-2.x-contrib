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
 **/
 /** @author Miklos Maroti
 *   @author Brano Kusy, kusy@isis.vanderbilt.edu
 *   @author Janos Sallai
 */

/**
 * Interface allows to initialize the gradient policy in the network, also
 * allows to set the root, and initilize the gradinet values at other
 * nodes
 */

#include "AM.h"

interface GradientField
{
	/**
	 * Declare this node to be the root. This will initiate the
	 * sending of radio messages and the hopcount information
	 * to be updated in all nodes of the network.
	 */
	command void beacon();

	/**
	 * Returns the node ID of current root of the network.
	 * @return <code>0xFFFF</code> if no root was detected.
	 */
	command am_addr_t rootAddress();

	/**
	 * Sets the node ID of the gradient root.
	 * @param ra node ID of root.
	 */
	command void setRootAddress(am_addr_t ra);

	/**
	 * Returns the averaged hopcount from this node to the root.
	 * @return 4 times the averaged hopcount over several trials.
	 */
	command uint16_t hopCount();

	/**
	 * Sets the hop count from the gradient root.
	 * @param hc the hop count
	 */
	command  void setHopCount(uint16_t hc);

}
