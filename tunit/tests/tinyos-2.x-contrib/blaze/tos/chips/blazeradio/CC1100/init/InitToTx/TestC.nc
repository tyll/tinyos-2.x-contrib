

#include "TestCase.h"
#include "BlazeInit.h"

configuration TestC {
}

implementation {

  
  components new TestCaseC() as TestTurnOnC;
  
  components TestP,
      BlazeInitC,
      BlazeSpiC,
      new BlazeSpiResourceC(),
      CC1100ControlC;

  TestP.TestTurnOn -> TestTurnOnC;
  TestP.Resource -> BlazeSpiResourceC;
    
  // Always connected to 0, because we're only testing one radio
  TestP.BlazePower -> CC1100ControlC.BlazePower;
  TestP.SplitControl -> CC1100ControlC.SplitControl;
  
  TestP.SFTX -> BlazeSpiC.SFTX;
  TestP.STX -> BlazeSpiC.STX;
  TestP.Idle -> BlazeSpiC.SIDLE;
  TestP.RadioStatus -> BlazeSpiC.RadioStatus;
  
  components HplCC1100PinsC;
  TestP.Csn -> HplCC1100PinsC.Csn;
}

