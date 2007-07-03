/**
 * Adapted for nxtmote.
 * @author Rasmus Ulslev Pedersen
 */
 
module HalAT91_GeneralIOM {
  provides {
    interface GeneralIO[uint8_t pin];
    interface HalAT91GpioInterrupt[uint8_t pin];
    interface GpioInterrupt[uint8_t pin];
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
    atomic call HplAT91_GPIOPin.setPIOCODR[pin]();    
    return;
  }

  async command void GeneralIO.toggle[uint8_t pin]() {
    if(call HplAT91_GPIOPin.getPIOPDSR[pin]())
      call GeneralIO.clr[pin]();
    else
      call GeneralIO.set[pin]();
    return;
  }

  async command bool GeneralIO.get[uint8_t pin]() {
    bool result;
    result = call HplAT91_GPIOPin.getPIOPDSR[pin]();
    return result;
  }

  async command void GeneralIO.makeInput[uint8_t pin]() {
    return;
  }

  async command void GeneralIO.makeOutput[uint8_t pin]() {
    atomic call HplAT91_GPIOPin.setPIOPER[pin]();
    atomic call HplAT91_GPIOPin.setPIOOER[pin]();
//    atomic call HplAT91_GPIOPin.setPIOCODR[pin]();
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
  
  //TODO
  async command error_t GpioInterrupt.enableRisingEdge[uint8_t pin]() {
    return SUCCESS;//call HalPXA27xGpioInterrupt.enableRisingEdge[pin]();
  }

  async command error_t GpioInterrupt.enableFallingEdge[uint8_t pin]() {
    return SUCCESS;//call HalPXA27xGpioInterrupt.enableFallingEdge[pin]();
  }

  async command error_t GpioInterrupt.disable[uint8_t pin]() {
    return SUCCESS;//call HalPXA27xGpioInterrupt.disable[pin]();
  }

  //TODO
  async command error_t HalAT91GpioInterrupt.enableRisingEdge[uint8_t pin]() {
    atomic {
      //call HplPXA27xGPIOPin.setGRERbit[pin](TRUE);
      //call HplPXA27xGPIOPin.setGFERbit[pin](FALSE);
    }
    return SUCCESS;
  }

  async command error_t HalAT91GpioInterrupt.enableFallingEdge[uint8_t pin]() {
    atomic {
      //call HplPXA27xGPIOPin.setGRERbit[pin](FALSE);
      //call HplPXA27xGPIOPin.setGFERbit[pin](TRUE);
    }
    return SUCCESS;
  }

  async command error_t HalAT91GpioInterrupt.enableBothEdge[uint8_t pin]() {
    atomic {
      //call HplPXA27xGPIOPin.setGRERbit[pin](TRUE);
      //call HplPXA27xGPIOPin.setGFERbit[pin](TRUE);
    }
    return SUCCESS;
  }

  async command error_t HalAT91GpioInterrupt.disable[uint8_t pin]() {
    atomic {
      //call HplPXA27xGPIOPin.setGRERbit[pin](FALSE);
      //call HplPXA27xGPIOPin.setGFERbit[pin](FALSE);
      //call HplPXA27xGPIOPin.clearGEDRbit[pin]();
    }
    return SUCCESS;
  }
  
  //TODO
  async event void HplAT91_GPIOPin.interruptGPIOPin[uint8_t pin]() {
    //call HplPXA27xGPIOPin.clearGEDRbit[pin]();
    //signal HalPXA27xGpioInterrupt.fired[pin]();
    //signal GpioInterrupt.fired[pin]();
    return;
  }  
  
  default async event void HalAT91GpioInterrupt.fired[uint8_t pin]() {
    return;
  }

  default async event void GpioInterrupt.fired[uint8_t pin]() {
    return;
  }  
}
