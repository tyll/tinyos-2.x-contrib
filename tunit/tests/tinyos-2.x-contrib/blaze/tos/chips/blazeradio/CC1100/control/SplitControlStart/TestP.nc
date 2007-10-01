
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
      assertEquals("SplitControl didn't work", SUCCESS, error);
      call TestCC1100Control.done();
      return;
    }
  }
  
  event void SplitControl.startDone(error_t error) {
    assertTrue("Csn is low after startDone", call Csn.get());
    assertSuccess();
    call TestCC1100Control.done();
  }
  
  event void SplitControl.stopDone(error_t error) {
  }
  
  event void Resource.granted() {
  }
  
}
