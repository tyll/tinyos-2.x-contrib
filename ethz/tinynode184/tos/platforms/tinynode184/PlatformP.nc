#include "hardware.h"

module PlatformP {
  provides interface Init;
  uses interface Init as Msp430ClockInit;
  uses interface Init as LedsInit;
  uses interface ShutdownDev as DevSleep;
  uses interface Boot;
}
implementation {

  command error_t Init.init() {
    TOSH_SET_PIN_DIRECTIONS();
    call Msp430ClockInit.init();
    call LedsInit.init();
    return SUCCESS;
  }

  event void Boot.booted() {
       call DevSleep.sleep();
  }
  default command error_t LedsInit.init() { return SUCCESS; }

}

