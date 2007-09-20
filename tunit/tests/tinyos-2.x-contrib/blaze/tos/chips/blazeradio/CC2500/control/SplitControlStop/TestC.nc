
/**
 * @author David Moss
 */
 
#include "TestCase.h"

configuration TestC {
}

implementation  {
  components new TestCaseC() as TestCC2500ControlC;
  
  components TestP,
      new BlazeSpiResourceC(),
      CC2500ControlC,
      HplCC2500PinsC;
  
  TestP.Resource -> BlazeSpiResourceC;
  TestP.TestCC2500Control -> TestCC2500ControlC;
  TestP.SplitControl -> CC2500ControlC;
  TestP.Csn -> HplCC2500PinsC.Csn;
  
}

