/* $Id$ */

/* @author Mustafa Yuecel <mustafa.yuecel@alumni.ethz.ch> */

interface InterruptController
{
  async command void registerGpioInterruptHandler(uint8_t gpio, void * handler);

  async command void registerPdcaInterruptHandler(uint8_t pdca, void * handler);

  /* USART handler must tagged with __attribute__((interrupt, section(".interrupt"))) */
  async command void registerUsartInterruptHandler(uint8_t usart, void * handler);
}
