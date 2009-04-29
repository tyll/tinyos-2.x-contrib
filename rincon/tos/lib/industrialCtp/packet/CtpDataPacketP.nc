
#include "Ctp.h"

/**
 * @author Philip Levis
 * @author Kyle Jamieson
 * @author David Moss
 */

module CtpDataPacketP {
  provides {
    interface CtpPacket;
    interface Packet;
  }
  
  uses {
    interface Packet as SubPacket;
  }
}

implementation {
  
  /***************** Functions ****************/
  ctp_data_header_t *getHeader(message_t* m) {
    return (ctp_data_header_t*) call SubPacket.getPayload(m, sizeof(ctp_data_header_t));
  }
  
  /***************** Packet Commands ****************/
  command void Packet.clear(message_t* msg) {
    call SubPacket.clear(msg);
  }
  
  command uint8_t Packet.payloadLength(message_t* msg) {
    return call SubPacket.payloadLength(msg) - sizeof(ctp_data_header_t);
  }

  command void Packet.setPayloadLength(message_t* msg, uint8_t len) {
    call SubPacket.setPayloadLength(msg, len + sizeof(ctp_data_header_t));
  }
  
  command uint8_t Packet.maxPayloadLength() {
    return call SubPacket.maxPayloadLength() - sizeof(ctp_data_header_t);
  }

  command void* Packet.getPayload(message_t* msg, uint8_t len) {
    uint8_t* payload = call SubPacket.getPayload(msg, len + sizeof(ctp_data_header_t));
    if (payload != NULL) {
      payload += sizeof(ctp_data_header_t);
    }
    return payload;
  }
  
  
  /***************** CtpPacket Commands ****************/
  command uint8_t CtpPacket.getType(message_t* msg) {
    return getHeader(msg)->type;
  }
  
  command am_addr_t CtpPacket.getOrigin(message_t* msg) {
    return getHeader(msg)->origin;
  }
  
  command uint16_t CtpPacket.getEtx(message_t* msg) {
    return getHeader(msg)->etx;
  }
  
  command uint8_t CtpPacket.getSequenceNumber(message_t* msg) {
    return getHeader(msg)->originSeqNo;
  }
   
  command uint8_t CtpPacket.getThl(message_t* msg) {
    return getHeader(msg)->thl;
  }
  
  command void CtpPacket.setThl(message_t* msg, uint8_t thl) {
    getHeader(msg)->thl = thl;
  }
  
  command void CtpPacket.setOrigin(message_t* msg, am_addr_t addr) {
    getHeader(msg)->origin = addr;
  }
  
  command void CtpPacket.setType(message_t* msg, uint8_t id) {
    getHeader(msg)->type = id;
  }

  command bool CtpPacket.option(message_t* msg, ctp_options_t opt) {
    return ((getHeader(msg)->options & opt) == opt);
  }

  command void CtpPacket.setOption(message_t* msg, ctp_options_t opt) {
    getHeader(msg)->options |= opt;
  }
  
  command void CtpPacket.clearOption(message_t* msg, ctp_options_t opt) {
    getHeader(msg)->options &= ~opt;
  }

  command void CtpPacket.setEtx(message_t* msg, uint16_t etx) {
    getHeader(msg)->etx = etx;
  }
  
  command void CtpPacket.setSequenceNumber(message_t* msg, uint8_t seqno) {
    getHeader(msg)->originSeqNo = seqno;
  }
  
  command bool CtpPacket.matchInstance(message_t* m1, message_t* m2) {
    return (call CtpPacket.getOrigin(m1) == call CtpPacket.getOrigin(m2) &&
            call CtpPacket.getSequenceNumber(m1) == call CtpPacket.getSequenceNumber(m2) &&
            call CtpPacket.getThl(m1) == call CtpPacket.getThl(m2) &&
            call CtpPacket.getType(m1) == call CtpPacket.getType(m2));
  }

  command bool CtpPacket.matchPacket(message_t* m1, message_t* m2) {
    return (call CtpPacket.getOrigin(m1) == call CtpPacket.getOrigin(m2) &&
            call CtpPacket.getSequenceNumber(m1) == call CtpPacket.getSequenceNumber(m2) &&
            call CtpPacket.getType(m1) == call CtpPacket.getType(m2));
  }
  
}
