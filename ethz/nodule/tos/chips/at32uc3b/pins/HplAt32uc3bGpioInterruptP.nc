/* $Id$ */

/**
 * HPL for the Atmel AT32UC3B microcontroller. This provides an
 * implementation for general-purpose I/O.
 *
 * @author Mustafa Yuecel <mustafa.yuecel@alumni.ethz.ch>
 */

#include "at32uc3b.h"

generic module HplAt32uc3bGpioInterruptP(uint32_t baseport, uint8_t bit)
{
  provides interface HplAt32uc3bGpioInterrupt as Interrupt;
}
implementation
{
  uint32_t counter = 0;

  inline void setBit(uint8_t offset) {
    *((volatile uint32_t *) (baseport + offset)) = (uint32_t) 1 << bit;
  }

  inline bool getBit(uint8_t offset) {
    return (*((volatile uint32_t *) (baseport + offset)) & ((uint32_t) 1 << bit));
  }

  async command error_t Interrupt.enableChangingEdge() {
    atomic {
      setBit(AVR32_GPIO_IMR0C0);
      setBit(AVR32_GPIO_IMR1C0);
      setBit(AVR32_GPIO_IERS0);
      return SUCCESS;
    }
  }
  async command error_t Interrupt.enableRisingEdge() {
    atomic {
      setBit(AVR32_GPIO_IMR0S0);
      setBit(AVR32_GPIO_IMR1C0);
      setBit(AVR32_GPIO_IERS0);
      return SUCCESS;
    }
  }
  async command error_t Interrupt.enableFallingEdge() {
    atomic {
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
      if (!getBit(AVR32_GPIO_IER0))
      {
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

  default async event void Interrupt.fired() { counter++; }
  async command void Interrupt.clear() { setBit(AVR32_GPIO_IFRC0); }
  async command uint32_t Interrupt.getCounter() { return counter; }

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
}
