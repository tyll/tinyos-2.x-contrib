/* $Id$ */

/* @author Mustafa Yuecel <mustafa.yuecel@alumni.ethz.ch> */

#include "at32uc3b.h"

module TestUartStreamC
{
  uses interface Boot;
  uses interface Leds;
  uses interface SystemLed;

  uses interface Init as UartStreamInit;
  uses interface UartStream;

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
    call Leds.led2On();

    call Button1.enable();
    call Button2.enable();

    call UartStreamInit.init();

    call UartStream.send((uint8_t *) "hello world!\r\n", 14);

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

  async event void UartStream.sendDone(uint8_t * buf, uint16_t len, error_t error) {
    // visible sign if transfer is successfully done
    if (error == SUCCESS && len == 14)
    {
      call Leds.led2Off();
      call UartStream.send((uint8_t *) "hello world!\r\n", 14);
    }
  }

  async event void UartStream.receivedByte(uint8_t byte) { }
  async event void UartStream.receiveDone(uint8_t * buf, uint16_t len, error_t error) { }
}
