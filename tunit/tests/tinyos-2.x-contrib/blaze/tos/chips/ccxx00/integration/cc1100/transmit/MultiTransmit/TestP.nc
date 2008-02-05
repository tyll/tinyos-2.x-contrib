
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

  task void send();
  
  /** Message to transmit */
  message_t myMsg;

  norace uint32_t times;
  
  blaze_header_t *getHeader( message_t* msg ) {
    return (blaze_header_t *)( msg->data - sizeof( blaze_header_t ) );
  }
  
  enum {
    MAX_TRANSMITS = 10000,
  };
  
  /***************** TestControl ****************/
  event void SetUpOneTime.run() {
    times = 0;
    getHeader(&myMsg)->length = 38;
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
    
    error = call AsyncSend.send(&myMsg, TRUE, 0);
    
    if(error) {
      assertEquals("send(FORCE) error", SUCCESS, error);
      call TestTransmit.done();
    }
  }
  
  async event void AsyncSend.sendDone(error_t error) {
    times++;
    
    call Leds.led2Toggle();
    
    if(error) {
      assertEquals("sendDone(ERROR)", SUCCESS, error);
      call TestTransmit.done();
      return;
    }
    
    // Arbitrary amount of times to resend.
    if(times < MAX_TRANSMITS) {
      post send();
    
    } else {
      assertSuccess();
      call TestTransmit.done();
    }
  }


  event void Resource.granted() {
  }
  
  task void send() {
    error_t sendError;
    if((sendError = call AsyncSend.send(&myMsg, FALSE, 0)) != SUCCESS) {
       call Leds.led0Toggle();
       call Leds.led1Off();
       assertEquals("send error", SUCCESS, sendError);
       post send();
       
    } else {
      call Leds.led1Toggle();
      call Leds.led0Off();
    }
  }
}

