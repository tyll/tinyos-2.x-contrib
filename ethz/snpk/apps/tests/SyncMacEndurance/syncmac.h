#ifndef SYNCMACTEST_H
#define SYNCMACTEST_H
#include "AM.h"
typedef nx_struct beacon_msg {
  nx_am_addr_t id;
  nx_uint8_t data[10];
} beacon_msg_t;

typedef nx_struct unicast_msg {
  nx_am_addr_t id;	 
  nx_uint8_t data[0];
} unicast_msg_t;

#endif
