/*
 * Copyright (c) 2007, ETH Zuerich
 * All rights reserved.
 * Author: Min Guo
 */

configuration DebuggerBlinkAppC
{
}
implementation
{
  components MainC, DebuggerBlinkC, TimeSyncC, LedsC;
  components new TimerT32khzC() as Timer1;
  components new Alarm32khz32C();
  components PlatformPINC;

  DebuggerBlinkC -> MainC.Boot;
  
  DebuggerBlinkC.GlobalTime -> TimeSyncC;
  DebuggerBlinkC.Timer1 -> Timer1;
  DebuggerBlinkC.Leds -> LedsC;
  DebuggerBlinkC.Pin -> PlatformPINC;
  DebuggerBlinkC.Alarm -> Alarm32khz32C;

  components DSNC;
  DebuggerBlinkC.DsnSend->DSNC;
}

