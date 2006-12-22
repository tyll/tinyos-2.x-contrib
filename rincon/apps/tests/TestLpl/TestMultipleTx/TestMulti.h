
#ifndef TESTMULTI_H
#define TESTMULTI_H

#include "message.h"

typedef nx_struct TestMultiMsg {
  nx_uint8_t myData[TOSH_DATA_LENGTH];
} TestMultiMsg;

enum {
  AM_TESTMULTIMSG = 0x5,
};

#endif

