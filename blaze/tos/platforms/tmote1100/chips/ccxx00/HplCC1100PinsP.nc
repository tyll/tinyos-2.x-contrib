
/**
 * Default event handlers for interrupts that are not used
 * Keep this for unit tests that only use the lowest parts of the stack
 * @author David Moss
 */
 
module HplCC1100PinsP {
  provides {
    interface Init as PlatformInit;
  }
  
  uses {
    interface GpioInterrupt as Gdo2_int;
    interface GpioInterrupt as Gdo0_int;
    interface GeneralIO as Gdo0_io;
    interface GeneralIO as Gdo2_io;
    interface GeneralIO as Csn;
    interface GeneralIO as Power;
  }
}

implementation {

  command error_t PlatformInit.init() {
    
    call Csn.makeOutput();
    call Power.makeOutput();
    
    // TODO Keep GDO's output low to avoid floaters when the chip is off
    // But when I made these outputs they locked up my code
    call Gdo0_io.makeInput();  // TODO platform init this to output
    call Gdo2_io.makeInput();  // TODO should be output perhaps
    call Gdo0_io.clr();
    call Gdo2_io.clr();
    
    return SUCCESS;
  }

  /** Default fired() events in case the rest of the stack doesn't use them */
  async event void Gdo2_int.fired() {
  }
  
  async event void Gdo0_int.fired() {
  }
  
}

