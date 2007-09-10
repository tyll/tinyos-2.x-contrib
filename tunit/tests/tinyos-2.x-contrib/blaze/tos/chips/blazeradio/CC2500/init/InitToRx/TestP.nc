
#include "TestCase.h"

module TestP {
  uses {
    interface TestCase as TestTurnOn;
    
    interface Resource;
    interface SplitControl;
    
    interface BlazeStrobe as Idle;
    interface BlazeStrobe as SRX;
    interface BlazeStrobe as SFRX;
    interface BlazeStrobe as SFTX;
    interface BlazeStrobe as SNOP;
    
    interface GeneralIO as Csn;
    interface RadioStatus;
  }
}

implementation {

  event void TestTurnOn.run() {
    error_t error = call Resource.immediateRequest();

    if(error != SUCCESS) {
      assertFail("Resource immediate request failed");
      call TestTurnOn.done();
      return;
    }
    
    error = call SplitControl.start();
   
    if(error) {
      assertEquals("SplitControl didn't work", SUCCESS, error);
      call TestTurnOn.done();
      return;
    }
  }
  
  event void SplitControl.startDone(error_t error) {
    int i;
    
    call Csn.set();
    call Csn.clr();
    call Idle.strobe();
    
    assertEquals("Radio isn't IDLE", (uint8_t) BLAZE_S_IDLE, (uint8_t) call RadioStatus.getRadioStatus());
    
    call Csn.set();
    call Csn.clr();
    call SFRX.strobe();
    call SRX.strobe();
    
    for(i = 0; i < 100; i++) {
      if(call RadioStatus.getRadioStatus() == BLAZE_S_RX) {
        break;
      }
    }
    
    
    assertEquals("Radio isn't in RX", BLAZE_S_RX, (uint8_t) call RadioStatus.getRadioStatus());
      
    call Csn.set();
    call TestTurnOn.done();
  }
  
  event void SplitControl.stopDone(error_t error) {
  }
  
  
  event void Resource.granted() {
  }
  
}
