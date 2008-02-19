
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
      new BlazeSpiResourceC(),
      CC2500ControlC,
      BlazeReceiveC,
      HplCC2500PinsC,
      BlazePacketC,
      AcknowledgementsC,
      LedsC;
      
  TestP.SetUpOneTime -> TestReceiveC.SetUpOneTime;
  TestP.TearDownOneTime -> TestReceiveC.TearDownOneTime;
  TestP.TestReceive -> TestReceiveC;
  TestP.PacketAcknowledgements -> AcknowledgementsC;
  TestP.SplitControl -> CC2500ControlC;
  TestP.Leds -> LedsC;
   
  TestP.Send -> AcknowledgementsC.Send[CC2500_RADIO_ID];
  TestP.Receive -> BlazeReceiveC.Receive[ CC2500_RADIO_ID ];
  TestP.BlazePacketBody -> BlazePacketC;
  
  components CsmaC;
  AcknowledgementsC.SubSend -> CsmaC;
}

