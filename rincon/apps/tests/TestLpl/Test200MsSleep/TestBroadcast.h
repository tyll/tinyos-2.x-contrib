
#ifndef TESTSYNC_H
#define TESTSYNC_H

typedef nx_struct TestBroadcastMsg {
  nx_uint8_t count;
} TestBroadcastMsg;

enum {
  AM_TESTSYNCMSG = 0x5,
};

#endif

