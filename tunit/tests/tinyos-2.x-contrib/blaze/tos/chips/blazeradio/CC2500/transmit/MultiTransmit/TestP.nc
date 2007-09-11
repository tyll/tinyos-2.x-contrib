
#include "TestCase.h"

module TestP {
  uses {
    interface TestControl as SetUpOneTime;

    interface TestCase as TestTransmit;
    
    interface Resource;
    interface BlazePower;
    interface SplitControl;
    interface AsyncSend;
    interface Leds;
  }
}

implementation {

  /** Message to transmit */
  message_t myMsg;

  uint32_t times;
  
  blaze_header_t *getHeader( message_t* msg ) {
    return (blaze_header_t *)( msg->data - sizeof( blaze_header_t ) );
  }
  
  
  event void SetUpOneTime.run() {
    times = 0;
    getHeader(&myMsg)->length = 20;
    call Resource.immediateRequest();
    call BlazePower.reset();
    call SplitControl.start();
  }
  
  event void SplitControl.startDone(error_t error) { 
    call SetUpOneTime.done();
  }
  
  event void SplitControl.stopDone(error_t error) {
  }

  /***************** Tests ****************/
  event void TestTransmit.run() {
    error_t error;
    
    error = call AsyncSend.send(&myMsg);
    
    if(error) {
      assertEquals("Error calling AsyncSend.send()", SUCCESS, error);
      call TestTransmit.done();
    }
  }
  
  async event void AsyncSend.sendDone(void *msg, error_t error) {
    error_t sendError;
    times++;
    
    call Leds.led2Toggle();
    if(error) {
      assertEquals("AsyncSend.sendDone() wasn't SUCCESS", SUCCESS, error);
    }
    
    // Arbitrary amount of times to resend.
    if(times < 1000) {
      sendError = call AsyncSend.send(&myMsg);
      
      if(sendError == SUCCESS) {
        return;

      } else {      
        assertEquals("Multi-send error", SUCCESS, sendError);
        // Fall through and clean up below.
      }
      
    } else {
      assertSuccess();
    }
    
    call TestTransmit.done();
  }
  
  
  event void Resource.granted() {
  }
}
