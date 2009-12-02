#ifndef TRICKLE_SIM_H
#define TRICKLE_SIM_H

//#define TAU_LOW (1024L)
//#define TAU_HIGH (65535L)

#define TAU_LOW (2L)
#define TAU_HIGH (128L)
#define K 1

typedef nx_struct trickle_sim_msg {
  nx_uint16_t counter;
} trickle_sim_msg_t;

enum {
  AM_TRICKLE_SIM_MSG = 6,
};

#endif
