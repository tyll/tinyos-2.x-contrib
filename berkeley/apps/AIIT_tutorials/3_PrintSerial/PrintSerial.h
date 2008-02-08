
#ifndef PRINT_SERIAL_H
#define PRINT_SERIAL_H

#include "message.h"

typedef nx_struct print_serial_msg {
  //nx_uint16_t counter;
  nx_uint8_t buffer[TOSH_DATA_LENGTH];
} print_serial_msg_t;

enum {
  AM_PRINT_SERIAL_MSG = 0x0A,
};

#endif
