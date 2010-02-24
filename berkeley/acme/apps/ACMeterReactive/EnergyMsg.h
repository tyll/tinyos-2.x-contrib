#ifndef ENERGYMSG_H_
#define ENERGYMSG_H_

#include <IeeeEui64.h>

enum {
  AM_ENERGYMSG = 8,
};

typedef nx_struct EnergyMsg {
  nx_uint16_t src;
  nx_uint32_t energy;
  nx_uint32_t laenergy;
  nx_uint32_t lvaenergy;
  nx_uint32_t lvarenergy;
  nx_uint8_t  eui64[IEEE_EUI64_LENGTH];
} EnergyMsg_t;

enum {
	AM_SWITCHMSG = 9,
};

typedef nx_struct SwitchMsg {
	nx_uint8_t nodeID;
	nx_uint16_t toggle;
} SwitchMsg_t;

#endif
