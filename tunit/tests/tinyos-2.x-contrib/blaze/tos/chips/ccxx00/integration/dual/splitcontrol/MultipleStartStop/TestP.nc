
#include "TestCase.h"

module TestP {
  uses {    
    interface TestCase as MultiStartStop;
    
    interface AMSend;
    interface Receive;
    interface SplitControl;
    interface Leds;
  }
}

implementation {

  message_t myMsg;
  
  uint32_t times = 0;
  
  event void SplitControl.startDone(error_t error) {
    call Leds.led1On();
    call SplitControl.stop();
  }
  
  event void SplitControl.stopDone(error_t error) {
    call Leds.led1Off();
    times++;
    if(times < 10000) {
      call SplitControl.start();
      
    } else {
      assertSuccess();
      call MultiStartStop.done();
    }
  }
  
  
  /***************** Tests ****************/
  event void MultiStartStop.run() {
    call SplitControl.start();
  }
  
  
  event message_t *Receive.receive(message_t *msg, void *payload, uint8_t len) {
    return msg;
  }
  
  event void AMSend.sendDone(message_t *msg, error_t error) {
  }

}


