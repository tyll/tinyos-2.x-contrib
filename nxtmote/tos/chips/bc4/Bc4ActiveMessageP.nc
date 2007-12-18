// $Id$
/*
 * Copyright (c) 2005-2006 Intel Corporation
 * All rights reserved.
 *
 * This file is distributed under the terms in the attached INTEL-LICENSE     
 * file. If you do not find these files, copies can be found by writing to
 * Intel Research Berkeley, 2150 Shattuck Avenue, Suite 1300, Berkeley, CA, 
 * 94704.  Attention:  Intel License Inquiry.
 */
/**
 * Dummy implementation to support the null platform.
 */
/**
 * Adapted for nxtmote from CC2420 modules.
 * @author Rasmus Pedersen
 */
 
#include "Bc4.h" 
 
module Bc4ActiveMessageP {
  provides {
    interface SplitControl;

    interface AMSend[uint8_t id];
    interface Receive[uint8_t id] ;
    interface Packet;
    interface AMPacket;
    interface PacketAcknowledgements as Acks;
  }
  
  uses {
    interface Send as SubSend;
    interface Receive as SubReceive;
    interface Bc4Packet;
    interface BTAMAddress;
    command am_addr_t amAddress();
interface HalLCD;    
  }
}
implementation {

  enum {
    BC4_SIZE = BC4_HEADER_SIZE + BC4_FOOTER_SIZE
  };

  command error_t SplitControl.start() {
    return SUCCESS;
  }

  command error_t SplitControl.stop() {
    return SUCCESS;
  }

  command error_t AMSend.send[uint8_t id](am_addr_t addr, message_t* msg, uint8_t len) {
    error_t retval;
    bt_addr_t b;

    bc4_header_t* header = call Bc4Packet.getHeader( msg );
    header->type = id;
    header->dest = addr;
    header->destpan = TOS_AM_GROUP;

    if (SUCCESS == call BTAMAddress.amToBT(addr, b)) {
      retval = SUCCESS;
sprintf((char *)lcdstr,"ambt ok %x", addr);
call HalLCD.displayString(lcdstr,4);       
      header->btdest[0] = b[0];
      header->btdest[1] = b[1];
      header->btdest[2] = b[2];
      header->btdest[3] = b[3];
      header->btdest[4] = b[4];
      header->btdest[5] = b[5];
//sprintf((char *)lcdstr,"%X.%X.%X.%X.%X.%X", b[0], b[1], b[2], b[3], b[4], b[5]);
//call HalLCD.displayString(lcdstr,5);
    }
    else {
sprintf((char *)lcdstr,"FAIL %x,", addr);
call HalLCD.displayString(lcdstr,4);       

      retval = FAIL;
    }
    
    memcpy((uint8_t*)header->btsrc, (uint8_t*) call BTAMAddress.getBtAddr(), SIZE_OF_BDADDR);
    header->src = (nxle_uint16_t) call BTAMAddress.btToAM(call BTAMAddress.getBtAddr());
    
    if(retval == SUCCESS)
      retval = call SubSend.send( msg, len + BC4_SIZE );  
    
    return retval; 
  }

  command error_t AMSend.cancel[uint8_t id](message_t* msg) {
    return call SubSend.cancel(msg);
  }

  command uint8_t AMSend.maxPayloadLength[uint8_t id]() {
    return call Packet.maxPayloadLength();
  }

  command void* AMSend.getPayload[uint8_t id](message_t* msg) {
    return call Packet.getPayload(msg, NULL);
  }

  command void Packet.clear(message_t* msg) {
  }

  command uint8_t Packet.payloadLength(message_t* msg) {
    return (call Bc4Packet.getHeader(msg))->length - BC4_SIZE;
  }

  command uint8_t Packet.maxPayloadLength() {
    return TOSH_DATA_LENGTH;
  }

  command void* Packet.getPayload(message_t* msg, uint8_t* len) {
    if (len != NULL) {
      *len = call Packet.payloadLength(msg);
    }
    return msg->data;
  }

  command void Packet.setPayloadLength(message_t* msg, uint8_t len) {
    (call Bc4Packet.getHeader(msg))->length = len + BC4_SIZE;
  }

  command am_addr_t AMPacket.address() {
    return call amAddress();
  }

  command am_addr_t AMPacket.destination(message_t* amsg) {
    bc4_header_t* header = call Bc4Packet.getHeader(amsg);
    return header->dest;
  }

  command bool AMPacket.isForMe(message_t* amsg) {
    return TRUE;
  }

  command am_id_t AMPacket.type(message_t* amsg) {
    bc4_header_t* header = call Bc4Packet.getHeader(amsg);
    return header->type;
  }

  command void AMPacket.setDestination(message_t* amsg, am_addr_t addr) {
    bc4_header_t* header = call Bc4Packet.getHeader(amsg);
    header->dest = addr;
  }

  command void AMPacket.setType(message_t* amsg, am_id_t t) {
    bc4_header_t* header = call Bc4Packet.getHeader(amsg);
    header->type = t;  
  }
  
  command am_addr_t AMPacket.source(message_t *amsg) {
    return 0;
  }
  
  command void AMPacket.setSource(message_t *amsg, am_addr_t addr) {
	}


  command void* Receive.getPayload[uint8_t id](message_t* msg, uint8_t* len) {
    return NULL;
  }

  command uint8_t Receive.payloadLength[uint8_t id](message_t* msg) {
    return 0;
  }

  event void SubSend.sendDone(message_t* msg, error_t result) {
	    signal AMSend.sendDone[call AMPacket.type(msg)](msg, result);
  }
  
  event message_t* SubReceive.receive(message_t* msg, void* payload, uint8_t len) {
    //if (call AMPacket.isForMe(msg)) {
      return signal Receive.receive[call AMPacket.type(msg)](msg, payload, len);// - BC4_SIZE);
    //}
  }

  default event message_t* Receive.receive[am_id_t id](message_t* msg, void* payload, uint8_t len) {
    return msg;
  }

  async command error_t Acks.requestAck( message_t* msg ) {
    return SUCCESS;
  }

  async command error_t Acks.noAck( message_t* msg ) {
    return SUCCESS;
  }

  async command bool Acks.wasAcked(message_t* msg) {
    return FALSE;
  }
}
