#include "Atm1281Usart.h"

module PlatformSerialP {

  provides interface StdControl;
  provides interface Atm1281UartConfigure;
  uses interface Resource;
}
implementation {
  

  command error_t StdControl.start() {
    return call Resource.immediateRequest();
  }
  command error_t StdControl.stop() {
    call Resource.release();
    return SUCCESS;
  }
  event void Resource.granted(){}
  
  async command Atm1281UartUnionConfig_t* Atm1281UartConfigure.getConfig() {
  	return &atm1281_uart_default_config;
  }
  
  
}
