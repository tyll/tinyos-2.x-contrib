
#include "TestCase.h"
#include "CC1100.h"


/**
 * Fill up and transmit a single packet, then verify every byte got
 * transferred correctly
 */
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
      BlazePacketC,
      LedsC;
      
  TestP.SetUpOneTime -> TestReceiveC.SetUpOneTime;
  TestP.TearDownOneTime -> TestReceiveC.TearDownOneTime;
  TestP.TestReceive -> TestReceiveC;
 
  TestP.Resource -> BlazeSpiResourceC;
  TestP.SplitControl -> CC1100ControlC;
  TestP.Leds -> LedsC;
   
  TestP.Receive -> BlazeReceiveC.Receive[ CC1100_RADIO_ID ];
  TestP.BlazePacketBody -> BlazePacketC;
  
  TestP.AsyncSend -> BlazeTransmitC.AsyncSend[ CC1100_RADIO_ID ];
  
}

