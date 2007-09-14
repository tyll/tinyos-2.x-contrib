
#include "TestCase.h"
#include "CC2500.h"

configuration TestC {
}

implementation {

  components new TestCaseC() as TestReceiveC;
  
  components TestP,
      new BlazeSpiResourceC(),
      CC2500ControlC,
      BlazeTransmitC,
      BlazeReceiveC,
      HplCC2500PinsC,
      LedsC;
      
  TestP.SetUpOneTime -> TestReceiveC.SetUpOneTime;
  TestP.TearDownOneTime -> TestReceiveC.TearDownOneTime;
  TestP.TestReceive -> TestReceiveC;
 
  TestP.Resource -> BlazeSpiResourceC;
  TestP.SplitControl -> CC2500ControlC;
  TestP.Leds -> LedsC;
  
  TestP.CC2500ReceiveInterrupt -> HplCC2500PinsC.Gdo2_int;
   
  TestP.Receive -> BlazeReceiveC.Receive[ CC2500_RADIO_ID ];
  TestP.ReceiveController -> BlazeReceiveC.ReceiveController[ CC2500_RADIO_ID ];
  
  TestP.AsyncSend -> BlazeTransmitC.AsyncSend[ CC2500_RADIO_ID ];
  
}

