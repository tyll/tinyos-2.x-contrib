
/**
 * @author David Moss
 */
 
#include "TestCase.h"

module TestP {
  uses {
    interface TestCase as TestCC1100Control;
    interface SplitControl;
    interface Resource;
    interface GeneralIO as Csn;
  }
}

implementation {

  event void TestCC1100Control.run() {
    error_t error;
    error = call SplitControl.start();
    
    if(error) {
      assertEquals("start didn't work", SUCCESS, error);
      call TestCC1100Control.done();
      return;
    }
  }
  
  event void SplitControl.startDone(error_t error) {
    error_t stopError;

    assertTrue("Wrong: Csn is low after startDone", call Csn.get());

    stopError = call SplitControl.stop();
    if(stopError) {
      assertEquals("stop didn't work", SUCCESS, error);
      call TestCC1100Control.done();
      return;
    }
  }
  
  event void SplitControl.stopDone(error_t error) {
    assertTrue("Wrong: Csn is low after stopDone", call Csn.get());
    assertEquals("stopDone failed", SUCCESS, error);
    call TestCC1100Control.done();
  }
  
  event void Resource.granted() {
  }
  
}
