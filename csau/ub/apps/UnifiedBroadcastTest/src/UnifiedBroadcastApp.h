
/**
 * @author Morten Tranberg Hansen <mth at cs dot au dot dk>
 * @date   June 6 2010
 */

#ifndef UNIFIEDBROADCASTAPP_H
#define UNIFIEDBROADCASTAPP_H

#include "AM.h"

#ifndef TOSSIM
#include "CC2420.h"
#include "CC2420TimeSyncMessage.h"
#endif

typedef struct test_msg {
  nx_uint32_t counter;
  nx_uint32_t timestamp;
} test_msg_t;

#endif


