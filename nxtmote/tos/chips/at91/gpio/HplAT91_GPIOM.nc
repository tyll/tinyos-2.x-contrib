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
    PIOPER |= (uint32_t)pin;
    return;
  }

  //PIO Controller Output Enable Register
  async command void HplAT91_GPIOPin.setPIOOER[uint8_t pin]() 
  {
    PIOOER |= (uint32_t)pin;
    return;
  }

  //PIO Controller Clear Output Data Register
  async command void HplAT91_GPIOPin.setPIOCODR[uint8_t pin]() 
  {
    PIOCODR |= (uint32_t)pin;
    return;
  }

  //PIO Controller Set Output Data Register
  async command void HplAT91_GPIOPin.setPIOSODR[uint8_t pin]() 
  {
    PIOSODR |= (uint32_t)pin;
    return;
  }
}
