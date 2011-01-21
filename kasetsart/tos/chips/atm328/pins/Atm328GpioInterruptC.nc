/**
 * Minimally implement interrupt support for interrupt-capable GPIO pins
 *
 * @notes
 * This file is modified from
 * <code>tinyos-2.1.0/tos/chips/atm128/pins/Atm128GpioInterruptC.nc</code>
 *
 * @author
 * Chaiporn Jaikaeo (chaiporn.j@ku.ac.th)
 */

generic module Atm328GpioInterruptC() @safe() {

  provides interface GpioInterrupt as Interrupt;
  uses interface HplAtm328Interrupt as Atm328Interrupt;

}

implementation {

  error_t enable( bool rising ) {
    atomic {
      call Atm328Interrupt.disable();
      call Atm328Interrupt.edge( rising );
      call Atm328Interrupt.enable();
    }
    return SUCCESS;
  }

  async command error_t Interrupt.enableRisingEdge() {
    return enable( TRUE );
  }

  async command error_t Interrupt.enableFallingEdge() {
    return enable( FALSE );
  }

  async command error_t Interrupt.disable() {
    call Atm328Interrupt.disable();
    return SUCCESS;
  }

  async event void Atm328Interrupt.fired() {
    signal Interrupt.fired();
  }

}
