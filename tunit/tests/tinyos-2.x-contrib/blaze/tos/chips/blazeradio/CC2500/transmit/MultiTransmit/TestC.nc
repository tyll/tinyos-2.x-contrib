
#include "TestCase.h"
#include "CC2500.h"

/**
 * @author David Moss
 */
 
configuration TestC {
}

implementation {

  components new TestCaseC() as TestTransmitC;
  
  components TestP,
      CC2500ControlC,
      BlazeTransmitC,
      BlazeSpiC,
      HplCC2500PinsC;
  
  TestP.SetUpOneTime -> TestTransmitC.SetUpOneTime;
  TestP.TestTransmit -> TestTransmitC;

  TestP.Resource -> BlazeSpiC;  
  TestP.BlazePower -> CC2500ControlC;
  TestP.SplitControl -> CC2500ControlC;
  TestP.AsyncSend -> BlazeTransmitC.AsyncSend[ CC2500_RADIO_ID ];

  BlazeTransmitC.Csn[ CC2500_RADIO_ID ] -> HplCC2500PinsC.Csn;
  
  components LedsC;
  TestP.Leds -> LedsC;
  
}

