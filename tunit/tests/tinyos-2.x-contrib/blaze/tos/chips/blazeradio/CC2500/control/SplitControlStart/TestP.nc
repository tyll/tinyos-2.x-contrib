
/**
 * @author David Moss
 */
 
#include "TestCase.h"

module TestP {
  uses {
    interface TestCase as TestCC2500Control;
    interface SplitControl;
    interface Resource;
    interface GeneralIO as Csn;
  }
}

implementation {

  event void TestCC2500Control.run() {
    error_t error;
    error = call SplitControl.start();
    
    if(error) {
      assertEquals("SplitControl didn't work", SUCCESS, error);
      call TestCC2500Control.done();
      return;
    }
  }
  
  event void SplitControl.startDone(error_t error) {
    assertTrue("Csn is low after startDone", call Csn.get());
    assertSuccess();
    call TestCC2500Control.done();
  }
  
  event void SplitControl.stopDone(error_t error) {
  }
  
  event void Resource.granted() {
  }
  
}
