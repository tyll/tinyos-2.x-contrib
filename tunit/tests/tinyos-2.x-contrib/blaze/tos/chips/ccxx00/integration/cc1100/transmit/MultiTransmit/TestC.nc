
#include "TestCase.h"
#include "CC1100.h"

/**
 * @author David Moss
 */
 
configuration TestC {
}

implementation {

  components new TestCaseC() as TestTransmitC;
  
  components TestP,
      CC1100ControlC,
      BlazeTransmitC,
      new BlazeSpiResourceC();
  
  TestP.SetUpOneTime -> TestTransmitC.SetUpOneTime;
  TestP.TestTransmit -> TestTransmitC;

  TestP.Resource -> BlazeSpiResourceC;
  TestP.SplitControl -> CC1100ControlC;
  TestP.AsyncSend -> BlazeTransmitC.AsyncSend[ CC1100_RADIO_ID ];
  
  components LedsC;
  TestP.Leds -> LedsC;
  
}

