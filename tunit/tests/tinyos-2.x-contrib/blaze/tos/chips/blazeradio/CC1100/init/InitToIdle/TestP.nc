
#include "TestCase.h"

module TestP {
  uses {
    interface TestCase as TestTurnOn;
    
    interface SplitControl;
    
    interface Resource;
    interface BlazePower;
    interface BlazeStrobe as Idle;
    interface BlazeStrobe as SRX;
    interface BlazeStrobe as SFRX;
    interface GeneralIO as Csn;
    interface RadioStatus;
    interface Leds;
  }
}

implementation {

  event void TestTurnOn.run() {
    call BlazePower.reset();
  }
  
  event void BlazePower.resetComplete() {
    error_t error;
    call Leds.led0On();
    
    if((error = call SplitControl.start()) != SUCCESS) {
      assertEquals("SplitControl didn't work", SUCCESS, error);
      call TestTurnOn.done();
      return;
    }
  }
  
  
  event void SplitControl.startDone(error_t error) {
    int i;
    
    call Leds.led1On();
    assertEquals("immediateRequest failed", SUCCESS, call Resource.immediateRequest());
    
    call Csn.set();
    call Csn.clr();
    
    call Idle.strobe();
    
    for(i = 0; i < 50; i++) {
      if(call RadioStatus.getRadioStatus() == BLAZE_S_IDLE) {
        break;
      }
    }
    
    assertEquals("Radio isn't IDLE", (uint8_t) BLAZE_S_IDLE, (uint8_t) call RadioStatus.getRadioStatus());
    
    call Csn.set();
    call Resource.release();
    call TestTurnOn.done();
  }
  
  
  
  event void SplitControl.stopDone(error_t error) {
  }
 
  event void BlazePower.deepSleepComplete() {
  }
 
  event void Resource.granted() {   
  }
}
