#ifndef SENZIPAPP_H
#define SENZIPAPP_H

#define BASE_ID 127
#define SINK_NODE_ID 0
#define NUM_MEASUREMENTS 3
#define SAMPLE_PERIOD 2000

enum {
  AM_BASE_MSG = 37,
};

enum {
  START = 1,
};

typedef nx_struct base_msg {
  nx_int16_t data[NUM_MEASUREMENTS];
  nx_uint8_t type;
  nx_uint8_t src;
  nx_uint8_t parent;
  nx_uint8_t seq;
  nx_int16_t max;
  nx_int16_t min;
} base_msg_t;

#endif
