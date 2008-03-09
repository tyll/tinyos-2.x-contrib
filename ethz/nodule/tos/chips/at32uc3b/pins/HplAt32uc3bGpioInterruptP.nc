/* $Id$ */

/**
 * HPL for the Atmel AT32UC3B microcontroller. This provides an
 * implementation for general-purpose I/O.
 *
 * @author Mustafa Yuecel <mustafa.yuecel@alumni.ethz.ch>
 */

#include "at32uc3b.h"

generic module HplAt32uc3bGpioInterruptP(uint32_t GPIO)
{
  provides interface HplAt32uc3bGpioInterrupt as Interrupt;
  uses interface InterruptController;
}
implementation
{
  uint32_t interrupt_counter = 0;
  bool registered = FALSE;

  inline void setBit(uint8_t offset) {
    get_register(get_avr32_gpio_baseaddress(GPIO) + offset) = (uint32_t) 1 << get_avr32_gpio_bit(GPIO);
  }

  inline bool getBit(uint8_t offset) {
    return (get_register(get_avr32_gpio_baseaddress(GPIO) + offset) & ((uint32_t) 1 << get_avr32_gpio_bit(GPIO)));
  }

  inline void clear_gpio_interrupt_flag() {
    setBit(AVR32_GPIO_IFRC0);
  }

  void _gpio_interrupt_handler() {
    signal Interrupt.fired();
    interrupt_counter++;
    clear_gpio_interrupt_flag();
  }

  inline void register_gpio_interrupt_handler() {
    if (!registered) {
      call InterruptController.registerGpioInterruptHandler(GPIO, &_gpio_interrupt_handler);
      registered = TRUE;
    }
  }

  async command error_t Interrupt.enableChangingEdge() {
    atomic {
      register_gpio_interrupt_handler();
      setBit(AVR32_GPIO_IMR0C0);
      setBit(AVR32_GPIO_IMR1C0);
      setBit(AVR32_GPIO_IERS0);
      return SUCCESS;
    }
  }

  async command error_t Interrupt.enableRisingEdge() {
    atomic {
      register_gpio_interrupt_handler();
      setBit(AVR32_GPIO_IMR0S0);
      setBit(AVR32_GPIO_IMR1C0);
      setBit(AVR32_GPIO_IERS0);
      return SUCCESS;
    }
  }

  async command error_t Interrupt.enableFallingEdge() {
    atomic {
      register_gpio_interrupt_handler();
      setBit(AVR32_GPIO_IMR0C0);
      setBit(AVR32_GPIO_IMR1S0);
      setBit(AVR32_GPIO_IERS0);
      return SUCCESS;
    }
  }

  async command error_t Interrupt.disable() {
    setBit(AVR32_GPIO_IERC0);
    return SUCCESS;
  }

  async command bool Interrupt.isInterruptEnabled() { return getBit(AVR32_GPIO_IER0); }

  async command uint8_t Interrupt.getInterruptMode() {
    atomic {
      if (!getBit(AVR32_GPIO_IER0)) {
        return AVR32_GPIO_INTERRUPT_MODE_DISABLED;
      }

      if (getBit(AVR32_GPIO_IMR00)) {
        // x1
        if (getBit(AVR32_GPIO_IMR10)) {
          // 11
          return AVR32_GPIO_INTERRUPT_MODE_RESERVED;
        }
        else {
          // 01
          return AVR32_GPIO_INTERRUPT_MODE_RISING_EDGE;
        }
      }
      else {
        // x0
        if (getBit(AVR32_GPIO_IMR10)) {
          // 10
          return AVR32_GPIO_INTERRUPT_MODE_FALLING_EDGE;
        }
        else {
          // 00
          return AVR32_GPIO_INTERRUPT_MODE_CHANGING_EDGE;
        }
      }
    }
  }

  default async event void Interrupt.fired() { }

  async command error_t Interrupt.enableGlitchFilter() {
    atomic {
      if (getBit(AVR32_GPIO_IER0)) {
        return FAIL;
      }

      setBit(AVR32_GPIO_GFERS0);

      return SUCCESS;
    }
  }

  async command error_t Interrupt.disableGlitchFilter() {
    atomic {
      if (getBit(AVR32_GPIO_IER0)) {
        return FAIL;
      }

      setBit(AVR32_GPIO_GFERC0);

      return SUCCESS;
    }
  }

  async command bool Interrupt.isGlitchFilterEnabled() { return getBit(AVR32_GPIO_GFER0); }

  async command uint32_t Interrupt.getCounter() {
    return interrupt_counter;
  }
}
