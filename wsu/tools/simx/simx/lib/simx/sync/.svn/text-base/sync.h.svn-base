#ifndef SIMX_SYNC_H_INCLUDE
#define SIMX_SYNC_H_INCLUDE

#include <sim_tossim.h>

class SimxSync {
 public:
  SimxSync();
  ~SimxSync();

  int waitUntilNextEvent(long max_wait_msec);
  int runNextEventInTime();
  int runNextEvent();

  sim_time_t simTime();
  sim_time_t realTime();
  void synchronize();

  void setClockMul(float clock_mul);
  float getClockMul();

  void setStopAt(long long int stop_at);
  long long int getStopAt();

  void setMaxWait(long max_wait);
  long getMaxWait();

 private:
  long max_wait_msec;
};

#endif
