

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
  
  TestP.SFRX -> BlazeSpiC.SFRX;
  TestP.SRX -> BlazeSpiC.SRX;
  TestP.Idle -> BlazeSpiC.SIDLE;
  TestP.RadioStatus -> BlazeSpiC.RadioStatus;
  
  components HplCC2500PinsC;
  TestP.Csn -> HplCC2500PinsC.Csn;
}

