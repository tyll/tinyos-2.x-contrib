#ifndef REFBROADCAST_H
#define REFBROADCAST_H

typedef nx_struct ReferenceMsg {
  nx_uint16_t srcAddr;
  nx_uint32_t refTimestamp;
  nx_uint32_t refId;
} ReferenceMsg_t;

enum {
	AM_REFERENCEMSG = 180
};

#endif