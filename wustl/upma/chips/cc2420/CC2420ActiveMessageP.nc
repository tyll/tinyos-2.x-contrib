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
 * Active message implementation on top of the CC2420 radio. This
 * implementation uses the 16-bit addressing mode of 802.15.4: the
 * only additional byte it adds is the AM id byte, as the first byte
 * of the data payload.
 *
 * @author Philip Levis
 * @author Greg Hackmann
 * @author Kevin Klues
 * @author Octav Chipara
 * @version $Revision$ $Date$
 */
 
#include "CC2420.h"

module CC2420ActiveMessageP @safe() {
  provides {
    interface AMSend[am_id_t id];
    interface Receive[am_id_t id];
    interface Receive as Snoop[am_id_t id];
    interface AMPacket;
    interface Packet;
    interface CcaControl[am_id_t id];
    interface SendNotifier[am_id_t id];
  }
  uses {
    interface Send as SubSend;
    interface Receive as SubReceive;
    interface CC2420Packet;
    interface CC2420PacketBody;
    interface CC2420Config;
    interface ActiveMessageAddress;
    interface CcaControl as SubCcaControl[am_id_t id];

    interface Resource as RadioResource;
    interface Leds;
  }
}
implementation {
  uint16_t pending_length;
  message_t *pending_message = NULL;
  /***************** Resource event  ****************/
  event void RadioResource.granted() {
    uint8_t rc;
    cc2420_header_t* header = call CC2420PacketBody.getHeader( pending_message );

    signal SendNotifier.aboutToSend[header->type](header->dest, pending_message);
    rc = call SubSend.send( pending_message, pending_length );
    if (rc != SUCCESS) {
      call RadioResource.release();
      signal AMSend.sendDone[header->type]( pending_message, rc );
    }
  }
  
  /***************** AMSend Commands ****************/
  command error_t AMSend.send[am_id_t id](am_addr_t addr,
					  message_t* msg,
					  uint8_t len) {
    cc2420_header_t* header = call CC2420PacketBody.getHeader( msg );
    
    if (len > call Packet.maxPayloadLength()) {
      return ESIZE;
    }
    
    header->type = id;
    header->dest = addr;
    header->destpan = call CC2420Config.getPanAddr();
    header->src = call AMPacket.address();
    
    if (call RadioResource.immediateRequest() == SUCCESS) {
      error_t rc;
      signal SendNotifier.aboutToSend[id](addr, msg);
      
      rc = call SubSend.send( msg, len );
      if (rc != SUCCESS) {
        call RadioResource.release();
      }

      return rc;
    } else {
      pending_length  = len;
      pending_message = msg;
      return call RadioResource.request();
    }
  }

  command error_t AMSend.cancel[am_id_t id](message_t* msg) {
    return call SubSend.cancel(msg);
  }

  command uint8_t AMSend.maxPayloadLength[am_id_t id]() {
    return call Packet.maxPayloadLength();
  }

  command void* AMSend.getPayload[am_id_t id](message_t* m, uint8_t len) {
    return call Packet.getPayload(m, len);
  }

  /***************** AMPacket Commands ****************/
  async command am_addr_t AMPacket.address() {
    return call ActiveMessageAddress.amAddress();
  }
 
  async command am_addr_t AMPacket.destination(message_t* amsg) {
    cc2420_header_t* header = call CC2420PacketBody.getHeader(amsg);
    return header->dest;
  }
 
  async command am_addr_t AMPacket.source(message_t* amsg) {
    cc2420_header_t* header = call CC2420PacketBody.getHeader(amsg);
    return header->src;
  }

  async command void AMPacket.setDestination(message_t* amsg, am_addr_t addr) {
    cc2420_header_t* header = call CC2420PacketBody.getHeader(amsg);
    header->dest = addr;
  }

  async command void AMPacket.setSource(message_t* amsg, am_addr_t addr) {
    cc2420_header_t* header = call CC2420PacketBody.getHeader(amsg);
    header->src = addr;
  }

  async command bool AMPacket.isForMe(message_t* amsg) {
    return (call AMPacket.destination(amsg) == call AMPacket.address() ||
	    call AMPacket.destination(amsg) == AM_BROADCAST_ADDR);
  }

  async command am_id_t AMPacket.type(message_t* amsg) {
    cc2420_header_t* header = call CC2420PacketBody.getHeader(amsg);
    return header->type;
  }

  async command void AMPacket.setType(message_t* amsg, am_id_t type) {
    cc2420_header_t* header = call CC2420PacketBody.getHeader(amsg);
    header->type = type;
  }
  
  async command am_group_t AMPacket.group(message_t* amsg) {
    return (call CC2420PacketBody.getHeader(amsg))->destpan;
  }

  async command void AMPacket.setGroup(message_t* amsg, am_group_t grp) {
    // Overridden intentionally when we send()
    (call CC2420PacketBody.getHeader(amsg))->destpan = grp;
  }

  async command am_group_t AMPacket.localGroup() {
    return call CC2420Config.getPanAddr();
  }
  
  async command uint8_t AMPacket.headerSize() {
    return CC2420_SIZE;
  }

  /***************** Packet Commands ****************/
  command void Packet.clear(message_t* msg) {
    memset(call CC2420PacketBody.getHeader(msg), 0x0, sizeof(cc2420_header_t));
    memset(call CC2420PacketBody.getMetadata(msg), 0x0, sizeof(cc2420_metadata_t));
  }
  
  command uint8_t Packet.payloadLength(message_t* msg) {
    return (call CC2420PacketBody.getHeader(msg))->length - CC2420_SIZE;
  }
  
  command void Packet.setPayloadLength(message_t* msg, uint8_t len) {
    (call CC2420PacketBody.getHeader(msg))->length  = len + CC2420_SIZE;
  }
  
  command uint8_t Packet.maxPayloadLength() {
    return call SubSend.maxPayloadLength();
  }
  
  command void* Packet.getPayload(message_t* msg, uint8_t len) {
    return call SubSend.getPayload(msg, len);
  }

  
  /***************** SubSend Events ****************/
  event void SubSend.sendDone(message_t* msg, error_t result) {
    call RadioResource.release();
    signal AMSend.sendDone[call AMPacket.type(msg)](msg, result);
  }

  
  /***************** SubReceive Events ****************/
  event message_t* SubReceive.receive(message_t* msg, void* payload, uint8_t len) {
    
    if (call AMPacket.isForMe(msg)) {
      return signal Receive.receive[call AMPacket.type(msg)](msg, payload, len);
    }
    else {
      return signal Snoop.receive[call AMPacket.type(msg)](msg, payload, len);
    }
  }
  
  
  /***************** ActiveMessageAddress Events ****************/
  async event void ActiveMessageAddress.changed() {
  }

  /***************** CC2420Config Events ****************/
  event void CC2420Config.syncDone( error_t error ) {
  }
  
  /***************** CcaControl Events ****************/
  async event uint16_t SubCcaControl.getInitialBackoff[am_id_t amId](message_t * msg, uint16_t defaultBackoff) {
  	return signal CcaControl.getInitialBackoff[(TCAST(cc2420_header_t* ONE,
        (uint8_t*)msg + offsetof(message_t, data) - sizeof(cc2420_header_t)))->type](msg, defaultBackoff);
  }
  
  async event uint16_t SubCcaControl.getCongestionBackoff[am_id_t amId](message_t * msg, uint16_t defaultBackoff) {
  	return signal CcaControl.getCongestionBackoff[(TCAST(cc2420_header_t* ONE,
        (uint8_t*)msg + offsetof(message_t, data) - sizeof(cc2420_header_t)))->type](msg, defaultBackoff);
  }
  
  async event bool SubCcaControl.getCca[am_id_t amId](message_t * msg, bool defaultValue) {
  	return signal CcaControl.getCca[amId](msg, defaultValue);
  }
  
  /***************** Defaults ****************/
  default event message_t* Receive.receive[am_id_t id](message_t* msg, void* payload, uint8_t len) {
    return msg;
  }
  
  default event message_t* Snoop.receive[am_id_t id](message_t* msg, void* payload, uint8_t len) {
    return msg;
  }

  default event void AMSend.sendDone[uint8_t id](message_t* msg, error_t err) {
    call RadioResource.release();
  }

  default event void SendNotifier.aboutToSend[am_id_t amId](am_addr_t addr, message_t *msg) {
  }

  default async event uint16_t CcaControl.getInitialBackoff[am_id_t amId](message_t * msg, uint16_t defaultBackoff) {
  	return defaultBackoff;
  }
  
  default async event uint16_t CcaControl.getCongestionBackoff[am_id_t amId](message_t * msg, uint16_t defaultBackoff) {
  	return defaultBackoff;
  }
  
  default async event bool CcaControl.getCca[am_id_t amId](message_t * msg, bool defaultValue) {
  	return defaultValue;
  }
  
}
