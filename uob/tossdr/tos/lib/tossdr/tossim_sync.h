#ifndef TOSSIM_SYNC_H_INCLUDE
#define TOSSIM_SYNC_H_INCLUDE

#include <sim_tossdr.h>

class TossimSync {
 public:
  TossimSync();
  ~TossimSync();

  void waitUntilNextEvent();
  void runNextEventInTime();

  bool waitUntilNextEvent_NoGil();
  bool runNextEvent_NoGil();

  sim_time_t simTime();
  sim_time_t realTime();
  sim_time_t syncTime();
  void syncTo(sim_time_t time);
  void syncToNow();
};

#endif
