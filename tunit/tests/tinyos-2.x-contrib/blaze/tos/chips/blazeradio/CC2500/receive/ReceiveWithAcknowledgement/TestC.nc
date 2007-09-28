
#include "TestCase.h"
#include "CC2500.h"


/**
 * Fill up and transmit a single packet, then verify every byte got
 * transferred correctly.  The receiver should transmit back an acknowledgement
 * that has the correct bytes filled in.
 *
 * If the test times out, that's because the transmitter (node 0) never got
 * an acknowledgement.
 */
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
      BlazePacketC,
      LedsC;
      
  TestP.SetUpOneTime -> TestReceiveC.SetUpOneTime;
  TestP.TearDownOneTime -> TestReceiveC.TearDownOneTime;
  TestP.TestReceive -> TestReceiveC;
 
  TestP.Resource -> BlazeSpiResourceC;
  TestP.SplitControl -> CC2500ControlC;
  TestP.Leds -> LedsC;
  
  TestP.Receive -> BlazeReceiveC.Receive[ CC2500_RADIO_ID ];
  TestP.AckReceive -> BlazeReceiveC.AckReceive;
  TestP.BlazePacketBody -> BlazePacketC;
  
  TestP.AsyncSend -> BlazeTransmitC.AsyncSend[ CC2500_RADIO_ID ];
  
}

