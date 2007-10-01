
#include "TestCase.h"

module TestP {
  uses {
    interface TestCase as TestTurnOn;
    
    interface BlazePower;
    interface Resource;
    interface SplitControl;
  }
}

implementation {

  void start() {
    error_t error;
    error = call SplitControl.start();
    
    if(error) {
      assertEquals("SplitControl didn't work", SUCCESS, error);
      call TestTurnOn.done();
      return;
    }
  }
  
  event void TestTurnOn.run() {
    start();
  }
  
  event void BlazePower.resetComplete() {
    start();
  }
  
  event void SplitControl.startDone(error_t error) {
    assertSuccess();
    call TestTurnOn.done();
  }
  
  event void SplitControl.stopDone(error_t error) {
  }
  
  
  event void Resource.granted() {
  }
  
  event void BlazePower.deepSleepComplete() {
  }
}
