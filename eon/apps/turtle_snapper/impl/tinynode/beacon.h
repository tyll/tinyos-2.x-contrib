#ifndef BEACON_H_
#define BEACON_H_

//#define BEACON_COUNT     2L
//#define BEACON_COUNT     0L /* This means one beacon */
// BEACON COUNT is now deprecated.  Only send one -mdc

#define BEACON_IVAL  1000L

#define ACTIVE_IVAL 2000L
#define ACTIVE_PRE  333L
#define ACTIVE_WND  333L
#define ACTIVE_MAX  (ACTIVE_IVAL - ACTIVE_WND - ACTIVE_PRE)

#endif
