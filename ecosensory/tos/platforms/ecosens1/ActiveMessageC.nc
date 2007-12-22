/* Copyright (c) 2007, Ecosensory Austin Texas All rights reserved. 
 * BSD license full text at: 
 * http://tinyos.cvs.sourceforge.net/tinyos/tinyos-2.x-contrib/ecosensory/license.txt
 * @author Philip Levis  Revision: 1.4 $ $Date: 2006/12/12 18:23:44 
 * Date last modified:  $Id$
 *
 * Naming wrapper around the CC2420 Active Message layer on the ecosens1 platform.
 */

configuration ActiveMessageC {
  provides {
    interface SplitControl;

    interface AMSend[uint8_t id];
    interface Receive[uint8_t id];
    interface Receive as Snoop[uint8_t id];

    interface Packet;
    interface AMPacket;
    interface PacketAcknowledgements;
  }
}
implementation {
  components CC2420ActiveMessageC as AM;

  SplitControl = AM;
  
  AMSend       = AM;
  Receive      = AM.Receive;
  Snoop        = AM.Snoop;
  Packet       = AM;
  AMPacket     = AM;
  PacketAcknowledgements = AM;
}
