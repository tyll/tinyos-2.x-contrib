#ifndef TOSSIM_RADIO_MSG_H
#define TOSSIM_RADIO_MSG_H

#include "AM.h"

typedef nx_struct tossim_header {
  nx_am_addr_t dest;
  nx_am_addr_t src;
  nx_uint8_t length;
  nx_am_group_t group;
  nx_am_id_t type;
} tossim_header_t;

typedef nx_struct tossim_footer {
  nxle_uint16_t crc;  
} tossim_footer_t;

typedef nx_struct tossim_metadata {
  nx_int8_t strength;
  nx_uint8_t ack;
  nx_uint16_t time;
} tossim_metadata_t;

typedef nx_struct SYN_packet {
  nx_uint16_t packet_type;
  nx_int16_t node_id;
  nx_uint16_t next_sleep_time;
  nx_uint16_t sleep_period;
} SYN_packet_t;


typedef nx_struct RTS_packet {
  nx_uint16_t packet_type;
  nx_int16_t src_id;  
  nx_int16_t dest_id;  
  nx_uint16_t duration;
} RTS_packet_t;


typedef nx_struct CTS_packet {
  nx_uint16_t packet_type;
  nx_int16_t src_id;  
  nx_int16_t dest_id;
  nx_uint16_t duration;
} CTS_packet_t;


typedef nx_struct data_packet {
  nx_uint16_t packet_type;
  nx_uint8_t payload[16];
} data_packet_t;

typedef nx_struct FRTS_packet {
  nx_uint16_t packet_type;
  nx_int16_t src_id;  
  nx_int16_t dest_id;  
  nx_uint16_t duration;
} FRTS_packet_t;


typedef nx_struct DS_packet {
  nx_uint16_t packet_type;
  nx_int16_t src_id;  
  nx_int16_t dest_id;  
  nx_uint16_t duration;
} DS_packet_t;



typedef nx_struct preamble_packet { 
  nx_uint16_t packet_type;
  nx_uint16_t dest_id;
  nx_uint8_t seq_no;
} preamble_packet_t;


#endif
