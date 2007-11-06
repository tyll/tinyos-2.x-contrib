
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
      CC1100ControlC,
      CsmaC,
      BlazeReceiveC,
      HplCC1100PinsC,
      BlazePacketC,
      new TimerMilliC(),
      LedsC;
      
  TestP.SetUpOneTime -> TestReceiveC.SetUpOneTime;
  TestP.TearDownOneTime -> TestReceiveC.TearDownOneTime;
  TestP.TestReceive -> TestReceiveC;
  
  TestP.SplitControl -> CC1100ControlC;
  TestP.Timer -> TimerMilliC;
  TestP.Leds -> LedsC;
   
  TestP.Send -> CsmaC.Send[CC1100_RADIO_ID];
  TestP.Receive -> BlazeReceiveC.Receive[ CC1100_RADIO_ID ];
  TestP.BlazePacketBody -> BlazePacketC;
  
}

