
#include "TestCase.h"

module TestP {
  uses {
    interface TestCase as TestAm;
    
    interface AMSend;
    interface Receive;
    interface SplitControl;
  }
}

implementation {

  event void TestAm.run() {
    assertSuccess();
    call TestAm.done();
  }
  
  event void SplitControl.startDone(error_t error) {
    call TestAm.done();
  }
  
  event void SplitControl.stopDone(error_t error) {
    call TestAm.done();
  }
  
  event message_t *Receive.receive(message_t *msg, void *payload, uint8_t len) {
    call TestAm.done();
    return msg;
  }
  
  event void AMSend.sendDone(message_t *msg, error_t error) {
    call TestAm.done();
  }

}


