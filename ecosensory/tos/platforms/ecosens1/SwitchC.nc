/* Copyright (c) 2007, Ecosensory Austin Texas All rights reserved. 
 * BSD license full text at: 
 * http://tinyos.cvs.sourceforge.net/tinyos/tinyos-2.x-contrib/ecosensory/license.txt
 * by John Griessen <john@ecosensory.com> @version  $Date
 * Two state switch implementation on MSP430 platforms
 */

generic module SwitchC() {
  provides interface Get<state_t>;
  provides interface Notify<state_t>;

  uses interface GeneralIO;
  uses interface GpioInterrupt;
}
implementation {
  norace bool m_pinHigh;

  task void sendEvent();

  command state_t Get.get() { return call GeneralIO.get(); }

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
    state_t pinHigh; //Notify doesn't use bool...so coerce type.
    pinHigh = m_pinHigh;
    
    signal Notify.notify( pinHigh );
    
    if ( pinHigh ) {
      call GpioInterrupt.enableFallingEdge();
    } else {
      call GpioInterrupt.enableRisingEdge();
    }
  }
}
