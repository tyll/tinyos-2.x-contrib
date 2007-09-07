

/**
 * @author Jared Hill 
 */
 
 /**
  * This module assumes it already owns the spi bus
  */


module RadioStubP {

  provides interface SplitControl;
  provides interface GpioInterrupt as Interrupt;
  provides interface AsyncReceive;
  provides interface AsyncSend;
}

implementation {
  
  /***************SplitControl Commands ************************/
  command error_t SplitControl.start(){
    return FAIL;
  }
  
  command error_t SplitControl.stop(){
    return FAIL;
  }
  /****************** Interrupt Commands********************************/
  async command error_t Interrupt.enableRisingEdge(){
    return FAIL;
  }
  
  async command error_t Interrupt.enableFallingEdge(){
    return FAIL;
  }
  
  async command error_t Interrupt.disable(){
    return FAIL;
  }
  
  /*************** AsyncReceive Commands ***********************/
  async command void AsyncReceive.startReceive(message_t* msg){
    
  }
  
  /***************************AsyncSend Commands*************************/
  async command error_t AsyncSend.send(message_t* msg, uint8_t len){
    return FAIL;
  }
  
      
}
