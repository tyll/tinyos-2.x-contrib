/* $Id$ */

/**
 * HPL for the Atmel AT32UC3B microcontroller. This provides an
 * implementation for general-purpose I/O.
 *
 * @author Mustafa Yuecel <mustafa.yuecel@alumni.ethz.ch>
 */

#include "at32uc3b.h"

generic module HplAt32uc3bGeneralIOP(uint32_t GPIO)
{
  provides interface HplAt32uc3bGeneralIO as IO;
}
implementation
{
  inline void setBit(uint8_t offset) {
    get_register(get_avr32_gpio_baseaddress(GPIO) + offset) = (uint32_t) 1 << get_avr32_gpio_bit(GPIO);
  }

  inline bool getBit(uint8_t offset) {
    return (get_register(get_avr32_gpio_baseaddress(GPIO) + offset) & ((uint32_t) 1 << get_avr32_gpio_bit(GPIO)));
  }

  async command void IO.set() { setBit(AVR32_GPIO_OVRS0); }
  async command void IO.clr() { setBit(AVR32_GPIO_OVRC0); }
  async command void IO.toggle() { setBit(AVR32_GPIO_OVRT0); }

  async command bool IO.get() { return getBit(AVR32_GPIO_PVR0); }

  async command void IO.makeInput() { setBit(AVR32_GPIO_ODERC0); }
  async command bool IO.isInput() { return !getBit(AVR32_GPIO_ODER0); }
  async command void IO.makeOutput() { setBit(AVR32_GPIO_ODERS0); }
  async command bool IO.isOutput() { return getBit(AVR32_GPIO_ODER0); }

  async command void IO.selectPeripheralFuncA() {
    atomic {
      setBit(AVR32_GPIO_PMR0C0);
      setBit(AVR32_GPIO_PMR1C0);
      setBit(AVR32_GPIO_GPERC0);
    }
  }
  async command void IO.selectPeripheralFuncB() {
    atomic {
      setBit(AVR32_GPIO_PMR0S0);
      setBit(AVR32_GPIO_PMR1C0);
      setBit(AVR32_GPIO_GPERC0);
    }
  }
  async command void IO.selectPeripheralFuncC() {
    atomic {
      setBit(AVR32_GPIO_PMR0C0);
      setBit(AVR32_GPIO_PMR1S0);
      setBit(AVR32_GPIO_GPERC0);
    }
  }
  async command void IO.selectPeripheralFunc(uint8_t function) {
    switch (function) {
      case AVR32_GPIO_PERIPHERAL_FUNC_A:
        call IO.selectPeripheralFuncA();
        break;
      case AVR32_GPIO_PERIPHERAL_FUNC_B:
        call IO.selectPeripheralFuncB();
        break;
      case AVR32_GPIO_PERIPHERAL_FUNC_C:
        call IO.selectPeripheralFuncC();
        break;
      default:
        break;
    }
  }
  async command bool IO.isPeripheralFunc() { return !getBit(AVR32_GPIO_GPER0); }
  async command uint8_t IO.getPeripheralFunc() {
    atomic {
      if (getBit(AVR32_GPIO_GPER0))
      {      
        return AVR32_GPIO_PERIPHERAL_FUNC_DISABLED;
      }

      if (getBit(AVR32_GPIO_PMR00)) {
        // x1
        if (getBit(AVR32_GPIO_PMR10)) {
          // 11
          return AVR32_GPIO_PERIPHERAL_FUNC_D;
        }
        else {
          // 01
          return AVR32_GPIO_PERIPHERAL_FUNC_B;
        }
      }
      else {
        // x0
        if (getBit(AVR32_GPIO_PMR10)) {
          // 10
          return AVR32_GPIO_PERIPHERAL_FUNC_C;
        }
        else {
          // 00
          return AVR32_GPIO_PERIPHERAL_FUNC_A;
        }
      }
    }
  }
  async command void IO.selectIOFunc() { setBit(AVR32_GPIO_GPERS0); }
  async command bool IO.isIOFunc() { return getBit(AVR32_GPIO_GPER0); }

  async command void IO.enablePullup() { setBit(AVR32_GPIO_PUERS0); }
  async command void IO.disablePullup() { setBit(AVR32_GPIO_PUERC0); }
  async command bool IO.isPullup() { return getBit(AVR32_GPIO_PUER0); }

  async command void IO.enableOpenDrain() { setBit(AVR32_GPIO_ODMERS0); }
  async command void IO.disableOpenDrain() { setBit(AVR32_GPIO_ODMERC0); }
  async command bool IO.isOpenDrain() { return getBit(AVR32_GPIO_ODMER0); }
}
