
module TestP {
  uses {
    interface Boot;
    interface Resource;
    interface SplitControl;
    interface AsyncSend;
    interface Leds;
  }
}

implementation {

  task void send();
  
  /** Message to transmit */
  message_t myMsg;

  blaze_header_t *getHeader( message_t* msg ) {
    return (blaze_header_t *)( msg->data - sizeof( blaze_header_t ) );
  }
  
  /***************** TestControl ****************/
  event void Boot.booted() {
    getHeader(&myMsg)->length = 38;
    call SplitControl.start();
  }
  
  event void SplitControl.startDone(error_t error) { 
    call Resource.immediateRequest();
    call AsyncSend.send(&myMsg, TRUE, 0);
  }
  
  event void SplitControl.stopDone(error_t error) {
  }

  /***************** Tests ****************/  
  async event void AsyncSend.sendDone(error_t error) {
    
    call Leds.led2Toggle();
    
    // Arbitrary amount of times to resend.
    post send();
  }


  event void Resource.granted() {
  }
  
  task void send() {
    error_t sendError;
    if((sendError = call AsyncSend.send(&myMsg, FALSE, 1024)) != SUCCESS) {
       call Leds.led0Toggle();
       call Leds.led1Off();
       post send();
       
    } else {
      call Leds.led1Toggle();
      call Leds.led0Off();
    }
  }
}

