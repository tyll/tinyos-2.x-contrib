
#ifndef PRINT_SERIAL_H
#define PRINT_SERIAL_H

#include "message.h"

typedef nx_struct print_counter_reading_msg {
  nx_uint8_t flag;
  nx_uint16_t nodeid;
  nx_uint16_t counter;
  nx_uint16_t voltage_reading;
} print_counter_reading_msg_t;

enum {
  AM_PRINT_COUNTER_READING_MSG = 0x0D,
  FLAG_COUNTER = 0x01,
  FLAG_VOLTAGE_READING  = 0x02,
};

#endif
