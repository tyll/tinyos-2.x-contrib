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
 * The Active Message layer for the CC2420 radio. This configuration
 * just layers the AM dispatch (CC2420ActiveMessageM) on top of the
 * underlying CC2420 radio packet (CC2420CsmaCsmaCC), which is
 * inherently an AM packet (acknowledgements based on AM destination
 * addr and group). Note that snooping may not work, due to CC2420
 * early packet rejection if acknowledgements are enabled.
 *
 * @author Philip Levis
 * @version $Revision$ $Date$
 */

#include "CC2420.h"

#warning "*** USING RRC_CC2420_RELIABLE STACK"

configuration CC2420ActiveMessageC {
  provides {
    interface SplitControl;
    interface AMSend[am_id_t id];
    interface Receive[am_id_t id];
    interface Receive as Snoop[am_id_t id];
    interface AMPacket;
    interface Packet;
    interface CC2420Packet;
    interface PacketAcknowledgements;
    interface RadioBackoff[am_id_t amId];
    interface LowPowerListening;
    interface MessageTransport;
  }
}
implementation {

  components CC2420ActiveMessageP as AM;
  components CC2420CsmaC as CsmaC;
  components ActiveMessageAddressC as Address;
  components UniqueSendC;
  components UniqueReceiveC;
  components CC2420PacketC;
  
#ifdef LOW_POWER_LISTENING
  components CC2420LowPowerListeningC as LplC;
#else
  components CC2420LplDummyC as LplC;
#endif

#ifdef MESSAGE_TRANSPORT
  components MessageTransportC as TransportC;
#else
  components MessageTransportDummyC as TransportC;
#endif

  
  RadioBackoff = CsmaC;
  Packet       = AM;
  AMSend   = AM;
  Receive  = AM.Receive;
  Snoop    = AM.Snoop;
  AMPacket = AM;
  MessageTransport = TransportC;
  LowPowerListening = LplC;
  CC2420Packet = CC2420PacketC;
  PacketAcknowledgements = CC2420PacketC;
  
  
  // SplitControl Layers
  SplitControl = LplC;
  LplC.SubControl -> CsmaC;
  
  // Send Layers
  AM.SubSend -> UniqueSendC;
  UniqueSendC.SubSend -> TransportC;
  TransportC.SubSend -> LplC.Send;
  LplC.SubSend -> CsmaC;
  
  // Receive Layers
  AM.SubReceive -> LplC;
  LplC.SubReceive -> UniqueReceiveC;
  UniqueReceiveC.SubReceive -> CsmaC;

  AM.amAddress -> Address;
  AM.CC2420Packet -> CC2420PacketC;
  
}
