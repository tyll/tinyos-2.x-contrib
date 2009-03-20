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
 * Active message implementation on top of the CC2420 radio. This
 * implementation uses the 16-bit addressing mode of 802.15.4: the
 * only additional byte it adds is the AM id byte, as the first byte
 * of the data payload.
 *
 * @author Philip Levis
 * @version $Revision$ $Date$
 */
 
#include "CC2420.h"
#include "IEEE802154.h"

module CC2420MessageP {

  provides {
    interface Receive as Ieee154Receive;
    interface Ieee154Send;
    interface Ieee154Packet;
    interface Packet;
  }
  
  uses {
    interface Send as SubSend;
    interface Receive as SubReceive[uint8_t nw];
    interface CC2420Packet;
    interface CC2420PacketBody;
    interface CC2420Config;
#ifdef SW_TOPOLOGY
    interface NodeConnectivity;
#endif
  }
}
implementation {
 
  /***************** AMSend Commands ****************/
  command error_t Ieee154Send.send(ieee154_saddr_t addr,
                                  message_t* msg,
                                  uint8_t len) {
    cc2420_header_t* header = call CC2420PacketBody.getHeader( msg );
    header->dest = addr;
    header->destpan = call CC2420Config.getPanAddr();
    header->src = call CC2420Config.getShortAddr();

    return call SubSend.send( msg, len - sizeof(am_header_t) );
  }

  command error_t Ieee154Send.cancel(message_t* msg) {
    return call SubSend.cancel(msg);
  }

  command uint8_t Ieee154Send.maxPayloadLength() {
    return call Packet.maxPayloadLength();
  }

  command void* Ieee154Send.getPayload(message_t* m, uint8_t len) {
    return call Packet.getPayload(m, len);
  }

  /***************** Ieee154Packet Commands ****************/
  command ieee154_saddr_t Ieee154Packet.address() {
    return call CC2420Config.getShortAddr();
  }
 
  command ieee154_saddr_t Ieee154Packet.destination(message_t* msg) {
    cc2420_header_t* header = call CC2420PacketBody.getHeader(msg);
    return header->dest;
  }
 
  command ieee154_saddr_t Ieee154Packet.source(message_t* msg) {
    cc2420_header_t* header = call CC2420PacketBody.getHeader(msg);
    return header->src;
  }

  command void Ieee154Packet.setDestination(message_t* msg, ieee154_saddr_t addr) {
    cc2420_header_t* header = call CC2420PacketBody.getHeader(msg);
    header->dest = addr;
  }

  command void Ieee154Packet.setSource(message_t* msg, ieee154_saddr_t addr) {
    cc2420_header_t* header = call CC2420PacketBody.getHeader(msg);
    header->src = addr;
  }

  command bool Ieee154Packet.isForMe(message_t* msg) {
    return (call Ieee154Packet.destination(msg) == call Ieee154Packet.address() ||
	    call Ieee154Packet.destination(msg) == IEEE154_BROADCAST_ADDR);
  }

  command ieee154_panid_t Ieee154Packet.pan(message_t* msg) {
    return (call CC2420PacketBody.getHeader(msg))->destpan;
  }

  command void Ieee154Packet.setPan(message_t* msg, ieee154_panid_t grp) {
    // Overridden intentionally when we send()
    (call CC2420PacketBody.getHeader(msg))->destpan = grp;
  }

  command ieee154_panid_t Ieee154Packet.localPan() {
    return call CC2420Config.getPanAddr();
  }


  /***************** Packet Commands ****************/
  command void Packet.clear(message_t* msg) {
    memset(call CC2420PacketBody.getHeader(msg), sizeof(cc2420_header_t), 0);
    memset(call CC2420PacketBody.getMetadata(msg), sizeof(cc2420_metadata_t), 0);
  }
  
  command uint8_t Packet.payloadLength(message_t* msg) {
    return (call CC2420PacketBody.getHeader(msg))->length - IEEE802154_SIZ;
  }
  
  command void Packet.setPayloadLength(message_t* msg, uint8_t len) {
    (call CC2420PacketBody.getHeader(msg))->length  = len + IEEE802154_SIZ;
  }
  
  command uint8_t Packet.maxPayloadLength() {
    return TOSH_DATA_LENGTH + sizeof(am_header_t);
  }
  
  command void* Packet.getPayload(message_t* msg, uint8_t len) {
    cc2420_header_t *hdr = call CC2420PacketBody.getHeader(msg);
    return (void *)&hdr->network;
  }

  
  /***************** SubSend Events ****************/
  event void SubSend.sendDone(message_t* msg, error_t result) {
    signal Ieee154Send.sendDone(msg, result);
  }

  
  /***************** SubReceive Events ****************/
  event message_t* SubReceive.receive[uint8_t nw](message_t* msg, void* payload, uint8_t len) {
    cc2420_header_t *hdr = call CC2420PacketBody.getHeader(msg);

    if(!(call CC2420PacketBody.getMetadata(msg))->crc) {
      return msg;
    }
  
#ifdef SW_TOPOLOGY
    if (call Ieee154Packet.isForMe(msg) &&
        call NodeConnectivity.connected(call Ieee154Packet.source(msg),
                                        TOS_NODE_ID)) {
#else
    if (call Ieee154Packet.isForMe(msg)) {
#endif
      return signal Ieee154Receive.receive(msg, (void *)&hdr->network, 
                                           len + sizeof(am_header_t));
    }
    return msg;
  }
  
  
  /***************** CC2420Config Events ****************/
  event void CC2420Config.syncDone( error_t error ) {
  }

  default event void Ieee154Send.sendDone(message_t *msg, error_t e) {

  }

  default event message_t* Ieee154Receive.receive(message_t *msg, void *payload, uint8_t len) {
    return msg;
  }
}
