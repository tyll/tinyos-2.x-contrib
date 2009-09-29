
#include "TestCase.h"

module TestP {
  uses {
    interface TestControl as SetUpOneTime;
    interface TestControl as TearDownOneTime;
    
    interface TestCase as TestAm;
    
    interface AMSend;
    interface Receive;
    interface SplitControl;
    interface PacketAcknowledgements;
    interface Leds;
  }
}

implementation {

  message_t myMsg;
  
  event void SetUpOneTime.run() {
    call SplitControl.start();
  }
  
  event void TearDownOneTime.run() {
    call SplitControl.stop();
  }
  
  event void SplitControl.startDone(error_t error) {
    call SetUpOneTime.done();
  }
  
  event void SplitControl.stopDone(error_t error) {
    call TearDownOneTime.done();
  }
  
  
  /***************** Tests ****************/
  task void send() {
    error_t error;
    if((error = call AMSend.send(AM_BROADCAST_ADDR, &myMsg, 0)) != SUCCESS) {
      assertEquals("send(ERROR)", SUCCESS, error);
      call TestAm.done();
    }
  }
  
  /**
   * Make sure we get an ack, then the test is done
   */
  event void TestAm.run() {
    call PacketAcknowledgements.requestAck(&myMsg);
    post send();
  }
  
  
  event message_t *Receive.receive(message_t *msg, void *payload, uint8_t len) {
    call Leds.led1On();
    return msg;
  }
  
  event void AMSend.sendDone(message_t *msg, error_t error) {
    call Leds.led2On();
    
    assertFalse("Got a bcast ack", call PacketAcknowledgements.wasAcked(msg));
    
    if(call PacketAcknowledgements.wasAcked(msg)) {
      call Leds.led1On();
    }
    
    if(msg != &myMsg) {
      assertFail("sendDone(msg != &myMsg)");
    }
    
    assertEquals("sendDone(ERROR)", SUCCESS, error);
   
    call TestAm.done();
    
  }

}


