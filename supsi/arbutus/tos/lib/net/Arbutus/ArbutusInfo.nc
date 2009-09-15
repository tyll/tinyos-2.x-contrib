

#include "AM.h"

interface ArbutusInfo {

 
  
  command uint16_t get_originaddr(message_t *msg);
  command uint16_t get_originalSequenceNumber(message_t *msg);
  command uint16_t get_packetTransmissions(message_t *msg);
  command uint16_t get_totalOwnTraffic(message_t *msg);
  command uint16_t get_totalRelayedTraffic(message_t *msg);
  command uint8_t  get_hopcount(message_t *msg);



  
}
