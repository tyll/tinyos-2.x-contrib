/* $Id$ */

/* @author Mustafa Yuecel <mustafa.yuecel@alumni.ethz.ch> */

#include "at32uc3b.h"
#include "interrupt.h"

module TestButtonC
{
  uses interface Boot;
  uses interface Leds;
  uses interface SystemLed;

  uses interface GeneralIO as Button1;
  uses interface HplAt32uc3bGpioInterrupt as InterruptButton1;
  uses interface GeneralIO as Button2;
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

  // initialize all interrupts with priority 0
  void init_interrupts()
  {
    uint32_t regval;
    uint8_t irq;
    extern void _evba;
    extern void _int0;

    regval = (&_int0 - &_evba);
    for (irq = 0; irq < AVR32_INTC_NUM_INT_GRPS; irq += 4)
    {
      _address(AVR32_INTC_ADDRESS + irq) = regval;
    }

    avr32_clr_global_interrupt_mask();
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

    init_interrupts();

    call InterruptButton1.enableFallingEdge();

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

      delay(1000);
    }
  }

  async event void InterruptButton1.fired() { }

  void __attribute__((C, spontaneous)) handle_interrupt(int interrupt_level)
  {
    // make interrupt visible
    call Leds.led0Toggle();
    // clear interrupt flag
    call InterruptButton1.clear();
  }
}
