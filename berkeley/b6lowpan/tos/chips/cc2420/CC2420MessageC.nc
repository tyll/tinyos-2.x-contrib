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
    interface IEEE154Send;
    interface Receive;
    interface Packet;
    interface CC2420Packet;
    interface IEEE154Packet;
    interface IPAddress;
    interface PacketAcknowledgements;
    interface LinkPacketMetadata;
    interface LowPowerListening;
    interface SendNotifier;
    interface CC2420Config;
    interface PacketLink;
  }
}
implementation {

  components CC2420MessageP as Msg;
  components CC2420CsmaC as CsmaC;
  components IPAddressC;
  components UniqueSendC;
  components UniqueReceiveC;
  components CC2420PacketC;
  components CC2420ControlC;
  
#if defined(LOW_POWER_LISTENING) || defined(ACK_LOW_POWER_LISTENING)
  components DefaultLplC as LplC;
#else
  components DummyLplC as LplC;
#endif

  components PacketLinkC as LinkC;

  Packet = Msg;
  SendNotifier = Msg;
  Receive = Msg.Receive;
  LowPowerListening = LplC;
  IEEE154Packet = Msg;
  CC2420Packet = CC2420PacketC;
  IPAddress = IPAddressC;
  PacketAcknowledgements = CC2420PacketC;
  LinkPacketMetadata = CC2420PacketC;
  IEEE154Send = Msg;
  CC2420Config = CC2420ControlC;
  PacketLink = LinkC;

  // SplitControl Layers
  SplitControl = LplC;
  LplC.SubControl -> CsmaC;
  
  // Send Layers
  Msg.SubSend -> UniqueSendC;
  UniqueSendC.SubSend -> LinkC.Send;
  LinkC.SubSend -> LplC.Send;
  LplC.SubSend ->  CsmaC;
  
  // Receive Layers
  Msg.SubReceive -> LplC;
  LplC.SubReceive -> UniqueReceiveC.Receive;
  UniqueReceiveC.SubReceive ->  CsmaC;

  Msg.IPAddress -> IPAddressC;
  Msg.CC2420Packet -> CC2420PacketC;
  Msg.CC2420PacketBody -> CC2420PacketC;
  Msg.CC2420Config -> CC2420ControlC;
  
#ifdef SW_TOPOLOGY
#warning "*** USING SOFTWARE TOPOLOGY"
  components TestbedConnectivityM;
  Msg.NodeConnectivity -> TestbedConnectivityM;
#endif
}
