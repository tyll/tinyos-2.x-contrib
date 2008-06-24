/*
 * "Copyright (c) 2008 Stanford University. All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and
 * its documentation for any purpose, without fee, and without written
 * agreement is hereby granted, provided that the above copyright
 * notice, the following two paragraphs and the author appear in all
 * copies of this software.
 * 
 * IN NO EVENT SHALL STANFORD UNIVERSITY BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES
 * ARISING OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN
 * IF STANFORD UNIVERSITY HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH
 * DAMAGE.
 * 
 * STANFORD UNIVERSITY SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE
 * PROVIDED HEREUNDER IS ON AN "AS IS" BASIS, AND STANFORD UNIVERSITY
 * HAS NO OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES,
 * ENHANCEMENTS, OR MODIFICATIONS."
 */

/**
 * GTS Interface between GTS layer and CC2420. 
 *
 * @author Jung Il Choi
 * @date   Jun 17 2008
 */ 

interface AMQuiet {

  /**
   * Used when CC2420's receiver notify GTS layer packet arriving.
   */
  	command void runQuiet(message_t* msg);

  /**
   * Checks if GTS layer permits transmission. Used for GTS layer 
   * and CC2420 Transmitter.
   */
  	command bool clearToSend();

  /**
   * Checks if GTS is suppressing transmissions. 
   * Used with last-minute transmission cancellations.
   */
  	async command bool beingQuiet();

  /**
   * In CC2420 Receiver, used to fill the gap between cancelling tx packets
   * and starting the quiet timer.
   */
  	async command void blockSend();

  /**
   * Undo blockSend()
   */
  	async command void allowSend();

  /**
   * Returns if the grant timer is running.
   */
	async command bool isGranted();

  /**
   * Returns if the type is used by the node.
   * For temporary filtering non-GTS packets.
   */
 	command bool isUsedType(am_id_t type);

}
