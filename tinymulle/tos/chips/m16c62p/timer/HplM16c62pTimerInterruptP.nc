/**
 * All timer interrupt vector handlers.
 * These are wired in HplM16c62pTimerC.
 *
 * @author Henrik Makitaavola
 */

module HplM16c62pTimerInterruptP @safe()
{
  provides interface HplM16c62pTimerInterrupt as TimerA0;
  provides interface HplM16c62pTimerInterrupt as TimerA1;
  provides interface HplM16c62pTimerInterrupt as TimerA2;
  provides interface HplM16c62pTimerInterrupt as TimerA3;
  provides interface HplM16c62pTimerInterrupt as TimerA4;
  provides interface HplM16c62pTimerInterrupt as TimerB0;
  provides interface HplM16c62pTimerInterrupt as TimerB1;
  provides interface HplM16c62pTimerInterrupt as TimerB2;
  provides interface HplM16c62pTimerInterrupt as TimerB3;
  provides interface HplM16c62pTimerInterrupt as TimerB4;
  provides interface HplM16c62pTimerInterrupt as TimerB5;
}
implementation
{
  default async event void TimerA0.fired() { } 
  M16C_INTERRUPT_HANDLER(M16C_TMRA0)
  {
    signal TimerA0.fired();
  }

  default async event void TimerA1.fired() { } 
  M16C_INTERRUPT_HANDLER(M16C_TMRA1)
  {
    signal TimerA1.fired();
  }

  default async event void TimerA2.fired() { } 
  M16C_INTERRUPT_HANDLER(M16C_TMRA2)
  {
    signal TimerA2.fired();
  }

  default async event void TimerA3.fired() { } 
  M16C_INTERRUPT_HANDLER(M16C_TMRA3)
  {
    signal TimerA3.fired();
  }

  default async event void TimerA4.fired() { } 
  M16C_INTERRUPT_HANDLER(M16C_TMRA4)
  {
    signal TimerA4.fired();
  }

  default async event void TimerB0.fired() { } 
  M16C_INTERRUPT_HANDLER(M16C_TMRB0)
  {
    signal TimerB0.fired();
  }

  default async event void TimerB1.fired() { } 
  M16C_INTERRUPT_HANDLER(M16C_TMRB1)
  {
    signal TimerB1.fired();
  }

  default async event void TimerB2.fired() { } 
  M16C_INTERRUPT_HANDLER(M16C_TMRB2)
  {
    signal TimerB2.fired();
  }

  default async event void TimerB3.fired() { } 
  M16C_INTERRUPT_HANDLER(M16C_TMRB3)
  {
    signal TimerB3.fired();
  }

  default async event void TimerB4.fired() { } 
  M16C_INTERRUPT_HANDLER(M16C_TMRB4)
  {
    signal TimerB4.fired();
  }

  default async event void TimerB5.fired() { } 
  M16C_INTERRUPT_HANDLER(M16C_TMRB5)
  {
    signal TimerB5.fired();
  }

}
