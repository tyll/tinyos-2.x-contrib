/*
 * "Copyright (c) 2007-2008 Washington University in St. Louis.
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
#include "AM.h"

configuration CC2420ActiveMessageC {
  provides {
    interface SplitControl;
    interface AMSend[am_id_t id];
    interface Receive[am_id_t id];
    interface Receive as Snoop[am_id_t id];
    interface AMPacket;
    interface Packet;
    interface PacketAcknowledgements;
    interface PacketLink;
    interface CcaControl[am_id_t amId];
    interface CC2420Packet;
  }
}
implementation {

  components CC2420ActiveMessageP as AM;
  components CC2420CsmaC as CsmaC;
  components ActiveMessageAddressC;
  components UniqueSendC;
  components UniqueReceiveC;
  components CC2420TinyosNetworkC;
  components CC2420PacketC;
  components CC2420ControlC;
  components AsyncAdapterC;
  components PowerCycleC;
  components MacC;

#if defined(PACKET_LINK)
  components PacketLinkC as LinkC;
#else
  components PacketLinkDummyC as LinkC;
#endif

  
  Packet = AM;
  AMSend = AM;
  Receive = AM.Receive;
  Snoop = AM.Snoop;
  AMPacket = AM;
  PacketLink = LinkC;
  PacketAcknowledgements = CC2420PacketC;
  CC2420Packet = CC2420PacketC;
  

  
  // SplitControl Layers
  SplitControl = MacC;
  CcaControl = MacC;
  
  // Send Layers
  AM.SubSend -> UniqueSendC;
  UniqueSendC.SubSend -> LinkC;
  LinkC.SubSend -> CC2420TinyosNetworkC.Send;
  CC2420TinyosNetworkC.SubSend -> AsyncAdapterC.Send;
  AsyncAdapterC.AsyncSend -> MacC;
  MacC.SubSend -> CsmaC;
  
  // Receive Layers
  AM.SubReceive -> UniqueReceiveC.Receive;
  UniqueReceiveC.SubReceive -> CC2420TinyosNetworkC.Receive;
  CC2420TinyosNetworkC.SubReceive -> AsyncAdapterC.Receive;
  AsyncAdapterC.AsyncReceive -> MacC;
  MacC.SubReceive -> CsmaC;
  
  MacC.RadioPowerControl -> CsmaC;
  MacC.Resend -> CsmaC;
  MacC.PacketAcknowledgements -> CC2420PacketC;
  MacC.ChannelMonitor -> PowerCycleC;
  MacC.AMPacket -> AM;
  
  AM.ActiveMessageAddress -> ActiveMessageAddressC;
  AM.CC2420PacketBody -> CC2420PacketC;
  AM.CC2420Config -> CC2420ControlC;
  
}
