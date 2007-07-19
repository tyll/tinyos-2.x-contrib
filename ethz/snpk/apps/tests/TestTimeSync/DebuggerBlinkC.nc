/*
 * Copyright (c) 2007, ETH Zuerich
 * All rights reserved.
 * Author: Min Guo
 */

//?? I cant use two T32khz timers?

#include "Timer.h"

module DebuggerBlinkC
{
  uses interface GlobalTime;
  uses interface Timer<T32khz> as Timer1;
  uses interface Timer<T32khz> as Timer2;
  uses interface Leds;
  uses interface Boot;
  uses interface GeneralIO as Pin;
}
implementation
{

  uint32_t blinkPeriod = 320000;
  uint32_t onPeriod = 16000;

  uint32_t fireTime;
  uint32_t fireTimeLocal;
  uint32_t diffTime; 
  uint32_t localTime;

  event void Boot.booted()
  {
/*
    fireTime =  blinkPeriod;
    diffTime = fireTime;
    call Timer2.startOneShot(diffTime);
*/

    fireTime =  blinkPeriod;
    fireTimeLocal = fireTime;
    call GlobalTime.global2Local(&fireTimeLocal);
    localTime = call GlobalTime.getLocalTime();
    diffTime = (fireTimeLocal - localTime);
    call Timer2.startOneShot(diffTime);

  }

  event void GlobalTime.synced()
  {

    call Timer2.stop();

/*
    call GlobalTime.getGlobalTime(&localTime);
    fireTime = (((localTime / blinkPeriod) + 1) * blinkPeriod);

    call GlobalTime.getGlobalTime(&localTime);
    diffTime = (fireTime - localTime);
    call Timer2.startOneShot(diffTime);
*/

    call GlobalTime.getGlobalTime(&localTime);    
    fireTime = (((localTime / blinkPeriod) + 1) * blinkPeriod);
    fireTimeLocal = fireTime;
    call GlobalTime.global2Local(&fireTimeLocal);
    localTime = call GlobalTime.getLocalTime();

    diffTime = (fireTimeLocal - localTime);
    call Timer2.startOneShot(diffTime);



  }

  event void Timer2.fired()
  {
//    dbg("DebuggerBlinkC", "Timer 1 fired @ %s.\n", sim_time_string());

    call Pin.set();
    call Leds.led2On();

//    call Timer1.stop();

    call Timer1.startOneShot(onPeriod);

    fireTime += blinkPeriod;
/*
    call GlobalTime.getGlobalTime(&localTime);
    diffTime = (fireTime - localTime);
    call Timer2.startOneShot(diffTime);
*/

    fireTimeLocal = fireTime;
    call GlobalTime.global2Local(&fireTimeLocal);
    localTime = call GlobalTime.getLocalTime();
    diffTime = (fireTimeLocal - localTime);
    call Timer2.startOneShot(diffTime);

  }
  
  event void Timer1.fired() 
  {
    call Pin.clr();
    call Leds.led2Off();
  }

}

