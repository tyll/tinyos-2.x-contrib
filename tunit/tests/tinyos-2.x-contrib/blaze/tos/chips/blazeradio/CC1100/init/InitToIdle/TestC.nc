

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
      CC1100ControlC,
      LedsC;

  TestP.TestTurnOn -> TestTurnOnC;
    
  TestP.SplitControl -> CC1100ControlC.SplitControl;
  TestP.BlazePower -> CC1100ControlC;
  
  TestP.Resource -> BlazeSpiResourceC;
  TestP.SFRX -> BlazeSpiC.SFRX;
  TestP.SRX -> BlazeSpiC.SRX;
  TestP.Idle -> BlazeSpiC.SIDLE;
  TestP.RadioStatus -> BlazeSpiC.RadioStatus;
  TestP.Leds -> LedsC;
  
  components HplCC1100PinsC;
  TestP.Csn -> HplCC1100PinsC.Csn;
}

