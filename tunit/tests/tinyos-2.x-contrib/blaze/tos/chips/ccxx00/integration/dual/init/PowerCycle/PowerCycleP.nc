
/**
 * @author David Moss
 */
 
#include "TestCase.h"
#include "Blaze.h"

module PowerCycleP {
  uses {
    interface TestCase as TestPowerCycle;
    interface SplitControl[radio_id_t radioId];
    interface Leds;
  }
}

implementation {

  uint32_t powerCycles;
  
  enum {
    MAX_CYCLES = 20000,
  };
  
  uint8_t focusedRadio = 0;
  
  event void TestPowerCycle.run() {
    error_t myError;
    powerCycles = 0;
    if((myError = call SplitControl.start[focusedRadio]()) != SUCCESS) {
      assertEquals("start() failed", SUCCESS, myError);
      call TestPowerCycle.done();
    }
  }
  
  
  event void SplitControl.startDone[radio_id_t radioId](error_t error) {
    error_t myError;
    call Leds.set(radioId + 1);
    if((myError = call SplitControl.stop[focusedRadio]()) != SUCCESS) {
      assertEquals("stop() failed", SUCCESS, myError);
      call TestPowerCycle.done();
    }
  }
  
  
  event void SplitControl.stopDone[radio_id_t radioId](error_t error) {
    error_t myError;
    call Leds.set(0);
    
    powerCycles++;
    
    focusedRadio++;
    focusedRadio %= uniqueCount(UQ_BLAZE_RADIO);
    
    if(powerCycles < MAX_CYCLES) {
      if((myError = call SplitControl.start[focusedRadio]()) != SUCCESS) {
        assertEquals("start() failed", SUCCESS, myError);
        call TestPowerCycle.done();
      }
    
    } else {
      assertSuccess();
      call TestPowerCycle.done();
    }
  }
}

