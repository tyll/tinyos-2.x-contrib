

#include "TestCase.h"
#include "BlazeInit.h"

configuration TestC {
}

implementation {

  
  components new TestCaseC() as TestTurnOnC;
  
  components TestP,
      BlazeInitC,
      BlazeSpiC,
      CC2500InitC;

  TestP.TestTurnOn -> TestTurnOnC;
  TestP.Resource -> BlazeSpiC;
    
  // Always connected to 0, because we're only testing one radio
  TestP.SplitControl -> BlazeInitC.SplitControl[0];
  
}

