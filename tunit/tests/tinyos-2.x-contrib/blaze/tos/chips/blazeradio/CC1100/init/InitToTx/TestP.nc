
#include "TestCase.h"

module TestP {
  uses {
    interface TestCase as TestTurnOn;
    
    interface Resource;
    interface BlazePower;
    interface SplitControl;
    
    interface BlazeStrobe as Idle;
    interface BlazeStrobe as STX;
    interface BlazeStrobe as SFTX;
    interface GeneralIO as Csn;
    interface RadioStatus;
  }
}

implementation {

  event void TestTurnOn.run() {
    call BlazePower.reset();
  }
  
  event void BlazePower.resetComplete() {
    error_t error;    
    error = call SplitControl.start();
    
    if(error) {
      assertEquals("SplitControl didn't work", SUCCESS, error);
      call TestTurnOn.done();
      return;
    }
  }
  
  event void SplitControl.startDone(error_t error) {
    int i;
    
    call Resource.immediateRequest();
    
    call Csn.set();
    call Csn.clr();
    call Idle.strobe();
    
    assertEquals("Radio isn't IDLE", (uint8_t) BLAZE_S_IDLE, (uint8_t) call RadioStatus.getRadioStatus());
      
    call Csn.set();
    call Csn.clr();
    call SFTX.strobe();
    call STX.strobe();

    for(i = 0; i < 100; i++) {
      if(call RadioStatus.getRadioStatus() == BLAZE_S_TX) {
        break;
      }
    }
    
    assertEquals("Radio isn't in TX", (uint8_t) BLAZE_S_TX, (uint8_t) call RadioStatus.getRadioStatus());
      
    call Csn.set();
    call Resource.release();
    call TestTurnOn.done();
  }
  
  event void SplitControl.stopDone(error_t error) {
  }
  
  
  event void Resource.granted() {
  }
  
  event void BlazePower.deepSleepComplete() {
  }
}
