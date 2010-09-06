#ifndef BTTESTER_H
#define BTTESTER_H
#include "bluetooth.h"
#ifndef FLUREC_SIZE
#define FLUREC_SIZE 20
#endif
typedef struct flurec_t {
  bool occupied;
  bdaddr_t baddr;
  uint32_t start;
  uint32_t end;
  bool dropped;
} flurec_t;
enum {
  AM_FLUREC_T = 42,
  AM_BASEADDR = 0xff,
};
#endif /* BTTESTER_H */
