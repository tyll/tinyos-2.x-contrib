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
 * @author Greg Hackmann
 * @author Kevin Klues
 * @author Octav Chipara
 * @version $Revision$ $Date$
 */

#include "CC2420.h"

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
    interface PacketLink;
    interface CcaControl[am_id_t amId];
  }
}
implementation {

  components CC2420ActiveMessageP as AM;
  components CC2420CsmaC as CsmaC;
  components ActiveMessageAddressC as Address;
  components UniqueSendC;
  components UniqueReceiveC;
  components CC2420TinyosNetworkC;
  components CC2420PacketC;
  components AsyncAdapterC;
  components LedsC;

  components MacC;

#if defined(PACKET_LINK)
  components PacketLinkC as LinkC;
#else
  components PacketLinkDummyC as LinkC;
#endif

  
  Packet   = AM;
  AMSend   = AM;
  Receive  = AM.Receive;
  Snoop    = AM.Snoop;
  AMPacket = AM;
  PacketLink = LinkC;
  CC2420Packet = CC2420PacketC;
  PacketAcknowledgements = CC2420PacketC;
  
  MacC.SubCcaControl -> CsmaC;
  
  // SplitControl Layers
  SplitControl = MacC;
  CcaControl = MacC;
  
  // Send Layers
  AM.SubSend -> UniqueSendC;
  UniqueSendC.SubSend -> LinkC;
  LinkC.SubSend -> CC2420TinyosNetworkC.Send;
  CC2420TinyosNetworkC.SubSend -> AsyncAdapterC;
  AsyncAdapterC.AsyncSend -> MacC.Send;
  MacC.SubSend -> CsmaC;
  
  // Receive Layers
  AM.SubReceive -> UniqueReceiveC.Receive;
  UniqueReceiveC.SubReceive -> CC2420TinyosNetworkC.Receive;
  CC2420TinyosNetworkC.SubReceive -> AsyncAdapterC;
  AsyncAdapterC.AsyncReceive -> MacC.Receive;
  MacC.SubReceive -> CsmaC;

  AM.amAddress -> Address;
  AM.CC2420Packet -> CC2420PacketC;
  AM.Leds -> LedsC;
  
  MacC.RadioPowerControl -> CsmaC;
  MacC.Resend -> CsmaC;
  MacC.PacketAcknowledgements -> CC2420PacketC;
  MacC.ChannelMonitor -> CsmaC;
  MacC.AMPacket -> AM;
}
