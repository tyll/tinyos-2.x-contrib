/* Copyright (c) 2007, Ecosensory Austin Texas All rights reserved. 
 * BSD license full text at: 
 * http://tinyos.cvs.sourceforge.net/tinyos/tinyos-2.x-contrib/ecosensory/license.txt
 * by John Griessen <john@ecosensory.com>    @version
 * Two state switch implementation on MSP430 platforms
 */

module UserSwitchP {
  provides interface Get<state_t>;
  provides interface Notify<state_t>;
  uses interface Get<state_t> as GetGeneric;
  uses interface Notify<state_t> as NotifyGeneric;
}
implementation {
  
  command state_t Get.get() {
    return call GetGeneric.get();
  }
  command error_t Notify.enable() {
    return call NotifyGeneric.enable();
  }

  command error_t Notify.disable() {
    return call NotifyGeneric.disable();
  }

  event void NotifyGeneric.notify( state_t val ) {
    signal Notify.notify( val );
  }
}

