
#ifndef PRINT_SERIAL_H
#define PRINT_SERIAL_H

#include "message.h"

typedef nx_struct counter_msg {
  nx_uint16_t nodeid;
  nx_uint16_t counter;
} counter_msg_t;

enum {
  AM_COUNTER_MSG = 0x10,
};

#endif
