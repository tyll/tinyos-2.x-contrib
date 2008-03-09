/* $Id$ */

/* @author Mustafa Yuecel <mustafa.yuecel@alumni.ethz.ch> */

#include "at32uc3b.h"

// target address of the interrupt handler is calculated as 
// (EVBA | handler_offset), not (EVBA + handler_offset)!!!

module InterruptControllerC
{
  provides {
    interface Init;
    interface InterruptController;
  }
}
implementation
{
  void * gpio_interrupt_handlers[AVR32_GPIO_NUMBER_OF_PINS];
  bool gpio_initialized = FALSE;
  void * pdca_interrupt_handlers[AVR32_PDCA_CHANNEL_LENGTH];
  bool pdca_initialized = FALSE;

  void __attribute__((C, interrupt, section(".interrupt"))) _gpio_interrupt_handler() {
    uint8_t gpio;
    void (*gpio_interrupt_handler)();

    // call registered callback function of the GpioInterrupt implementation

    while ((gpio = __builtin_ctz(get_register(AVR32_GPIO_PORTA_BASEADDRESS + AVR32_INTC_INTGROUP_GPIO_REQ_OFFSET))) != 32) {
      atomic gpio_interrupt_handler = gpio_interrupt_handlers[gpio];
      gpio_interrupt_handler();
    }
 
    while ((gpio = __builtin_ctz(get_register(AVR32_GPIO_PORTB_BASEADDRESS + AVR32_INTC_INTGROUP_GPIO_REQ_OFFSET))) != 32) {
      atomic gpio_interrupt_handler = gpio_interrupt_handlers[gpio + 32];
      gpio_interrupt_handler();
    }
  }

  inline void gpio_init_interrupt() {
    extern void _evba;

    get_register(AVR32_INTC_ADDRESS + (AVR32_INTC_INTGROUP_GPIO << 2)) =
      ((AVR32_INTC_INTLEVEL_GPIO << AVR32_INTC_INTLEVEL_OFFSET) | (uint32_t) ((void *) &_gpio_interrupt_handler - (void *) &_evba));
  }

  async command void InterruptController.registerGpioInterruptHandler(uint8_t gpio, void * handler) {
    atomic {
      if (!gpio_initialized) {
        gpio_init_interrupt();
        gpio_initialized = TRUE;
      }

      gpio_interrupt_handlers[gpio] = handler;
    }
  }

  void __attribute__((C, interrupt, section(".interrupt"))) _pdca_interrupt_handler() {
    uint8_t pdca;
    void (*pdca_interrupt_handler)();

    // call registered callback function

    while ((pdca = __builtin_ctz(get_register(AVR32_INTC_ADDRESS + AVR32_INTC_INTGROUP_PDCA_REQ_OFFSET))) != 32) {
      atomic pdca_interrupt_handler = pdca_interrupt_handlers[pdca];
      pdca_interrupt_handler();
    }
  }

  inline void pdca_init_interrupt() {
    extern void _evba;

    get_register(AVR32_INTC_ADDRESS + (AVR32_INTC_INTGROUP_PDCA << 2)) =
      ((AVR32_INTC_INTLEVEL_PDCA << AVR32_INTC_INTLEVEL_OFFSET) | (uint32_t) ((void *) &_pdca_interrupt_handler - (void *) &_evba));
  }

  async command void InterruptController.registerPdcaInterruptHandler(uint8_t pdca, void * handler) {
    atomic {
      if (!pdca_initialized) {
        pdca_init_interrupt();
        pdca_initialized = TRUE;
      }

      pdca_interrupt_handlers[pdca] = handler;
    }
  }

  async command void InterruptController.registerUsartInterruptHandler(uint8_t usart, void * handler) {
    extern void _evba;

    get_register(AVR32_INTC_ADDRESS + (get_avr32_intc_intgroup_usart(usart) << 2)) =
      ((get_avr32_intc_intlevel_usart(usart) << AVR32_INTC_INTLEVEL_OFFSET) | (uint32_t) (handler - (void *) &_evba));
  }

  command error_t Init.init() {
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

    return SUCCESS;
  }
}
