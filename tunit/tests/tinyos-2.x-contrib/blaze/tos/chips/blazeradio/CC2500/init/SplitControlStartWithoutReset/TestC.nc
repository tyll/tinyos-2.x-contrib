

#include "TestCase.h"
#include "BlazeInit.h"

/**
 * SplitControl now resets by default, making this test case a little
 * outdated
 */
configuration TestC {
}

implementation {

  
  components new TestCaseC() as TestTurnOnC;
  
  components TestP,
      BlazeInitC,
      BlazeSpiC,
      new BlazeSpiResourceC(),
      CC2500ControlC;

  TestP.TestTurnOn -> TestTurnOnC;
  TestP.Resource -> BlazeSpiResourceC;
  TestP.BlazePower -> CC2500ControlC;
    
  TestP.SplitControl -> CC2500ControlC.SplitControl;
  
}

