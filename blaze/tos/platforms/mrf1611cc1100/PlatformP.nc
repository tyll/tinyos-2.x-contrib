#include "hardware.h"

module PlatformP{
  provides interface Init;
  uses interface Init as Msp430ClockInit;
  uses interface Init as MoteInit;
  uses interface Init as LedsInit;
  uses interface Init as ButtonsInit;
}
implementation {
  command error_t Init.init() {
    call Msp430ClockInit.init();
    call MoteInit.init();
    call LedsInit.init();
    call ButtonsInit.init();
    return SUCCESS;
  }

  default command error_t LedsInit.init() { return SUCCESS; }
  default command error_t ButtonsInit.init() { return SUCCESS; }
}

