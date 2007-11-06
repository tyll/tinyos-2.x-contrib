#ifndef __TESTMSG_H
#define __TESTMSG_H

typedef nx_struct TestMsg
{
	nx_uint8_t payload[5];
} TestMsg;

enum { AM_TESTMSG = 101 };

#endif /* __TESTMSG_H */
