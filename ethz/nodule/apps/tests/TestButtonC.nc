/* $Id$ */

/* @author Mustafa Yuecel <mustafa.yuecel@alumni.ethz.ch> */

#include "at32uc3b.h"

module TestButtonC
{
  uses interface Boot;
  uses interface Leds;
  uses interface SystemLed;

  uses interface GeneralIO as Button1;
  uses interface GpioInterrupt as InterruptButton1;
  uses interface GeneralIO as Button2;
  uses interface GpioInterrupt as InterruptButton2;
}
implementation
{
  static void delay(uint32_t cycles)
  {
    while (--cycles > 0)
    {
      nop();
    }
  }

  event void Boot.booted()
  {
    call Leds.led0On();
    delay(500);
    call Leds.led1On();
    delay(500);
    call Leds.led2On();
    delay(500);
    call Leds.led0Off();
    delay(500);
    call Leds.led1Off();
    delay(500);
    call Leds.led2Off();

    delay(1000);

    call SystemLed.on();

    call InterruptButton1.enableFallingEdge();
    call InterruptButton2.enableFallingEdge();

    for (;;)
    {
      delay(1000);
    }

  }

  async event void InterruptButton1.fired()
  {
    // make interrupt visible
    call Leds.led0Toggle();
  }

  async event void InterruptButton2.fired()
  {
    // make interrupt visible
    call Leds.led1Toggle();
  }
}
