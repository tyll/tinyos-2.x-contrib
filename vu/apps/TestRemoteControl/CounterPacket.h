#ifndef __COUNTERPACKET_H__
#define __COUNTERPACKET_H__
#include "message.h"

typedef nx_struct counter_packet
{
	nx_uint16_t src;
	nx_uint8_t unique_delimiter[0];	// zero-sized field marking the end of the unique section
	nx_uint8_t cnt;

} counter_packet_t;

enum {
  APPID_COUNTER = 0x77,
};

#endif // __COUNTERPACKET_H__
