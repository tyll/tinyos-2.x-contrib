
/**
 * Default event handlers for interrupts that are not used
 * Keep this for unit tests that only use the lowest parts of the stack
 * @author David Moss
 */
 
module HplCC2500PinsP {
  provides interface GeneralIO as PowerOut;
  provides interface Init;
  uses {
    interface GpioInterrupt as Gdo2_int;
    interface GpioInterrupt as Gdo0_int;
    interface GeneralIO as PowerIn;
    interface GeneralIO as CSn;
  }
}

implementation {

  command error_t Init.init() {
    call PowerIn.set();
    return SUCCESS;
  }

  async event void Gdo2_int.fired() {
  }
  
  async event void Gdo0_int.fired() {
  }
  
  /******* For this platform, when we turn off power to the radio, need to set the
  CSn pin low so it does not power the raio module through that pin. *************/
  
  async command void PowerOut.set(){
    call PowerIn.set();
    call CSn.set();
  }
  
  async command void PowerOut.clr(){
    call CSn.clr();
    call PowerIn.clr();
  }
  
  async command void PowerOut.toggle(){
    call PowerIn.toggle();
  }
  
  async command bool PowerOut.get(){
    return call PowerIn.get();
  }
  
  async command void PowerOut.makeInput(){
    call PowerIn.makeInput();
  }
  
  async command bool PowerOut.isInput(){
    return call PowerIn.isInput();
  }
  
  async command void PowerOut.makeOutput(){
    call PowerIn.makeOutput();
  }
  
  async command bool PowerOut.isOutput(){
    return call PowerIn.isOutput();
  }
}

