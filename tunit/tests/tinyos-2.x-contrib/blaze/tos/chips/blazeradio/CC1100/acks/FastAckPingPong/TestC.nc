
#include "TestCase.h"
#include "CC1100.h"


/**
 * Transmit a packet back and forth a bunch of times.
 */
configuration TestC {
}

implementation {

  components new TestCaseC() as TestReceiveC;
  
  components TestP,
      CC1100ControlC,
      AcknowledgementsC,
      CsmaC,
      BlazeReceiveC,
      BlazePacketC,
      LedsC;
      
  AcknowledgementsC.SubSend -> CsmaC.Send;
  
  TestP.SetUpOneTime -> TestReceiveC.SetUpOneTime;
  TestP.TearDownOneTime -> TestReceiveC.TearDownOneTime;
  TestP.TestReceive -> TestReceiveC;
  

  TestP.SplitControl -> CC1100ControlC;
  TestP.Leds -> LedsC; 
   
  TestP.Send -> AcknowledgementsC.Send[CC1100_RADIO_ID];
  TestP.Receive -> BlazeReceiveC.Receive[ CC1100_RADIO_ID ];
  TestP.PacketAcknowledgements -> AcknowledgementsC;
  TestP.BlazePacketBody -> BlazePacketC;
  
}

