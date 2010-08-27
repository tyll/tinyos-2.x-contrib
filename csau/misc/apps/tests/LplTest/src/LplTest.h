#ifndef LPLTEST_H
#define LPLTEST_H

#include "message.h"
#include "AM.h"

enum {
  AM_LPLTEST_MSG = 10,
};

typedef nx_struct lpltest_msg {
	nx_uint32_t seqno;
  nx_uint8_t values[TOSH_DATA_LENGTH-sizeof(nx_uint32_t)];
} lpltest_msg_t;

#endif


