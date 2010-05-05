#ifndef HOTMAC_H
#define HOTMAC_H

#include <Ieee154.h>

typedef enum {
  S_IDLE = 0,
  S_RECEIVE,
  S_TRANSMIT,
  S_OFF, 
} hotmac_state_t;

nx_struct hotmac_beacon {
  nx_uint8_t  network;
  nx_uint16_t period;           /* how often our receive checks are */
  nx_uint16_t cwl;              /* the number of contention slots   */
};

struct hotmac_neigh_entry {
  ieee154_saddr_t neigh;
  uint16_t phase;
  uint16_t period;
  uint8_t lsn;

  // bit fields
  uint8_t valid:1;
  uint8_t pinned:1;             /* possible to evict */

  uint8_t lru:4;
};

enum {
  HOTMAC_6LOWPAN_NETWORK = 0xff,

  // shortest amount to wait after receiving an ACK to a probe before
  // transmitting another probe.

  // has to be long enough so that any packets sent in response to
  // this probe have enough time to finish transmission, about 4ms for
  // a 127 byte packet.

  // this also determines the window you have to get out a second
  // packet, for the streaming optimization

  // jiffies
  HOTMAC_POSTPROBE_WAIT   = 20 << 5,

  // the length of a SIFS contention slot, in jiffies.  
  // this is about 1ms.
  HOTMAC_CWIN_SIZE        = 0x1F,

  HOTMAC_NEIGHBORTABLE_SZ = 4,

  // jiffies
  HOTMAC_DEFAULT_CHECK_PERIOD = 512L << 5,

  // how long to wait for a beacon each time we wake up.  this is
  // probably also the largest time you want to go between polling the
  // channel.
  // jiffies
  HOTMAC_SEND_TIMEOUT = (HOTMAC_DEFAULT_CHECK_PERIOD * 5) / 2, // (HOTMAC_DEFAULT_CHECK_PERIOD >> 5) + 35,

  // how long to wake up before a beacon is scheduled, to turn on the
  // radio and load the packet.  actual time on a telosb seems to be around 144 jiffies
  // jiffies
  HOTMAC_WAKEUP_LOAD_TIME = 160, // 45 << 5,
  
  // once awake to send a beacon, if we have to wait more then this
  // amount assume we missed the slot we were going for.
  // jiffies
  HOTMAC_WAKEUP_TOO_LONG = HOTMAC_WAKEUP_LOAD_TIME,

  // we'll wake up extra early just to
  // make sure we don't miss it due to getting delayed by other tasks,
  // drift, or loading the FIFO.
  // jiffies
  HOTMAC_GUARD_TIME = 100,
  
  // 
  HOTMAC_DELIVERY_ATTEMPTS = 0,

};

#endif
