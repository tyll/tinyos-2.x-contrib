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
}
