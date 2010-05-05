/*
 * "Copyright (c) 2008 The Regents of the University  of California.
 * All rights reserved."
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 *
 * IN NO EVENT SHALL THE UNIVERSITY OF CALIFORNIA BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE UNIVERSITY OF
 * CALIFORNIA HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * THE UNIVERSITY OF CALIFORNIA SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE UNIVERSITY OF CALIFORNIA HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
 *
 */
/*									tab:4
 * "Copyright (c) 2005 Stanford University. All rights reserved.
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
 * IEEE 802.15.4 layer for the cc2420.  Provides a simplistic 
 *       link layer with dispatching on the 6lowpan "network" field
 *
 * @author Philip Levis
 * @author David Moss
 * @author Stephen Dawson-Haggerty
 * @version $Revision$ $Date$
 */

#include "CC2420.h"
#ifdef TFRAMES_ENABLED
#error "The CC2420 Ieee 802.15.4 layer does not work with TFRAMES"
#endif

configuration CC2420Ieee154MessageC {
  provides {
    interface SplitControl;

    // interface Resource as SendResource[uint8_t clientId];
    interface Ieee154Send;
    interface Receive as Ieee154Receive;

    interface Ieee154Packet;
    interface Packet;

    interface CC2420Packet;
    interface PacketAcknowledgements;
    interface CC2420Config;
    interface PacketLink;
  }
}
implementation {
  enum {
    CC2420_SEND_CLIENT_ID = unique(CC2420_SEND_CLIENT),
  };

  components HotmacC;
  components CC2420Ieee154MessageP as Msg;
  components CC2420PacketC;
  components CC2420ControlC;

  // SendResource = HotmacC.Resource;
  Ieee154Receive = HotmacC.Ieee154Receive;
  Ieee154Send = Msg;
  Ieee154Packet = Msg;
  Packet = Msg;
  CC2420Packet = CC2420PacketC;

  SplitControl = HotmacC;
  CC2420Packet = CC2420PacketC;
  CC2420Config = CC2420ControlC;
  PacketAcknowledgements = HotmacC;
  PacketLink = HotmacC;

  Msg.SubSend -> HotmacC.Ieee154Send;

  Msg.CC2420Packet -> CC2420PacketC;
  Msg.CC2420PacketBody -> CC2420PacketC;
  Msg.CC2420Config -> CC2420ControlC;

}
