/**
 * Implementation of the HplM16c62pTimerBCtrl interface.
 *
 * @author Henrik Makitaavola
 */

#include "M16c62pTimer.h"

generic module HplM16c62pTimerBCtrlP (uint16_t mode_addr)
{
  provides interface HplM16c62pTimerBCtrl as TimerBCtrl;
}
implementation
{
#define mode (*TCAST(volatile uint8_t* ONE, mode_addr))
  async command void TimerBCtrl.setTimerMode(st_timer settings)
  {
    mode = settings.count_src << 6;
  }

  async command void TimerBCtrl.setCounterMode(stb_counter settings)
  {
    mode = 1 | settings.count_polarity << 2 | settings.event_source << 7;
  }
}
