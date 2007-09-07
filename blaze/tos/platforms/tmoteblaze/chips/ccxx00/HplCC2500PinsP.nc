
/**
 * Default event handlers for interrupts that are not used
 * Keep this for unit tests that only use the lowest parts of the stack
 * @author David Moss
 */
 
module HplCC2500PinsP {
  uses {
    interface GpioInterrupt as Gdo2_int;
    interface GpioInterrupt as Gdo0_int;
  }
}

implementation {

  async event void Gdo2_int.fired() {
  }
  
  async event void Gdo0_int.fired() {
  }
  
}

