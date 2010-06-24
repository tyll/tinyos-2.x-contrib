// $Id$
/*
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
 *
 * The basic chip-independent TOSSIM Ieee154 Message layer for radio chips
 * that do not have simulation support.
 *
 * @author Philip Levis
 * @author Morten Tranberg Hansen <mth at cs dot au dot dk> (ported from TossimActiveMessageC)
 * @date December 2 2005
 */

#include <AM.h>

module TossimIeee154MessageC {
  provides {
    interface Resource as SendResource[uint8_t clientId];
    
    interface Ieee154Send;
    interface Receive as Ieee154Receive;
		
    interface Packet;
    interface Ieee154Packet;
    interface TossimPacket;
  }
  uses {
    interface TossimPacketModel as Model;
    command am_addr_t amAddress();

		interface ResourceQueue as Queue;
  }
}
implementation {

	enum {
		AM_OVERHEAD = 2,
		NO_OWNER = 0xFF,
	};

  message_t buffer;
  message_t* bufferPointer = &buffer;

	uint8_t owner = NO_OWNER;
  
  tossim_header_t* getHeader(message_t* msg) {
    return (tossim_header_t*)(msg->data - sizeof(tossim_header_t));
  }
	
  tossim_metadata_t* getMetadata(message_t* msg) {
    return (tossim_metadata_t*)(&msg->metadata);
  }
  
  command error_t Ieee154Send.send(ieee154_saddr_t addr, message_t* msg, uint8_t len) {
    error_t err;
    tossim_header_t* header = getHeader(msg);
    dbg("Ieee154", "Ieee154: Sending packet (len=%hhu) to %hu\n", len, addr);
    header->dest = addr;
    header->src = call Ieee154Packet.address();
    header->length = len;
    err = call Model.send((int)addr, msg, len + sizeof(tossim_header_t) - sizeof(am_id_t));
    return err;
  }

  command error_t Ieee154Send.cancel(message_t* msg) {
    return call Model.cancel(msg);
  }
  
  command uint8_t Ieee154Send.maxPayloadLength() {
    return call Packet.maxPayloadLength();
  }

  command void* Ieee154Send.getPayload(message_t* m, uint8_t len) {
    return call Packet.getPayload(m, len);
  }

  command int8_t TossimPacket.strength(message_t* msg) {
    return getMetadata(msg)->strength;
  }

  /*command int8_t TossimPacket.noise(message_t* msg) {
    return getMetadata(msg)->noise;
		}*/
  
  event void Model.sendDone(message_t* msg, error_t result) {
    signal Ieee154Send.sendDone(msg, result);
  }

  /* Receiving a packet */

  event void Model.receive(message_t* msg) {
    uint8_t len;
    void* payload;

    memcpy(bufferPointer, msg, sizeof(message_t));
    len = call Packet.payloadLength(bufferPointer);
    payload = call Packet.getPayload(bufferPointer, call Packet.maxPayloadLength());

		dbg("Ieee154", "Received ieee154 message (%p) of length %hhu for me @ %s.\n", bufferPointer, len, sim_time_string());
		bufferPointer = signal Ieee154Receive.receive(bufferPointer, payload, len);
  }

  event bool Model.shouldAck(message_t* msg) {
    tossim_header_t* header = getHeader(msg);
    if (header->dest == call amAddress()) {
      dbg("Acks", "Received packet addressed to me so ack it\n");
      return TRUE;
    }
    return FALSE;
  }


	command ieee154_saddr_t Ieee154Packet.address() {
		return call amAddress();
	}

	command ieee154_saddr_t Ieee154Packet.destination(message_t* msg) {
    tossim_header_t* header = getHeader(msg);
    return header->dest;
	}
	
  command ieee154_saddr_t Ieee154Packet.source(message_t* msg) {
    tossim_header_t* header = getHeader(msg);
    return header->src;		
	}

  command void Ieee154Packet.setDestination(message_t* msg, ieee154_saddr_t addr) {
    tossim_header_t* header = getHeader(msg);
    header->dest = addr;
	}

  command void Ieee154Packet.setSource(message_t* msg, ieee154_saddr_t addr) {
    tossim_header_t* header = getHeader(msg);
    header->src = addr;
	}

  command bool Ieee154Packet.isForMe(message_t* msg) {
    return (call Ieee154Packet.destination(msg) == call Ieee154Packet.address() ||
	    call Ieee154Packet.destination(msg) == IEEE154_BROADCAST_ADDR);
	}

  command ieee154_panid_t Ieee154Packet.pan(message_t* msg) {
    tossim_header_t* header = getHeader(msg);
    return header->group;
	}

  command void Ieee154Packet.setPan(message_t* msg, ieee154_panid_t grp) {
    tossim_header_t* header = getHeader(msg);
    header->group = grp;
	}

  command ieee154_panid_t Ieee154Packet.localPan() {
		/* TODO: change to IEEE154 group identifier when TinyOS implement this. 
		 * (currently addresses are stored in the AM specific ActiveMessageAddressC component) */
    return TOS_AM_GROUP;
	}
  
 
  command void Packet.clear(message_t* msg) {}
  
  command uint8_t Packet.payloadLength(message_t* msg) {
    return getHeader(msg)->length;
  }
  
  command void Packet.setPayloadLength(message_t* msg, uint8_t len) {
    getHeader(msg)->length = len;
  }
  
  command uint8_t Packet.maxPayloadLength() {
    return TOSH_DATA_LENGTH + AM_OVERHEAD;
  }
  
  command void* Packet.getPayload(message_t* msg, uint8_t len) {
    if (len <= TOSH_DATA_LENGTH + AM_OVERHEAD) {
      return &getHeader(msg)->group;
    }
    else {
      return NULL;
    }
  }

 default command error_t Model.send(int node, message_t* msg, uint8_t len) {
   return FAIL;
 }

 default command error_t Model.cancel(message_t* msg) {
   return FAIL;
 }

 default command am_addr_t amAddress() {
   return 0;
 }
  
 void ieee154_message_deliver_handle(sim_event_t* evt) {
   message_t* m = (message_t*)evt->data;
   dbg("Packet", "Delivering packet to %i at %s\n", (int)sim_node(), sim_time_string());
   signal Model.receive(m);
 }
 
 sim_event_t* allocate_deliver_event(int node, message_t* msg, sim_time_t t) {
   sim_event_t* evt = (sim_event_t*)malloc(sizeof(sim_event_t));
   evt->mote = node;
   evt->time = t;
   evt->handle = ieee154_message_deliver_handle;
   evt->cleanup = sim_queue_cleanup_event;
   evt->cancelled = 0;
   evt->force = 0;
   evt->data = msg;
   return evt;
 }
 
 void active_message_deliver(int node, message_t* msg, sim_time_t t) @C() @spontaneous() {
   sim_event_t* evt = allocate_deliver_event(node, msg, t);
   sim_queue_insert(evt);
 }

 task void grantTask() {
	 if(owner!=NO_OWNER) {
		 dbgerror("Ieee154", "already granted\n");
		 return;
	 }
	 atomic owner = call Queue.dequeue();
	 if(owner!=NO_OWNER) {
		 dbg("Ieee154", "new owner %hhu\n", owner);
		 signal SendResource.granted[owner]();
	 } else {
		 dbg("Ieee154", "resource is free\n");
	 }
 }

 async command error_t SendResource.request[uint8_t id]() {
	 error_t e = call Queue.enqueue(id);
	 if(e==SUCCESS) {
		 dbg("Ieee154", "request from %hhu\n", id);
		 post grantTask();
	 } else {
		 dbgerror("Ieee154", "not able to queue request from %hhu with queue size %hhu\n", id, uniqueCount(RADIO_SEND_RESOURCE));
	 }
	 return e;
 }
 
 async command error_t SendResource.immediateRequest[uint8_t id]() {
	 if(owner==id) {
		 return EALREADY;
	 } else if(owner==NO_OWNER && call Queue.isEmpty()) {
		 owner = id;
		 return SUCCESS;
	 }
	 return FAIL;
 }
 
 async command error_t SendResource.release[uint8_t id]() {
	 if(owner==id) {
		 atomic owner = NO_OWNER;
		 post grantTask();
		 return SUCCESS;
	 }
	 return FAIL;
 }

 async command bool SendResource.isOwner[uint8_t id]() {
	 return owner==id;
 }
 
 default event void SendResource.granted[uint8_t id]() {
	 call SendResource.release[id]();
 }

}
