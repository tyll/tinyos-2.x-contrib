/* $Id$ */

/* @author Mustafa Yuecel <mustafa.yuecel@alumni.ethz.ch> */

#include "at32uc3b.h"

// target address of the interrupt handler is calculated as 
// (EVBA | handler_offset), not (EVBA + handler_offset)!!!

module InterruptControllerC
{
  provides interface Init;
  provides interface InterruptController;
}
implementation
{
//  void * gpio_interrupt_handlers;
  void * gpio_interrupt_handlers[AVR32_GPIO_NUMBER_OF_PINS];
  uint32_t gpio_index;

  void __attribute__((C, spontaneous, interrupt, section(".interrupt"))) _gpio_interrupt_handler()
  {
    uint32_t gpio;
    void (*gpio_interrupt_handler)();

    // call registered callback function of the GpioInterrupt implementation

    while ((gpio = __builtin_clz(get_register(AVR32_GPIO_PORTA_BASEADDRESS + AVR32_GPIO_IFR0))) != 32)
    {
      atomic { gpio_interrupt_handler = gpio_interrupt_handlers[31 - gpio]; }
      gpio_interrupt_handler();
    }
 
    while ((gpio = __builtin_clz(get_register(AVR32_GPIO_PORTB_BASEADDRESS + AVR32_GPIO_IFR0))) != 32)
    {
      atomic { gpio_interrupt_handler = gpio_interrupt_handlers[63 - gpio]; }
      gpio_interrupt_handler();
    }
  }

  inline void gpio_init_interrupt()
  {
    extern void _evba;

    get_register(AVR32_INTC_ADDRESS + (AVR32_INTC_INTGROUP_GPIO << 2)) =
      ((AVR32_INTC_INTLEVEL_GPIO << AVR32_INTC_INTLEVEL_OFFSET) | ((void *) &_gpio_interrupt_handler - (void *) &_evba));
  }

  command error_t Init.init()
  {
    uint32_t regval;
    uint8_t irq;
    extern void _evba;
    extern void _int;

    // initialize all interrupts with lowest priority (3)
    regval = ((AVR32_INTC_INTLEVEL_DEFAULT << AVR32_INTC_INTLEVEL_OFFSET) | (&_int - &_evba));
    for (irq = 0; irq < AVR32_INTC_NUM_INT_GRPS; irq++)
    {
      get_register(AVR32_INTC_ADDRESS + (irq << 2)) = regval;
    }

    gpio_init_interrupt();

    return SUCCESS;
  }

  async command void InterruptController.registerGpioInterruptHandler(uint32_t gpio, void * handler)
  {
//    gpio_interrupt_handlers = handler;
    gpio_interrupt_handlers[gpio] = handler;
    gpio_index = gpio;
  }
}
