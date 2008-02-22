#ifndef SYNCMACTEST_H
#define SYNCMACTEST_H
#include "AM.h"
#ifndef SYNCMAC_MIN_NEIGHBOURS
#define SYNCMAC_MIN_NEIGHBOURS 3
#endif
typedef nx_struct beacon_msg {
  nx_am_addr_t id;
  nx_uint8_t data[10];
} beacon_msg_t;

typedef nx_struct unicast_msg {
  nx_am_addr_t id;	 
  nx_uint8_t data[10];
} unicast_msg_t;

#endif
