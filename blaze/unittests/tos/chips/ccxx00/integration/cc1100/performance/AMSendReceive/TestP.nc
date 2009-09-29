
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
    call Leds.led3On();
    call SetUpOneTime.done();
  }
  
  event void SplitControl.stopDone(error_t error) {
    call TearDownOneTime.done();
  }
  
  
  /***************** Tests ****************/
  event void TestAm.run() {
    error_t error;
    call PacketAcknowledgements.requestAck(&myMsg);
    if((error = call AMSend.send(1, &myMsg, 0)) != SUCCESS) {
      assertEquals("send(ERROR)", SUCCESS, error);
      call TestAm.done();
    }
  }
  
  
  event message_t *Receive.receive(message_t *msg, void *payload, uint8_t len) {
    call Leds.led1On();
    assertSuccess();
    call TestAm.done();
    return msg;
  }
  
  event void AMSend.sendDone(message_t *msg, error_t error) {
    call Leds.led2On();
    
    assertTrue("No ack!", call PacketAcknowledgements.wasAcked(msg));
    if(call PacketAcknowledgements.wasAcked(msg)) {
      call Leds.led1On();
    }
    
    if(msg != &myMsg) {
      assertFail("sendDone(msg != &myMsg)");
    }
    
    assertEquals("sendDone(ERROR)", SUCCESS, error);
    
    if(error) {
      call TestAm.done();
    }
    
  }

}


