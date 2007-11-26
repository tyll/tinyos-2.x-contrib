
#include "TestCase.h"

/**
 * @author David Moss
 */
module TestP {
  uses {
    interface TestControl as SetUpOneTime;
    interface TestControl as TearDownOneTime;
    
    interface TestCase as TestReceive;
    
    interface Resource;
    interface SplitControl;
    interface GpioInterrupt as CC2500ReceiveInterrupt;
    interface AsyncSend;
    interface Receive;
    interface Leds;
  }
}

implementation {


  message_t myMsg;

  uint8_t timesSent;
  
  bool receivedPacket;
  
  bool runningTest;
  
  enum {
    MY_PACKET_LENGTH = 20,
  };
  
  /***************** Functions ****************/
  blaze_header_t *getHeader( message_t* msg ) {
    return (blaze_header_t *)( msg->data - sizeof( blaze_header_t ) );
  }
  
  /***************** TestControl ****************/
  event void SetUpOneTime.run() {
    receivedPacket = FALSE;
    runningTest = FALSE;
    timesSent = 0;
    getHeader(&myMsg)->length = MY_PACKET_LENGTH;
    getHeader(&myMsg)->dest = 1;
    getHeader(&myMsg)->src = 0;
    call SplitControl.start();
  }
  
  event void TearDownOneTime.run() {
    call Resource.release();
    call SplitControl.stop();
  }
  
  
  /***************** Resource Events ****************/
  event void Resource.granted() {
    
  }
  
  /***************** SplitControl Events ****************/
  event void SplitControl.startDone(error_t error) {
    call SetUpOneTime.done(); 
  }
  
  event void SplitControl.stopDone(error_t error) {
    call TearDownOneTime.done();
  }
  
  
  /***************** TestReceive Events ****************/
  /**
   * Only node 0 gets this command.  So we don't need to check addresses on 
   * anything for this test.
   */
  event void TestReceive.run() {
    error_t error;

    runningTest = TRUE;
    
    call Resource.immediateRequest();
    
    error = call AsyncSend.load(&myMsg);
    
    if(error) {
      assertEquals("AsyncSend.load() error", SUCCESS, error);
      call TestReceive.done();
    }
  }
 
  /***************** AsyncSend Events ****************/
  async event void AsyncSend.loadDone(void *msg, error_t error) {
    call AsyncSend.send(0);
  }
  
  async event void AsyncSend.sendDone(error_t error) {
    timesSent++;
    call Leds.led2Toggle();
    call Resource.release();
    // The receiver must stop the test by receiving one of those or we timeout
  }
  
  
  /***************** Receive Events ****************/
  async event void CC2500ReceiveInterrupt.fired() {
    if(!runningTest) {
      call Leds.led1On();
      assertSuccess();
      call TestReceive.done();
    }
  }
  
  /***************** Receive Events ****************/
  event message_t *Receive.receive(message_t *msg, void *payload, uint8_t len) {
    return msg;
  }
 
}

