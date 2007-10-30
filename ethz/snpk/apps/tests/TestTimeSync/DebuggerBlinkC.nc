/*
 * Copyright (c) 2007, ETH Zuerich
 * All rights reserved.
 * Author: Min Guo
 */

/* in this application, every mote should periodically (around 10 seconds) blink and generate a trigger at the same time */

#include "Timer.h"

module DebuggerBlinkC
{
  uses interface GlobalTime;
  uses interface Timer<T32khz> as Timer1;
  uses interface Leds;
  uses interface Boot;
  uses interface GeneralIO as Pin;
  uses interface DsnSend;
  uses interface Alarm<T32khz,uint32_t> ;
}
implementation
{

  uint32_t blinkPeriod = 320000;
  uint32_t onPeriod = 16000;

  uint32_t fireTime;
  uint32_t fireTimeLocal;
  uint32_t diffTime; 
  uint32_t localTime;
  uint32_t globalTime;

  event void Boot.booted()
  {
    fireTime =  blinkPeriod;
    fireTimeLocal = fireTime;
    call GlobalTime.global2Local(&fireTimeLocal);
    localTime = call GlobalTime.getLocalTime();
    diffTime = (fireTimeLocal - localTime);
    call Alarm.startAt(localTime, diffTime);
  }

  event void GlobalTime.synced()
  {
    call Alarm.stop();

    call GlobalTime.getGlobalTime(&globalTime);    
    fireTime = (((globalTime / blinkPeriod) + 1) * blinkPeriod);
    fireTimeLocal = fireTime;
    call GlobalTime.global2Local(&fireTimeLocal);
    localTime = call GlobalTime.getLocalTime();

    diffTime = (fireTimeLocal - localTime);
    call Alarm.startAt(localTime, diffTime);
  }


  void task fireAlarm()
  {
    call Timer1.startOneShot(onPeriod);
    
    call GlobalTime.getGlobalTime(&globalTime); 
    fireTime = (((globalTime / blinkPeriod) + 1) * blinkPeriod);

    fireTimeLocal = fireTime;

    call GlobalTime.global2Local(&fireTimeLocal);
    localTime = call GlobalTime.getLocalTime();
    diffTime = (fireTimeLocal - localTime);

    call Alarm.startAt(localTime,diffTime);
  }

  async event void Alarm.fired()
  {
    call Pin.set();
    call Leds.led2On();
    post fireAlarm();
  }
  
  event void Timer1.fired() 
  {
    call Pin.clr();
    call Leds.led2Off();
  }

}

