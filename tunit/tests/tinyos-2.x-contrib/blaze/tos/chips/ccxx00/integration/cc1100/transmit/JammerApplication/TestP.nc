
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
    call Leds.led1On();
    call AsyncSend.send(&myMsg, TRUE, 0);
  }
  
  event void SplitControl.stopDone(error_t error) {
  }

  /***************** Tests ****************/  
  async event void AsyncSend.sendDone(error_t error) {
    // should never get here.
    call Leds.led0On();
    // Arbitrary amount of times to resend.
    call AsyncSend.send(&myMsg, FALSE, 0);
  }


  event void Resource.granted() {
  }
  
}

