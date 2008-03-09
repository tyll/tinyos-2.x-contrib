/* $Id$ */

/* @author Mustafa Yuecel <mustafa.yuecel@alumni.ethz.ch> */

#include "at32uc3b.h"

module TestButtonC
{
  uses interface Boot;
  uses interface Leds;
  uses interface SystemLed;

  uses interface Button as Button1;
  uses interface Button as Button2;
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

    call Button1.enable();
    call Button2.enable();

    for (;;)
    {
      delay(1000);
    }
  }

  async event void Button1.pressed()
  {
    // make interrupt visible
    call Leds.led0Toggle();
  }

  async event void Button2.pressed()
  {
    // make interrupt visible
    call Leds.led1Toggle();
  }
}
