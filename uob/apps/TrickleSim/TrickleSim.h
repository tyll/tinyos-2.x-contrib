#ifndef TRICKLE_SIM_H
#define TRICKLE_SIM_H

//   2 * 1024
#define UOB_TAU_LOW (2048L)
// 128 * 1024
#define UOB_TAU_HIGH (131072L)

#define UOB_K 1
//#define UOB_K 2

//#define PUSH 1

//  40 * 1024 -> same cycle count
#define UOB_PUSH (40960L)

typedef nx_struct trickle_sim_msg {
  nx_uint16_t sender;
  nx_uint16_t counter;
} trickle_sim_msg_t;

enum {
  AM_TRICKLE_SIM_MSG = 6,
};

#endif
