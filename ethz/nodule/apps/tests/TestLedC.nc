/* $Id$ */

/* @author Mustafa Yuecel <mustafa.yuecel@alumni.ethz.ch> */

module TestLedC
{
  uses interface Boot;
  uses interface Leds;
  uses interface SystemLed;
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
  }
}
