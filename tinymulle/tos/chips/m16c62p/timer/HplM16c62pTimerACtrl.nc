/**
 * Interface for controlling the mode of a TimerA.
 *
 * @author Henrik Makitaavola
 */

#include "M16c62pTimer.h"

interface HplM16c62pTimerACtrl
{
  /**
   * Sets the timer to timer mode.
   *
   * @param settings The settings for the timer mode.
   */
  async command void setTimerMode(st_timer settings);

  /**
   * Sets the timer to counter mode.
   *
   * @param settings The settings for the counter mode.
   */
  async command void setCounterMode(sta_counter settings);

  /**
   * Sets the timer to one-shot mode.
   *
   * @param settings The settings for the one-shot mode.
   */
  async command void setOneShotMode(sta_one_shot settings);
  
  /**
   * Starts the timer if in one-shot mode.
   */
  async command void oneShotFire();
}
