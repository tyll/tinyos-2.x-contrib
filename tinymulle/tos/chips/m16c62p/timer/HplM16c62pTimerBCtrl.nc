/**
* Interface for controlling the mode of a TimerB.
* Precaution when using timer mode, read M16c62pTimer.h for more information.
*
* @author Henrik Makitaavola
*/

#include "M16c62pTimer.h"

interface HplM16c62pTimerBCtrl
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
  async command void setCounterMode(stb_counter settings);
}
