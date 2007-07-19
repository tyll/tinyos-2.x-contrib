/*
 * Copyright (c) 2007, ETH Zuerich
 * All rights reserved.
 * Author: Min Guo
 */

configuration HilTimerT32khzC
{
  provides interface Init;
  provides interface Timer<T32khz> as TimerT32khz[ uint8_t num ];
}
implementation
{
  components new Alarm32khz32C();
  components new AlarmToTimerC(T32khz);
  components new VirtualizeTimerC(T32khz,uniqueCount(UQ_TIMER_32KHZ)) as NVir;

  Init = Alarm32khz32C;
  TimerT32khz = NVir;

  NVir.TimerFrom -> AlarmToTimerC;
  AlarmToTimerC.Alarm -> Alarm32khz32C;
}

