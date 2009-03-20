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
 * The Active Message layer for the CC2420 radio. This configuration
 * just layers the AM dispatch (CC2420ActiveMessageM) on top of the
 * underlying CC2420 radio packet (CC2420CsmaCsmaCC), which is
 * inherently an AM packet (acknowledgements based on AM destination
 * addr and group). Note that snooping may not work, due to CC2420
 * early packet rejection if acknowledgements are enabled.
 *
 * @author Philip Levis
 * @author David Moss
 * @version $Revision$ $Date$
 */

#include "CC2420.h"

configuration CC2420MessageC {
  provides {
    interface SplitControl;

#ifdef CC2420_IFRAME_TYPE
    /* 
     * if IFRAMEs aren't enabled, we can't provide any sort of
     * 802.15.4 layer, so this components is only used for wiring
     */
    interface Ieee154Send;
    interface Receive as Ieee154Receive;

    interface Ieee154Packet;
    interface Packet;
#endif
    interface Send as TinyosSend;
    interface Receive as TinyosReceive;

    interface CC2420Packet;
    interface PacketAcknowledgements;
    interface LinkPacketMetadata;
    interface LowPowerListening;
    interface CC2420Config;
    interface PacketLink;
    interface RadioBackoff;
  }
}
implementation {

  components CC2420PacketC;
  components CC2420ControlC;

  components CC2420TinyosNetworkC;
  components UniqueSendC;
  components UniqueReceiveC;

#if defined(LOW_POWER_LISTENING) || defined(ACK_LOW_POWER_LISTENING)
  components DefaultLplC as LplC;
#else
  components DummyLplC as LplC;
#endif

#if defined(PACKET_LINK)
  components PacketLinkC as LinkC;
#else
  components PacketLinkDummyC as LinkC;
#endif
  components CC2420CsmaC as CsmaC;

#ifdef CC2420_IFRAME_TYPE
  components CC2420MessageP as Msg;

  Ieee154Receive = Msg.Ieee154Receive;
  Ieee154Send = Msg;
  Ieee154Packet = Msg;
  Packet = Msg;

  Msg.SubSend -> CC2420TinyosNetworkC.NonTinyosSend;
  Msg.SubReceive -> CC2420TinyosNetworkC.NonTinyosReceive;
  Msg.CC2420Packet -> CC2420PacketC;
  Msg.CC2420PacketBody -> CC2420PacketC;
  Msg.CC2420Config -> CC2420ControlC;
#endif

  CC2420Packet = CC2420PacketC;

  PacketAcknowledgements = CC2420PacketC;
  LinkPacketMetadata = CC2420PacketC;
  LowPowerListening = LplC;
  CC2420Config = CC2420ControlC;
  PacketLink = LinkC;
  RadioBackoff = CsmaC;

  // SplitControl Layers
  SplitControl = LplC;
  LplC.SubControl -> CsmaC;
  
  // Send Layers
  TinyosSend = CC2420TinyosNetworkC.Send;
  CC2420TinyosNetworkC.SubSend -> UniqueSendC.Send;
  UniqueSendC.SubSend -> LinkC.Send;
  LinkC.SubSend -> LplC.Send;
  LplC.SubSend ->  CsmaC;
  
  // Receive Layers
  TinyosReceive = CC2420TinyosNetworkC.Receive;
  CC2420TinyosNetworkC.SubReceive -> LplC.Receive;
  LplC.SubReceive -> UniqueReceiveC.Receive;
  UniqueReceiveC.SubReceive ->  CsmaC;

#ifdef SW_TOPOLOGY
#warning "*** USING SOFTWARE TOPOLOGY"
  components TestbedConnectivityM;
  Msg.NodeConnectivity -> TestbedConnectivityM;
#endif

}
