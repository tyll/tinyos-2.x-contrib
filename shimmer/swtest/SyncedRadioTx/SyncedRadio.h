#ifndef SYNCED_TIMING_H
#define SYNCED_TIMING_H 

#include "AM.h"

typedef nx_struct simple_send_msg {
  nx_uint16_t counter;
  nx_uint8_t message[TOSH_DATA_LENGTH - 2];   // 114 bytes - 2 byte counter 
} simple_send_msg_t;

enum {
   BASE_STATION_ADDRESS = 0,
   AM_SYNCED_TIMING_MSG = 0x7F,
};

#endif
