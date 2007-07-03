/**
 * Adapted for nxtmote.
 * @author Rasmus Pedersen
 */
#include "at91_registers.h"

module HplAT91_GPIOM {
  provides {
    interface HplAT91_GPIOPin[uint8_t pin];
  }
}

implementation {
  //PIO Controller PIO Enable Register
  async command void HplAT91_GPIOPin.setPIOPER[uint8_t pin]() 
  {
    *AT91C_PIOA_PER = GPIO_pin_bit(pin);
    return;
  }

  //PIO Controller Output Enable Register
  async command void HplAT91_GPIOPin.setPIOOER[uint8_t pin]() 
  {
    *AT91C_PIOA_OER = GPIO_pin_bit(pin);
    return;
  }

  //PIO Controller Clear Output Data Register
  async command void HplAT91_GPIOPin.setPIOCODR[uint8_t pin]() 
  {
    *AT91C_PIOA_CODR = GPIO_pin_bit(pin);
    return;
  }

  //PIO Controller Set Output Data Register
  async command void HplAT91_GPIOPin.setPIOSODR[uint8_t pin]() 
  {
    *AT91C_PIOA_SODR = GPIO_pin_bit(pin);
    return;
  }
  
  //PIO Controller Pin Data Status Register
  async command bool HplAT91_GPIOPin.getPIOPDSR[uint8_t pin]() 
  {
    return ((*AT91C_PIOA_PDSR & GPIO_pin_bit(pin)) != 0);
  }
  
  //PIO set selection of A peripheral
  async command void HplAT91_GPIOPin.setPIOASR[uint8_t pin]()
  {
    *AT91C_PIOA_ABSR = GPIO_pin_bit(pin);
  }
  
  //PIO disable (to let a peripheral control the pin)
  async command void HplAT91_GPIOPin.setPIOPDR[uint8_t pin]()
  {
    *AT91C_PIOA_PDR = GPIO_pin_bit(pin);
  }
  
  //PIO open drain (multiple drivers)
  async command void HplAT91_GPIOPin.setPIOMDER[uint8_t pin]()
  {
    *AT91C_PIOA_MDER = GPIO_pin_bit(pin);
  }  

  //PIO pull up disable
  async command void HplAT91_GPIOPin.setPIOPPUDR[uint8_t pin]()
  {
    *AT91C_PIOA_PPUDR = GPIO_pin_bit(pin);
  }  

  
}
