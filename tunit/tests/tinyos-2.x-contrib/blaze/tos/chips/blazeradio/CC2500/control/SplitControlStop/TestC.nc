
/**
 * @author David Moss
 */
 
#include "TestCase.h"

configuration TestC {
}

implementation  {
  components new TestCaseC() as TestCC2500ControlC;
  
  components TestP,
      BlazeSpiC,
      CC2500ControlC,
      HplCC2500PinsC;
  
  TestP.Resource -> BlazeSpiC;
  TestP.TestCC2500Control -> TestCC2500ControlC;
  TestP.SplitControl -> CC2500ControlC;
  TestP.BlazePower -> CC2500ControlC;
  TestP.Csn -> HplCC2500PinsC.Csn;
  
}

