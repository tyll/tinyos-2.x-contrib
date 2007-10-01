
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
  
  blaze_header_t *getHeader( message_t* msg ) {
    return (blaze_header_t *)( msg->data - sizeof( blaze_header_t ) );
  }
  
  
  event void SetUpOneTime.run() {
    getHeader(&myMsg)->length = 20;
    call Leds.led0On();
    call SplitControl.start();
  }
  
  event void SplitControl.startDone(error_t error) { 
    call Leds.led1On();
    call SetUpOneTime.done();
  }
  
  event void SplitControl.stopDone(error_t error) {
  }

  /***************** Tests ****************/
  event void TestTransmit.run() {
    
    error_t error;
  
    call Leds.led2On();
    call Resource.immediateRequest();
    
    error = call AsyncSend.load(&myMsg);
    
    if(error) {
      assertEquals("Error calling AsyncSend.send()", SUCCESS, error);
      call TestTransmit.done();
    }
  }
  
  async event void AsyncSend.loadDone(void *msg, error_t error) {
    assertEquals("loadDone(ERROR)", SUCCESS, error);
    assertNotNull(msg);
    if((error = call AsyncSend.send()) != SUCCESS) {
      assertEquals("Couldn't send()", SUCCESS, error);
      call TestTransmit.done();
    }
    
  }
   
  async event void AsyncSend.sendDone() {
    call Resource.release();
    call TestTransmit.done();
  }
  
  event void Resource.granted() {
  }
  
}
