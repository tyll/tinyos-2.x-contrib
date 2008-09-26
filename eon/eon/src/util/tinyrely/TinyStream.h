#include "TinyRely.h"

#ifndef TINYSTREAM_H_INCLUDED
#define TINYSTREAM_H_INCLUDED


#ifndef TS_BUF_LENGTH
#define TS_BUF_LENGTH   200
#endif

typedef struct TSStr {
  bool lock;
  bool valid;
  bool sending;
  uint8_t uid;
  uint8_t txdata[TS_BUF_LENGTH];
  uint8_t rxdata[TS_BUF_LENGTH];
  uint16_t txhead;
  uint16_t txtail;
  uint16_t rxhead;
  uint16_t rxtail;
} TSStr;


#endif
