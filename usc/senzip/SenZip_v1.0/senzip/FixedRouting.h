/*
 * @ author        Sundeep Pattem
 * @ affiliation   Autonomous Networks Research Group
 * @ institution   University of Southern California
*/

#ifndef FIXEDROUTING_H
#define FIXEDROUTING_H

enum {
  AM_FIXRT_MSG = 29,
};

typedef nx_struct fixrt_msg { 
  nx_uint8_t type;
  nx_uint16_t parent;
  nx_uint8_t numHops;
} FixRtMsg;

#endif