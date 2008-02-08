
#ifndef PRINT_SERIAL_H
#define PRINT_SERIAL_H

#include "message.h"

enum {
  AM_REQUEST_READING_MSG = 0x0F,
  FLAG_COUNTER = 0x01,
  FLAG_VOLTAGE_READING  = 0x02,
  FLAG_TEMPERATURE_READING  = 0x04,
  FLAG_TEXT = 0x08,
  MAX_TEXT_LENGTH = 18,
};

typedef nx_struct request_reading_msg {
  nx_uint8_t flag;
  nx_uint16_t nodeid;
  nx_uint16_t counter;
  nx_uint16_t voltage_reading;
  nx_uint16_t temperature_reading;
  nx_uint8_t buffer[MAX_TEXT_LENGTH];
} request_reading_msg_t;

#endif
