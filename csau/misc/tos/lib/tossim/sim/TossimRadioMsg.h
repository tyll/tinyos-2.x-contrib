#ifndef TOSSIM_RADIO_MSG_H
#define TOSSIM_RADIO_MSG_H

#include "AM.h"

typedef nx_struct tossim_header {
	nx_am_addr_t dest;
  nx_am_addr_t src;
  nx_uint8_t length;
  nx_am_group_t group;
  nx_am_id_t type;
	nx_uint8_t dsn;  
} tossim_header_t;

typedef nx_struct tossim_footer {
  nxle_uint16_t crc;  
} tossim_footer_t;

typedef nx_struct tossim_metadata {
  nx_int8_t strength;
  nx_uint8_t ack;
  nx_uint16_t time;
#ifdef LOW_POWER_LISTENING
  nx_uint16_t rxInterval;
#endif
#ifdef PACKET_LINK
  nx_uint16_t maxRetries;
  nx_uint16_t retryDelay;
#endif
} tossim_metadata_t;

#endif
