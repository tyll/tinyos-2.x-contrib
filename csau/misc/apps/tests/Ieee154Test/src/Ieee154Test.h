#ifndef IEEE154TEST_H
#define IEEE154TEST_H

#include "message.h"

enum {
	AM_TEST_MSG = 10,
#ifdef TOSSIM
	SENDER_ID = 0,
	RECEIVER_ID = 1,
#else
	SENDER_ID = 2,
	RECEIVER_ID = 3,
#endif
};

typedef nx_struct test_msg {
	nx_uint8_t data[TOSH_DATA_LENGTH];
} test_msg_t;

#endif
