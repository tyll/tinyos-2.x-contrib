/* Copyright (c) 2007, Arch Rock Corporation All rights reserved. 
* BSD license full text at: 
* http://tinyos.cvs.sourceforge.net/tinyos/tinyos-2.x-contrib/ecosensory/license.txt
 *
 * Generic layer to translate a GIO into a toggle switch
 * @author Gilman Tolle <gtolle@archrock.com>   @version $Revision$
 */

#include <UserButton.h>

generic module SwitchToggleC() {
  provides interface Get<bool>;
  provides interface Notify<bool>;

  uses interface GeneralIO;
  uses interface GpioInterrupt;
}
implementation {
  norace bool m_pinHigh;

  task void sendEvent();

  command bool Get.get() { return call GeneralIO.get(); }

  command error_t Notify.enable() {
    call GeneralIO.makeInput();

    if ( call GeneralIO.get() ) {
      m_pinHigh = TRUE;
      return call GpioInterrupt.enableFallingEdge();
    } else {
      m_pinHigh = FALSE;
      return call GpioInterrupt.enableRisingEdge();
    }
  }

  command error_t Notify.disable() {
    return call GpioInterrupt.disable();
  }

  async event void GpioInterrupt.fired() {
    call GpioInterrupt.disable();

    m_pinHigh = !m_pinHigh;

    post sendEvent();
  }

  task void sendEvent() {
    bool pinHigh;
    pinHigh = m_pinHigh;
    
    signal Notify.notify( pinHigh );
    
    if ( pinHigh ) {
      call GpioInterrupt.enableFallingEdge();
    } else {
      call GpioInterrupt.enableRisingEdge();
    }
  }
}
