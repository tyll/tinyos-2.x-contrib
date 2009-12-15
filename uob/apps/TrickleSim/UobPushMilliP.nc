#include <Timer.h>
#include "TrickleSim.h"

module UobPushMilliP {
  provides {
    interface Init;
    interface UobTrickleTimer as TrickleTimer;
  }
  uses {
    interface Timer<TMilli> as PeriodicIntervalTimer;
    interface Leds;
  }
}
implementation {

  uint32_t period;

  uint32_t generateTime();

  command error_t Init.init() {
    dbg("Trickle", "init()\n");
    period = UOB_PUSH;
    return SUCCESS;
  }

  /**
   * Start a trickle timer. Reset the counter to 0.
   */
  command error_t TrickleTimer.start() {

    dbg("Trickle",
	"%s\tStarting trickle timer in %u\n",
	sim_time_string(),
	period);
    call PeriodicIntervalTimer.startOneShot(period);
    return SUCCESS;
  }

  /**
   * Stop the trickle timer.
   */
  command void TrickleTimer.stop() {
    dbg("Trickle",
	"%s\tStopping trickle timer\n", sim_time_string());
    call PeriodicIntervalTimer.stop();
  }

  /**
   * Reset the timer period to L. If called while the timer is running,
   * then a new interval (of length L) begins immediately.
   */
  command void TrickleTimer.reset() {
    dbg("Trickle",
	"%s\tResetting trickle timer (period %u)\n",
	sim_time_string(),
	period);
    dbg("Trickle",
	"%s\tPush is not doing anything on reset\n");
  }

  command void TrickleTimer.maxInterval() {
    dbg("Trickle",
	"%s\tmaxInterval()\n",
	sim_time_string());
    period = UOB_PUSH;
  }

  command void TrickleTimer.incrementCounter() {
    dbg("Trickle",
	"%s\tincrementCounter()\n",
	sim_time_string());
    dbg("Trickle",
	"%s\tPush is not doing anything on increment\n");
  }

  uint32_t generateTime() {
    dbg("Trickle",
	"%s\tgenerateTime()\n",
	sim_time_string());
    dbg("Trickle",
	"%s\tPush is creating 0 time (should not be used)\n");
    return 0;
  }

  event void PeriodicIntervalTimer.fired() {
    dbg("Trickle",
	"%s\tPeriodicIntervalTimer.fired()\n",
	sim_time_string());

    dbg("Trickle", "%s\tFiring Trickle Event Timer\n",
	sim_time_string());
    dbg("Trickle",
	"%s\tThis is a Push Timer:\n");
    signal TrickleTimer.fired();
    call PeriodicIntervalTimer.startOneShot(period);
  }

}
