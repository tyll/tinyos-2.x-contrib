/* $Id$ */

/* @author Mustafa Yuecel <mustafa.yuecel@alumni.ethz.ch> */

module TestButtonC
{
  uses interface Boot;
  uses interface Leds;
  uses interface SystemLed;

  uses interface GeneralIO as Button1;
  uses interface GeneralIO as Button2;
}
implementation
{
  static void delay(uint32_t cycles)
  {
    while (--cycles > 0)
    {
      asm("nop");
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

    delay(1000);

    for (;;)
    {
      if (call Button1.get())
      {
        call Leds.led1Off();
      }
      else
      {
        call Leds.led1On();
      }

      if (call Button2.get())
      {
        call Leds.led2Off();
      }
      else
      {
        call Leds.led2On();
      }

      delay(100);
    }
  }
}
