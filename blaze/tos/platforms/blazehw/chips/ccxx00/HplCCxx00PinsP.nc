
/**
 * Default event handlers for interrupts that are not used
 * Keep this for unit tests that only use the lowest parts of the stack
 * @author David Moss
 */

generic module HplCCxx00PinsP() {

  provides {
    interface Init;
    interface GeneralIO as PowerOut;
    interface GeneralIO as CsnOut;
  } 
  
  uses {
    interface GpioInterrupt as Gdo2_int;
    interface GpioInterrupt as Gdo0_int;
    interface GeneralIO as PowerIn;
    interface GeneralIO as Csn;
  }
}

implementation {

  norace bool powerOn;
  
  command error_t Init.init() {
    call Csn.makeOutput();
    call PowerIn.makeOutput();
    call PowerIn.clr();
    return SUCCESS;
  }

  async event void Gdo2_int.fired() {
  }
  
  async event void Gdo0_int.fired() {
  }
  
  /******* For this platform, when we turn off power to the radio, need to set the
  Csn pin low so it does not power the raio module through that pin. *************/
  
  async command void PowerOut.set(){
    powerOn = TRUE;
    call PowerIn.set();
    call Csn.set();
  }
  
  async command void PowerOut.clr(){
    powerOn = FALSE;
    call Csn.clr();
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
  
  
  /***************** CSN Pins ****************/
  async command void CsnOut.set(){
    // Want to make sure the CSN pin doesn't get set high unless the power
    // is on, because the CSN pin can actually power up the radio
    if(powerOn) {
      call Csn.set();
    }
  }
  
  async command void CsnOut.clr(){
    call Csn.clr();
  }
  
  async command void CsnOut.toggle(){
    call Csn.toggle();
  }
  
  async command bool CsnOut.get(){
    return call Csn.get();
  }
  
  async command void CsnOut.makeInput(){
    call Csn.makeInput();
  }
  
  async command bool CsnOut.isInput(){
    return call Csn.isInput();
  }
  
  async command void CsnOut.makeOutput(){
    call Csn.makeOutput();
  }
  
  async command bool CsnOut.isOutput(){
    return call Csn.isOutput();
  }
  
}

