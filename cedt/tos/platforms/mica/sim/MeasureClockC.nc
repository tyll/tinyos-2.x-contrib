#include "scale.h"

/**
 * Simulation version of MeasureClockC for the mica platform. See 
 * tos/platforms/mica/MeasureClockC.nc for more details.
 *
 * @author Phil Levis
 */
 
/**
 * Modified version of MeasureClockC to support Atm128Calibrate for 
 * Mica2 simulation platform
 * 
 * @author Venkatesh S
 * @author Prabhakar T V
 *
 */

module MeasureClockC {
  /* This code MUST be called from PlatformP only, hence the exactlyonce */
  provides interface Init @exactlyonce();
  provides interface Atm128Calibrate;
  
  provides {
    command uint16_t cyclesPerJiffy();
    command uint32_t calibrateMicro(uint32_t n);
  }
}
implementation 
{

  enum {
    PLATFORM_MHZ = 8,
  };
  
  enum {
    /* This is expected number of cycles per jiffy at the platform's
       specified MHz. Assumes PLATFORM_MHZ == 1, 2, 4, 8 or 16. */
    MAGIC = 488 / (16 / PLATFORM_MHZ)
  };
  
  uint16_t cycles = 1 << 8;
  
  command error_t Init.init() {
    return SUCCESS;
  }

  command uint16_t cyclesPerJiffy() {
    return (1 << 8);
  }

  command uint32_t calibrateMicro(uint32_t n) {
    return scale32(n + 122, 244, (1 << 32));
  }
  
  async command uint16_t Atm128Calibrate.cyclesPerJiffy() {
    return cycles;
  }
  
  async command uint32_t Atm128Calibrate.calibrateMicro(uint32_t n) {
    return scale32(n + MAGIC / 2, cycles, MAGIC);
  }

  async command uint32_t Atm128Calibrate.actualMicro(uint32_t n) {
    return scale32(n + (cycles >> 1), MAGIC, cycles);
  }
  
  async command uint8_t Atm128Calibrate.adcPrescaler() {
    /* This is also log2(cycles/3.05). But that's a pain to compute */
    if (cycles >= 390)
      return ATM128_ADC_PRESCALE_128;
    if (cycles >= 195)
      return ATM128_ADC_PRESCALE_64;
    if (cycles >= 97)
      return ATM128_ADC_PRESCALE_32;
    if (cycles >= 48)
      return ATM128_ADC_PRESCALE_16;
    if (cycles >= 24)
      return ATM128_ADC_PRESCALE_8;
    if (cycles >= 12)
      return ATM128_ADC_PRESCALE_4;
    return ATM128_ADC_PRESCALE_2;
  }

  async command uint16_t Atm128Calibrate.baudrateRegister(uint32_t baudrate) {
    // value is (cycles*32768) / (8*baudrate) - 1
    return ((uint32_t)cycles << 12) / baudrate - 1;
  }    
  
}
