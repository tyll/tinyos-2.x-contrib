
#include "Ctp.h"

module CtpRoutingPacketP {
  provides {
    interface CtpRoutingPacket;
  }
  
  uses {
    interface Packet;
  }
}

implementation {

  /***************** Functions ****************/
  ctp_routing_header_t *getHeader(message_t *m) {
    return (ctp_routing_header_t*) call Packet.getPayload(m, call Packet.maxPayloadLength());
  }

  /***************** CtpRoutingPacket Commands ***************/
  command bool CtpRoutingPacket.getOption(message_t* msg, ctp_options_t opt) {
    return ((getHeader(msg)->options & opt) == opt);
  }

  command void CtpRoutingPacket.setOption(message_t* msg, ctp_options_t opt) {
    getHeader(msg)->options |= opt;
  }

  command void CtpRoutingPacket.clearOption(message_t* msg, ctp_options_t opt) {
    getHeader(msg)->options &= ~opt;
  }

  command void CtpRoutingPacket.clearOptions(message_t* msg) {
    getHeader(msg)->options = 0;
  }
  
  command am_addr_t CtpRoutingPacket.getParent(message_t* msg) {
    return getHeader(msg)->parent;
  }
  
  command void CtpRoutingPacket.setParent(message_t* msg, am_addr_t addr) {
    getHeader(msg)->parent = addr;
  }
  
  command uint16_t CtpRoutingPacket.getEtx(message_t* msg) {
    return getHeader(msg)->etx;
  }
  
  command void CtpRoutingPacket.setEtx(message_t* msg, uint8_t etx) {
    getHeader(msg)->etx = etx;
  }
  
  
}

