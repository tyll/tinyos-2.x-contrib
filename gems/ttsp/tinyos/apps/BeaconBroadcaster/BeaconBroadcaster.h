#ifndef BEACONBROADCAST_H
#define BEACONBROADCAST_H

typedef nx_struct BeaconMsg {
  nx_uint16_t srcAddr;
  nx_uint32_t beaconId;
} BeaconMsg_t;

enum {
	AM_BEACONMSG = 181
};

#endif