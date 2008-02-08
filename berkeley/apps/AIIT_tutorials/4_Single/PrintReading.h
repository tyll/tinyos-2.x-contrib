
#ifndef PRINT_SERIAL_H
#define PRINT_SERIAL_H

#include "message.h"

typedef nx_struct print_reading_msg {
  nx_uint8_t flag;
  nx_uint8_t buffer[TOSH_DATA_LENGTH - 5];
  nx_uint16_t voltage_reading;
  nx_uint16_t temperature_reading;
} print_reading_msg_t;

enum {
  AM_PRINT_READING_MSG = 0x0B,
  FLAG_BUFFER           = 0x01,
  FLAG_VOLTAGE_READING  = 0x02,
  FLAG_TEMPERATURE_READING = 0X04,
};

#endif
