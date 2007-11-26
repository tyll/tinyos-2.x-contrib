
#include "TestCase.h"
#include "CC2500.h"


/**
 * Fill up and transmit a single packet, then verify every byte got
 * transferred correctly
 */
configuration TestC {
}

implementation {

  components new TestCaseC() as TestReceiveC;
  
  components TestP,
      CC2500ControlC,
      CsmaC,
      BlazeReceiveC,
      HplCC2500PinsC,
      BlazePacketC,
      new TimerMilliC(),
      LedsC;
      
  TestP.SetUpOneTime -> TestReceiveC.SetUpOneTime;
  TestP.TearDownOneTime -> TestReceiveC.TearDownOneTime;
  TestP.TestReceive -> TestReceiveC;
  
  TestP.SplitControl -> CC2500ControlC;
  TestP.Leds -> LedsC;
  TestP.Timer -> TimerMilliC;
  TestP.Send -> CsmaC.Send[CC2500_RADIO_ID];
  TestP.Receive -> BlazeReceiveC.Receive[ CC2500_RADIO_ID ];
  TestP.BlazePacketBody -> BlazePacketC;
  
}

