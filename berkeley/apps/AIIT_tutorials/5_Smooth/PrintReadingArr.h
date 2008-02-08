
#ifndef PRINT_READING_ARR_H
#define PRINT_READING_ARR_H

#include "message.h"

enum {
  AM_PRINT_READING_ARR_MSG = 0x0C,
  MAX_READINGS = 5,
  SMOOTH_FACTOR = 3,
  DENOMINATOR = 10,
};

typedef nx_struct print_reading_arr_msg {
  nx_uint16_t nodeid;
  nx_uint16_t min;
  nx_uint16_t max;
  nx_uint16_t mean;
  nx_uint16_t raw_reading[MAX_READINGS]; 
  nx_uint16_t smooth_reading[MAX_READINGS]; 
} print_reading_arr_msg_t;

#endif
