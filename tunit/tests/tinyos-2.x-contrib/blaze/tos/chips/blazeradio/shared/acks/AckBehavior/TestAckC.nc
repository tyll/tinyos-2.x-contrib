
#include "TestCase.h"

/**
 * Test all bounds of an isolated AckC component
 * @author David Moss
 */
configuration TestAckC {
}

implementation {

  components new TestCaseC() as TestPacketAcknowledgementsC,
      new TestCaseC() as TestNoAckC,
      new TestCaseC() as TestAckWithResponseC,
      new TestCaseC() as TestAckNoResponseC,
      new TestCaseC() as TestAckWrongDsnC,
      new TestCaseC() as TestAckWrongSourceC,
      new TestCaseC() as TestAckWrongDestC,
      new TestCaseC() as TestAckBroadcastDestC;
      
  components TestAckP,
      AcknowledgementsP,
      BlazePacketC,
      new StateC(),
      LedsC;
  
  TestAckP.Send -> AcknowledgementsP;
  TestAckP.PacketAcknowledgements -> AcknowledgementsP;

  TestAckP.Leds -> LedsC;
  TestAckP.State -> StateC;
  TestAckP.BlazePacketBody -> BlazePacketC;
  
  TestAckP.SetUp -> TestPacketAcknowledgementsC.SetUp;
  TestAckP.TestPacketAcknowledgements -> TestPacketAcknowledgementsC;
  TestAckP.TestNoAck -> TestNoAckC;
  TestAckP.TestAckWithResponse -> TestAckWithResponseC;
  TestAckP.TestAckNoResponse -> TestAckNoResponseC;
  TestAckP.TestAckWrongDsn -> TestAckWrongDsnC;
  TestAckP.TestAckWrongSource -> TestAckWrongSourceC;
  TestAckP.TestAckWrongDest -> TestAckWrongDestC;
  TestAckP.TestAckBroadcastDest -> TestAckBroadcastDestC;
  
  /***************** AckP Wrapper Configuration *****************/
  AcknowledgementsP.SubSend -> TestAckP;
  AcknowledgementsP.ChipSpiResource -> TestAckP;
  AcknowledgementsP.AckReceive -> TestAckP;
  
  AcknowledgementsP.BlazePacketBody -> BlazePacketC;
  
  components AlarmMultiplexC;
  AcknowledgementsP.AckWaitTimer -> AlarmMultiplexC;

  AcknowledgementsP.Leds -> LedsC;
}
