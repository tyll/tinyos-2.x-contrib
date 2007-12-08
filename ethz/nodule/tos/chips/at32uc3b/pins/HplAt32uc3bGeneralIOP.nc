/* $Id$ */

/**
 * HPL for the Atmel AT32UC3B microcontroller. This provides an
 * implementation for general-purpose I/O.
 *
 * @author Mustafa Yuecel <mustafa.yuecel@alumni.ethz.ch>
 */

#include <stdint.h>
#include <avr32/io.h>
#include "at32uc3b.h"

generic module HplAt32uc3bGeneralIOP(uint32_t baseport, uint8_t bit)
{
  provides interface HplAt32uc3bGeneralIO as IO;
}
implementation
{
  inline void setBit(uint8_t offset) {
    *((volatile uint32_t *) (baseport + offset)) = (uint32_t) 1 << bit;
  }

  inline bool getBit(uint8_t offset) {
    return (*((volatile uint32_t *) (baseport + offset)) & ((uint32_t) 1 << bit));
  }

  async command void IO.set() { setBit(AVR32_GPIO_OVRS0); }
  async command void IO.clr() { setBit(AVR32_GPIO_OVRC0); }
  async command void IO.toggle() { setBit(AVR32_GPIO_OVRT0); }
  async command bool IO.get() { return getBit(AVR32_GPIO_PVR0); }
  async command void IO.makeInput() { setBit(AVR32_GPIO_ODERC0); }
  async command bool IO.isInput() { return !getBit(AVR32_GPIO_ODER0); }
  async command void IO.makeOutput() { setBit(AVR32_GPIO_ODERS0); }
  async command bool IO.isOutput() { return getBit(AVR32_GPIO_ODER0); }
  async command void IO.selectPeripheralFunc() { setBit(AVR32_GPIO_GPERC0); }
  async command bool IO.isPeripheralFunc() { return !getBit(AVR32_GPIO_GPER0); }
  async command void IO.setPeripheralFunc(peripheral_func_enum_t peripheral_func) {
    atomic {
      switch (peripheral_func) {
        case (GPIO_PERIPHERAL_FUNC_A):
        {
          setBit(AVR32_GPIO_PMR0C0);
          setBit(AVR32_GPIO_PMR1C0);
          break;
        }
        case (GPIO_PERIPHERAL_FUNC_B):
        {
          setBit(AVR32_GPIO_PMR0S0);
          setBit(AVR32_GPIO_PMR0C0);
          break;
        }
        case (GPIO_PERIPHERAL_FUNC_C):
        {
          setBit(AVR32_GPIO_PMR0C0);
          setBit(AVR32_GPIO_PMR1S0);
          break;
        }
        case (GPIO_PERIPHERAL_FUNC_D):
        {
          setBit(AVR32_GPIO_PMR0S0);
          setBit(AVR32_GPIO_PMR1S0);
          break;
        }
      }
    }
  }
  async command peripheral_func_enum_t IO.getPeripheralFunc() {
    atomic {
      if (getBit(AVR32_GPIO_PMR00)) {
        // x1
        if (getBit(AVR32_GPIO_PMR10)) {
          // 11
          return GPIO_PERIPHERAL_FUNC_D;
        }
        else {
          // 01
          return GPIO_PERIPHERAL_FUNC_B;
        }
      }
      else {
        // x0
        if (getBit(AVR32_GPIO_PMR10)) {
          // 10
          return GPIO_PERIPHERAL_FUNC_C;
        }
        else {
          // 00
          return GPIO_PERIPHERAL_FUNC_A;
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
