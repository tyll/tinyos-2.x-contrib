
#include "TestCase.h"
#include "CC1100.h"

configuration TestC {
}

implementation {

  components new TestCaseC() as TestReceiveC;
  
  components TestP,
      new BlazeSpiResourceC(),
      CC1100ControlC,
      BlazeTransmitC,
      BlazeReceiveC,
      HplCC1100PinsC,
      LedsC;
      
  TestP.SetUpOneTime -> TestReceiveC.SetUpOneTime;
  TestP.TearDownOneTime -> TestReceiveC.TearDownOneTime;
  TestP.TestReceive -> TestReceiveC;
 
  TestP.Resource -> BlazeSpiResourceC;
  TestP.SplitControl -> CC1100ControlC;
  TestP.Leds -> LedsC;
  
  TestP.CC1100ReceiveInterrupt -> HplCC1100PinsC.Gdo2_int;
   
  TestP.Receive -> BlazeReceiveC.Receive[ CC1100_RADIO_ID ];
  
  TestP.AsyncSend -> BlazeTransmitC.AsyncSend[ CC1100_RADIO_ID ];
  
}

