#include <Python.h>

#include "tossim_sync.h"

extern "C" {
  bool sim_run_next_event();
  bool sim_wait_until_next_event();

  sim_time_t sim_get_real_time();
  sim_time_t sim_get_sync_start();
  void sim_set_sync_start(sim_time_t);
  void sim_sync_start_to_now();
}

TossimSync::TossimSync() {}
TossimSync::~TossimSync() {}

void TossimSync::waitUntilNextEvent() {
  Py_BEGIN_ALLOW_THREADS;
  this->waitUntilNextEvent_NoGil();
  Py_END_ALLOW_THREADS;
}

void TossimSync::runNextEventInTime() {
  this->waitUntilNextEvent();
  this->runNextEvent_NoGil();
}

bool TossimSync::waitUntilNextEvent_NoGil() {
  return sim_wait_until_next_event();
}

/* runNextEventInTime() is implemented in SWIG interface */
bool TossimSync::runNextEvent_NoGil() {
  return sim_run_next_event();
}

sim_time_t TossimSync::simTime() {
  return sim_time();
}

sim_time_t TossimSync::realTime() {
  return sim_get_real_time();
}

sim_time_t TossimSync::syncTime() {
  return sim_get_sync_start();
}

void TossimSync::syncTo(sim_time_t time) {
  sim_set_sync_start(time);
}

void TossimSync::syncToNow() {
  sim_sync_start_to_now();
}
