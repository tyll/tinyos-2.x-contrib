
/**
 * @author David Moss
 */
 
#include "TestCase.h"
#include "CC1100.h"
#include "Blaze.h"

module PowerCycleP {
  uses {
    interface TestCase as TestPowerCycle;
    interface SplitControl;
    interface Leds;
  }
}

implementation {

  uint32_t powerCycles;
  
  enum {
    MAX_CYCLES = 10000,
  };
  
  
  event void TestPowerCycle.run() {
    error_t myError;
    powerCycles = 0;
    if((myError = call SplitControl.start()) != SUCCESS) {
      assertEquals("start() failed", SUCCESS, myError);
      call TestPowerCycle.done();
    }
  }
  
  
  event void SplitControl.startDone(error_t error) {
    error_t myError;
    call Leds.led2On();
    if((myError = call SplitControl.stop()) != SUCCESS) {
      assertEquals("stop() failed", SUCCESS, myError);
      call TestPowerCycle.done();
    }
  }
  
  
  event void SplitControl.stopDone(error_t error) {
    error_t myError;
    call Leds.led2Off();
    
    powerCycles++;
    
    if(powerCycles < MAX_CYCLES) {
      if((myError = call SplitControl.start()) != SUCCESS) {
        assertEquals("start() failed", SUCCESS, myError);
        call TestPowerCycle.done();
      }
    
    } else {
      assertSuccess();
      call TestPowerCycle.done();
    }
  }
}

