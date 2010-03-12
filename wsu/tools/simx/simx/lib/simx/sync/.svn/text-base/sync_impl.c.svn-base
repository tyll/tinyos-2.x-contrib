/*
 * Bridge to allow TOSSIM applications to run simulation events "in
 * real-world" time.
 *
 * WARNING:: It is assumed that sim_time_t is a small multiple of a
 * nano-second (10 by default). Adjust TICKS_PER_NSEC below as needed.
 */

#ifdef __cplusplus
extern "C" {
#endif
#if 0
}
#endif

#include <sys/time.h>
#include <time.h>
#include <stdio.h>
#include <errno.h>

#include <sim_tossim.h>
#include <sim_event_queue.h>

/* watch out the C -- explicit widen */
#define K (1000LL)
#define NSEC_PER_SEC   (K * K * K)
#define MSEC_PER_NSEC  (K * K)
#define USEC_PER_NSEC  (K)
#define TICKS_PER_NSEC 10
#define TICKS_PER_SEC  (NSEC_PER_SEC * TICKS_PER_NSEC)

#define SECS_TO_TICKS(sec) ((sim_time_t)(sec) * TICKS_PER_SEC)
#define MSEC_TO_NSEC(ms)   ((sim_time_t)(ms) * MSEC_PER_NSEC)
#define MSEC_TO_TICKS(ms)  (MSEC_TO_NSEC(ms) * TICKS_PER_NSEC)
#define USEC_TO_NSEC(us)   ((sim_time_t)(us) * USEC_PER_NSEC)
#define USEC_TO_TICKS(us)  (USEC_TO_NSEC(us) * TICKS_PER_NSEC)

/*
 * Minimum time to sleep in nanosecods. This can avoid a nanosleep
 * system call and may be beneficial when many events are pooled very
 * close together.
 *
 * WARNING: Because this 'pools events' it prevents real-world time
 * pacing and and prohibits forced advancement. Thus, the value should
 * be kept relatively small.
 */
#define MIN_SLEEP_TIME USEC_TO_NSEC(500)

sim_time_t sync_time = 0;    /* real-world time of last sync. */
sim_time_t sync_simtime = 0; /* simtime of last sync. */
sim_time_t stop_at = 0;      /* if non zero, max time to run until */
long double clock_mul = 1;   /* clock multiplier, high res. for mul */

/*
 * Return real-world time in "ticks".
 */
sim_time_t sync_get_real_time() {
  struct timeval tv;
  if(gettimeofday(&tv, NULL) == 0) {
    return SECS_TO_TICKS(tv.tv_sec) + USEC_TO_TICKS(tv.tv_usec);
  } else {
    perror("gettimeofday() failed");
    return 0;
  }
}

/*
 * Synchronize with the current time. This is used to control pacing
 * in sync_event_wait.  It should be called whenever a simulation
 * enters a "running mode" and before the invokation of
 * sync_event_wait.
 */
void sync_synchronize() {
  sync_time = sync_get_real_time();
  sync_simtime = sim_time();
}

/*
 * Set the clock multiplier and synchronize the simulation time. If a
 * multiplier of 0 (or less) is specified sync_wait_event fast-returns
 * (as time can not be advanced).
 */
void sync_set_clock_mul(float new_clock_mul) {
  if (new_clock_mul > 0) {
    sync_synchronize();
  }
  clock_mul = new_clock_mul;
}

float sync_get_clock_mul() {
  return clock_mul;
}

/*
 * Sets the "stop at" time. sync_event_wait can be instructed to honor
 * this value and keep the simulation from advancing past a certain
 * simulation time.
 *
 * A value of 0 disables the "stop at" feature.
 */
void sync_set_stop_at(sim_time_t new_stop_at) {
  stop_at = new_stop_at;
}

sim_time_t sync_get_stop_at() {
  return stop_at;
}


/*
 * Waits for the specified amount of nano-seconds, reporting and then
 * ignoring interruptions. Returns 0 on success.
 */
int wait_uninterrupted (long long int wait_nsec) {    
  struct timespec req;
  
  req.tv_sec = wait_nsec / NSEC_PER_SEC;
  req.tv_nsec = wait_nsec - (long long int)req.tv_sec * NSEC_PER_SEC;

  while (nanosleep(&req, &req) == -1) {
    /* nanosleep modifies 2nd arg. */
    if (EINTR == errno) {
      perror("nanosleep() interrupted");
    } else {
      perror("nanosleep() failed");
      return -1;
    }
  }
  return 0;
}

/*
 * Wait from now to target with a max wait of max_wait_nsec. `now' and
 * `target' represent REAL WORLD TIME, in ticks. All values must be
 * non-negative.
 *
 * Returns 1 if, after the wait, the target time was reached or is in
 * within some delta of the current time. Otherwise 0 is returned.
 */
static int sync_wait_until(sim_time_t now, sim_time_t target,
                           long max_wait_msec) {
  if (target <= now) {
    /* target is now or in past */
    return 1;
  } else {
    /* event in future */
    sim_time_t wait_nsec = (target - now) / TICKS_PER_NSEC;
  
    if (wait_nsec <= MIN_SLEEP_TIME) {
      /* wait period too small */
      return 1;
    } else if (MSEC_TO_NSEC(max_wait_msec) < wait_nsec) {
      /* timeout before event */
      wait_uninterrupted(MSEC_TO_NSEC(max_wait_msec));
      return 0;
    } else {
      /* wait full */
      wait_uninterrupted(wait_nsec);
      return 1;
    }
  }
}

/*
 * Run the next TOSSIM event at the correct pacing according the clock
 * multiplier (see sync_set_clock_mul) while not proceeding past the
 * stop-at time (see sync_set_stop_at). If the next event is now, or
 * in the past, no waiting occurs.
 *
 * max_wait_msec specifies the maximum real-world time to wait, in
 * milliseconds. It should be >= 0.
 *
 * If force_advance is non-0 then, even if there were no real events
 * during the timeout period, the simulation time will be
 * advanced. This keeps the simulation time from "falling behind"
 * during periods of no-events.
 *
 * If ignore_stop_at is non-0 then the stop_at time will be
 * ignored. Otherwise, is stop_at is not 0, the simulation will be
 * prohibited from running past the stop-at time.
 *
 * Returns 0 if there is no event to process, -1 if at stop time (and
 * no events to process), or 1 if there is an event to process now.
 *
 * If the clock_mul is disabled then 1 will be returned if there is an
 * event on the queue, 0 otherwise.
 */
int sync_event_wait(long max_wait_msec,
                    int force_advance,
                    int ignore_stop_at) {
  int stop_check = !ignore_stop_at && stop_at;
  sim_time_t target = sim_queue_peek_time();

  if (stop_check && stop_at <= sim_time()) {
    /* quick-path when stopped */
    return stop_at < 0 || stop_at != target ? -1 : 1;
  } else if (clock_mul <= 0) {
    /* quick-path for no clock-mul */
    return target >= 0;
  } else {
    sim_time_t since_sync = sync_get_real_time() - sync_time;
    sim_time_t wait_to = sync_simtime + (since_sync * clock_mul);
    int result;

    /* don't wait past stop at time */
    /* stop_at > sim_time(), from quick-path above */
    if (stop_check && wait_to > stop_at) {
      wait_to = stop_at;
    }

    if (max_wait_msec < 0) {
      fprintf(stderr, "sync_event_wait: invalid max_wait_msec\n");
      max_wait_msec = 0;
    }
  
    result = sync_wait_until(wait_to, target, max_wait_msec);
  
    if (!result && force_advance) {
      sim_time_t force_to = sim_time() +
        (MSEC_TO_TICKS(max_wait_msec) * clock_mul);
      /* don't advance past stop at time */
      /* stop_at > sim_time(), from quick-path above */
      if (stop_check && force_to > stop_at) {
        force_to = stop_at;
      }
      /* force_to > sim_time() since max_wait_msec >= 0 by above */
      sim_set_time(force_to);
      /* result = 0 from conditional guard */
    }

    return result;
  }
}

#ifdef __cplusplus
}
#endif

