#include "sync.h"

#include <Python.h>

extern "C" {
  /* from TOSSIM */
  bool sim_run_next_event();
  /* sync_impl.c */
  int sync_set_clock_mul(float);
  float sync_get_clock_mul();
  void sync_set_stop_at(sim_time_t);
  sim_time_t sync_get_stop_at();
  sim_time_t sync_get_real_time();
  void sync_synchronize();
  int sync_event_wait(long, int, int);
}

SimxSync::SimxSync() {
  this->max_wait_msec = 25;
  sync_synchronize();
}
SimxSync::~SimxSync() {}

/*
 * NOTE:: Releases the Python GIL.
 */
int SimxSync::waitUntilNextEvent(long max_wait_msec) {
  int result;
  Py_BEGIN_ALLOW_THREADS;
  result = sync_event_wait(max_wait_msec, 1, 0);
  Py_END_ALLOW_THREADS;
  return result;
}

/*
 * Returns 0 if no events were executed in timeout period, -1 if the
 * simulation is stopped due to "stop at" being exceeded, or a
 * positive value if an event was executed.
 */
int SimxSync::runNextEventInTime() {
  int res = this->waitUntilNextEvent(this->max_wait_msec);
  if (res > 0) { /* possibly an event to run */
    return sim_run_next_event();
  } else {
    return res;
  }
}

int SimxSync::runNextEvent() {
  return sim_run_next_event();
}

sim_time_t SimxSync::simTime() {
  return sim_time();
}

sim_time_t SimxSync::realTime() {
  return sync_get_real_time();
}

void SimxSync::synchronize() {
  sync_synchronize();
}

void SimxSync::setClockMul(float clock_mul) {
  sync_set_clock_mul(clock_mul);
}

float SimxSync::getClockMul() {
  return sync_get_clock_mul();
}

void SimxSync::setStopAt(long long int stop_at) {
  sync_set_stop_at(stop_at);
}

long long int SimxSync::getStopAt() {
  return sync_get_stop_at();
}

void SimxSync::setMaxWait(long max_wait_msec) {
  this->max_wait_msec = max_wait_msec;
}

long SimxSync::getMaxWait() {
  return this->max_wait_msec;
}
