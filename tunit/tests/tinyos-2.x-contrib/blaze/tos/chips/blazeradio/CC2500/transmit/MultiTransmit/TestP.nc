
#include "TestCase.h"

module TestP {
  uses {
    interface TestControl as SetUpOneTime;

    interface TestCase as TestTransmit;
    
    interface Resource;
    interface SplitControl;
    interface AsyncSend;
    interface Leds;
  }
}

implementation {

  /** Message to transmit */
  message_t myMsg;

  norace uint32_t times;
  
  blaze_header_t *getHeader( message_t* msg ) {
    return (blaze_header_t *)( msg->data - sizeof( blaze_header_t ) );
  }
  
  
  event void SetUpOneTime.run() {
    times = 0;
    getHeader(&myMsg)->length = 20;
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
    
    call Resource.immediateRequest();
    
    call Leds.led2On();
    error = call AsyncSend.load(&myMsg);
    
    if(error) {
      assertEquals("Error on load()", SUCCESS, error);
      call TestTransmit.done();
    }
  }
  
  async event void AsyncSend.loadDone(void *msg, error_t error) {
    call Leds.led2Off();
    call Leds.led1On();
    
    if(msg != &myMsg) {
      assertFail("msg!=&myMsg");
    }
    
    if(error != SUCCESS) {
      assertEquals("loadDone() error", SUCCESS, error);
      assertEquals("Too few Tx's", 1000, times);
      call TestTransmit.done();
      return;
    }
    
    while((error = call AsyncSend.send()) != SUCCESS) {
      if(error == EBUSY) {
        // Then we couldn't send because of CCA
        // Try again.
      } else {
        assertEquals("Error on send()", SUCCESS, error);
        assertEquals("Too few Tx's", 1000, times);
        call TestTransmit.done();
      }
    }
  }
  
  async event void AsyncSend.sendDone() {
    error_t sendError;
    times++;
    
    
    call Leds.led1Off();

    // Arbitrary amount of times to resend.
    if(times < 1000) {
      call  Leds.led2On();
      sendError = call AsyncSend.load(&myMsg);
      
      if(sendError == SUCCESS) {
        return;

      } else {      
        assertEquals("Multi-load error", SUCCESS, sendError);
        assertEquals("Too few Tx's", 1000, times);
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