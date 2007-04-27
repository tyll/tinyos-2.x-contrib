/**
 * Adapted for nxtmote.
 * @author Rasmus Pedersen
 */
 
module HalAT91_GeneralIOM {
  provides {
    interface GeneralIO[uint8_t pin];
  }
  uses {
    interface HplAT91_GPIOPin[uint8_t pin];
  }
}

implementation {
  async command void GeneralIO.set[uint8_t pin]() {
    atomic call HplAT91_GPIOPin.setPIOSODR[pin]();
    return;
  }

  async command void GeneralIO.clr[uint8_t pin]() {
    return;
  }

  async command void GeneralIO.toggle[uint8_t pin]() {
    return;
  }

  async command bool GeneralIO.get[uint8_t pin]() {
    bool result = 0;
    return result;
  }

  async command void GeneralIO.makeInput[uint8_t pin]() {
    return;
  }

  async command void GeneralIO.makeOutput[uint8_t pin]() {
    /*if(pin==0){
    atomic call HplNXTARM_GPIOPin.setPIOPER[pin]();
    atomic call HplNXTARM_GPIOPin.setPIOOER[pin]();

    atomic call HplNXTARM_GPIOPin.setPIOCODR[pin]();
    }*/
    return;
  }
  
  async command bool GeneralIO.isInput[uint8_t pin]() {
    bool result = 0;
    return result;
  
  }
  
  async command bool GeneralIO.isOutput[uint8_t pin]() {  
    bool result = 0;
    return result;
  }
}
