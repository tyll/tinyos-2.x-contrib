

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
      CC2500ControlC,
      LedsC;

  TestP.TestTurnOn -> TestTurnOnC;
    
  TestP.SplitControl -> CC2500ControlC.SplitControl;
  TestP.BlazePower -> CC2500ControlC;
  
  TestP.Resource -> BlazeSpiResourceC;
  TestP.SFRX -> BlazeSpiC.SFRX;
  TestP.SRX -> BlazeSpiC.SRX;
  TestP.Idle -> BlazeSpiC.SIDLE;
  TestP.RadioStatus -> BlazeSpiC.RadioStatus;
  TestP.Leds -> LedsC;
  
  components HplCC2500PinsC;
  TestP.Csn -> HplCC2500PinsC.Csn;
}

