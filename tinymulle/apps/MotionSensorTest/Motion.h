
#ifndef MOTION_H
#define MOTION_H

typedef nx_struct motion_msg {
  nx_uint16_t data;
} motion_msg_t;

enum {
  AM_MOTION_MSG = 8,
};

#endif
