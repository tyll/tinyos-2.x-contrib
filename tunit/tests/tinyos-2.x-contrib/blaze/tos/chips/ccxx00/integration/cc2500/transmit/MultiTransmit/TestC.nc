
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
      new BlazeSpiResourceC();
  
  TestP.SetUpOneTime -> TestTransmitC.SetUpOneTime;
  TestP.TestTransmit -> TestTransmitC;

  TestP.Resource -> BlazeSpiResourceC;
  TestP.SplitControl -> CC2500ControlC;
  TestP.AsyncSend -> BlazeTransmitC.AsyncSend[ CC2500_RADIO_ID ];
  
  components LedsC;
  TestP.Leds -> LedsC;
  
}

