
/**
 * @author David Moss
 */
 
#include "TestCase.h"
#include "CC2500.h"
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
    MAX_CYCLES = 10000,
  };
  
  
  event void TestPowerCycle.run() {
    error_t myError;
    powerCycles = 0;
    if((myError = call SplitControl.start[CC2500_RADIO_ID]()) != SUCCESS) {
      assertEquals("start() failed", SUCCESS, myError);
      call TestPowerCycle.done();
    }
  }
  
  
  event void SplitControl.startDone[radio_id_t radioId](error_t error) {
    error_t myError;
    call Leds.led2On();
    if((myError = call SplitControl.stop[radioId]()) != SUCCESS) {
      assertEquals("stop() failed", SUCCESS, myError);
      call TestPowerCycle.done();
    }
  }
  
  
  event void SplitControl.stopDone[radio_id_t radioId](error_t error) {
    error_t myError;
    call Leds.led2Off();
    
    powerCycles++;
    
    if(powerCycles < MAX_CYCLES) {
      if((myError = call SplitControl.start[CC2500_RADIO_ID]()) != SUCCESS) {
        assertEquals("start() failed", SUCCESS, myError);
        call TestPowerCycle.done();
      }
    
    } else {
      assertSuccess();
      call TestPowerCycle.done();
    }
  }
}

