

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
      CC2500ControlC;

  TestP.TestTurnOn -> TestTurnOnC;
  TestP.Resource -> BlazeSpiResourceC;
    
  // Always connected to 0, because we're only testing one radio
  TestP.BlazePower -> CC2500ControlC.BlazePower;
  TestP.SplitControl -> CC2500ControlC.SplitControl;
  
  TestP.SFTX -> BlazeSpiC.SFTX;
  TestP.STX -> BlazeSpiC.STX;
  TestP.Idle -> BlazeSpiC.SIDLE;
  TestP.RadioStatus -> BlazeSpiC.RadioStatus;
  
  components HplCC2500PinsC;
  TestP.Csn -> HplCC2500PinsC.Csn;
}

