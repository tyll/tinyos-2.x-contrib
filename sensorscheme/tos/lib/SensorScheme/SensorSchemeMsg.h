#ifndef SENSORSCHEMEMSG_H
#define SENSORSCHEMEMSG_H


#include "message.h"

typedef nx_struct sensorscheme_msg {
  nx_uint8_t sequence;
  nx_uint8_t data[TOSH_DATA_LENGTH-sizeof(nx_uint8_t)];
} sensorscheme_msg_t;

enum {
  AM_SENSORSCHEME_MSG = 43,
  ACK_SENSORSCHEME_MSG = 44,
};


#endif // SENSORSCHEMEMSG_H
