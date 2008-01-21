
#include "TestCase.h"
#include "Blaze.h"

configuration AutomaticPorC {
}

implementation {
  components new TestCaseC() as TestAutomaticPorC;
  
  components AutomaticPorP,
      HplRadioResetC,
      BlazeCentralWiringC;
      
  AutomaticPorP.RadioReset -> HplRadioResetC.RadioReset[0];
  AutomaticPorP.TestAutomaticPor -> TestAutomaticPorC;
  AutomaticPorP.Power -> BlazeCentralWiringC.Power[0];
  
}

