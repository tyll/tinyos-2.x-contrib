#include "Timer.h"
#include "ProbeTest.h"

module ProbeTestC {
  uses {
    interface Boot;
    interface Timer<TMilli>;
  }
}

implementation {
  static void startTimer();

  int event_count;

  unsigned char nx_struct_data[sizeof(nx_varied_struct_t)];
  unsigned char nx_union_data[sizeof(nx_varied_union_t)];

  event void Boot.booted() {
    // prevent elimination of data-structures through optimization
    nx_struct_data[0] = 0;
    nx_union_data[0] = 0;

    event_count = 0;

    call Timer.startPeriodic(1024);
  }

  event void Timer.fired() {
    /* On each timer event, ODD nodes are updated. EVEN nodes are
       never updated. The updating is relatively simple and consistent
       so it can be verified. */
    nx_varied_struct_t *vs = (nx_varied_struct_t*)nx_struct_data;
    event_count += 1;
    if (TOS_NODE_ID & 1) { // odd node
      long v = TOS_NODE_ID * event_count;
      vs->int8 = v;
      vs->uint8 = v;
      vs->int16 = v;
      vs->uint16 = v;
      vs->int32 = v;
      vs->uint32 = v;
    }
  }

}
