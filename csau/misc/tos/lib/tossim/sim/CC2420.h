#ifndef __CC2420_H__
#define __CC2420_H__

#include "Ieee154.h"

#ifndef CC2420_DEF_CHANNEL
#define CC2420_DEF_CHANNEL 26
#endif

/**
 * Ideally, your receive history size should be equal to the number of
 * RF neighbors your node will have
 */
#ifndef RECEIVE_HISTORY_SIZE
#define RECEIVE_HISTORY_SIZE 4
#endif


#define MAX_LPL_CCA_CHECKS 7
#define LPL_CCA_DELAY 1

enum {
	DELAY_AFTER_CCA = 1,
};

typedef nx_uint32_t timesync_radio_t;

enum cc2420_enums {
  CC2420_TIME_ACK_TURNAROUND = 7, // jiffies
  CC2420_TIME_VREN = 20,          // jiffies
  CC2420_TIME_SYMBOL = 2,         // 2 symbols / jiffy
  CC2420_BACKOFF_PERIOD = ( 20 / CC2420_TIME_SYMBOL ), // symbols
  CC2420_MIN_BACKOFF = ( 20 / CC2420_TIME_SYMBOL ),  // platform specific?
  CC2420_ACK_WAIT_DELAY = 256,    // jiffies
};

#endif
