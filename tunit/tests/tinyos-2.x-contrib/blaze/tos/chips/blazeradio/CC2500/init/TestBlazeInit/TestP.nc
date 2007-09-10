
#include "TestCase.h"

module TestP {
  uses {
    interface TestCase as TestTurnOn;
    
    interface Resource;
    interface SplitControl;
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
    assertSuccess();
    call TestTurnOn.done();
  }
  
  event void SplitControl.stopDone(error_t error) {
  }
  
  
  event void Resource.granted() {
  }
  
}
