
/**
 * @author David Moss
 */
 
#include "TestCase.h"

configuration TestC {
}

implementation  {
  components new TestCaseC() as TestCC1100ControlC;
  
  components TestP,
      new BlazeSpiResourceC(),
      CC1100ControlC,
      HplCC1100PinsC;
  
  TestP.Resource -> BlazeSpiResourceC;
  TestP.TestCC1100Control -> TestCC1100ControlC;
  TestP.SplitControl -> CC1100ControlC;
  TestP.Csn -> HplCC1100PinsC.Csn;
  
}

