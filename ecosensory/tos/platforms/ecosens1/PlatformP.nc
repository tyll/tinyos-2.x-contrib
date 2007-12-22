/* Copyright (c) 2007, Ecosensory Austin Texas All rights reserved. 
* BSD license full text at: 
* http://tinyos.cvs.sourceforge.net/tinyos/tinyos-2.x-contrib/ecosensory/license.txt
* derived telosb  John Griessen 21 Dec 2007
*/
#include "hardware.h"

module PlatformP{
  provides interface Init;
  uses interface Init as MoteClockInit;
  uses interface Init as MoteInit;
  uses interface Init as LedsInit;
}
implementation {
  command error_t Init.init() {
    call MoteClockInit.init();
    call MoteInit.init();
    call LedsInit.init();
    return SUCCESS;
  }

  default command error_t LedsInit.init() { return SUCCESS; }
}
