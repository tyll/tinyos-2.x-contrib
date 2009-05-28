/*
   When included into a TOSSIM application this module will allow
   using the C++/Python TossimSync interface run simulation events in
   "real-world" time.

   !!Assumes sim_time_t is in nano-seconds.
*/

#ifdef __cplusplus
extern "C" {
#endif

#include <sys/time.h>
#include <time.h>
#include <stdio.h>
#include <errno.h>

#include <sim_tossdr.h>
#include <sim_event_queue.h>

/* Automatically set on first invocation of wait_until_real_time() */
sim_time_t sync_start_time = 0;

/* Static compensation for overhead/resolution limitations. It would
   be really neat if this adjusted dynamically... */
#define SKIP_TIME 3000000ULL

/*
  Return real-world time.
*/
sim_time_t sim_get_real_time() {
  struct timeval tv;
  if(gettimeofday(&tv, NULL) == 0) {
    return (sim_time_t)tv.tv_sec * sim_ticks_per_sec() +
      (sim_time_t)tv.tv_usec * 10000;
  } else { /* failure */
    perror("gettimeofday() failed");
    return 0;
  }
}

sim_time_t sim_get_sync_start() {
  return sync_start_time;
}

void sim_set_sync_start(sim_time_t time) {
  sync_start_time = time;
}

/*
  Synchronize the with current world time. This takes into account how
  long the simulator has been running to sync. right back up.
*/
void sim_sync_start_to_now() {
  sim_set_sync_start(sim_get_real_time() - sim_time());
}

/*
  Wait until "real time" is >= event_time ("sim time").
*/
static void sim_wait_until_real_time(sim_time_t event_time) {
  struct timespec req;
  sim_time_t wait_time;

  if (sync_start_time == 0)
    sim_sync_start_to_now();

  wait_time = event_time - (sim_get_real_time() - sync_start_time) - SKIP_TIME;

  /* event now or in the past, run (right) away! */
  if (wait_time <= 0)
    return;
  /* there should be a way to clean up these conversion */
  /* and what is with the /10? */
  req.tv_sec = wait_time / sim_ticks_per_sec();
  req.tv_nsec = (wait_time - req.tv_sec * sim_ticks_per_sec()) / 10;
WAITMORE:
  if (nanosleep(&req, &req) == -1) {
    /* this might be better handled with a re-computation of the
       real time remaining: it could be a long interruption --
       nanosleep modifies req (2nd arg). */
    if (EINTR == errno)
	goto WAITMORE;
    else
      perror("nanosleep() failed");
  }
}

/*
   Run the next TOSSIM event at the correct "real world" time (or
   pretty darn close to it). If the event is in the past in runs
   right away.

   The queue pop and insert are slightly ugly but, using this
   approach removes the need to modify or use sim_run_next_event()
   code. The overhead the operation adds is NOT SIGNIFICANT, but it
   MAY change the order of events.
*/
bool sim_wait_until_next_event() {
  sim_event_t* evt;
  if (sim_queue_is_empty())
    return 0;
  evt = sim_queue_pop();
  //fprintf(stderr, "sync_impl %x\n", evt), fflush(stderr);
  sim_queue_insert(evt);
  //fprintf(stderr, "wait until %d\n", evt->time), fflush(stderr);
  sim_wait_until_real_time(evt->time);
  return 1;
}

#ifdef __cplusplus
}
#endif

