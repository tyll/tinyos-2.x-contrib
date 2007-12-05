
/**
 * Dummy interrupt implementation
 * @author David Moss
 */
 
module DummyInterruptP {
  provides {
    interface GpioInterrupt;
  }
}

implementation {
  
  async command error_t GpioInterrupt.enableRisingEdge() {
    return SUCCESS;
  }
  
  async command error_t GpioInterrupt.enableFallingEdge() {
    return SUCCESS;
  }
  
  async command error_t GpioInterrupt.disable() {
    return SUCCESS;
  }

}
