#ifndef TESTDRIVER_H_
#define TESTDRIVER_H_

enum {
  AM_TESTDRIVER_MSG = 1,
};

enum {
  TEST_PING = 1,
  TEST_CLEAR = 2,
  TEST_OFF = 3,
  TEST_ON = 4,
};

nx_struct testdriver_msg {
  nx_uint8_t cmd;
  nx_uint8_t addr[16];
  nx_uint16_t n;
  nx_uint16_t dt;
};

#endif
