
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
      BlazeSpiC,
      CC2500ControlC,
      BlazeTransmitC,
      BlazeReceiveC,
      HplCC2500PinsC,
      BlazePacketC,
      LedsC;
      
  TestP.SetUpOneTime -> TestReceiveC.SetUpOneTime;
  TestP.TearDownOneTime -> TestReceiveC.TearDownOneTime;
  TestP.TestReceive -> TestReceiveC;
 
  TestP.Resource -> BlazeSpiC;
  TestP.SplitControl -> CC2500ControlC;
  TestP.BlazePower -> CC2500ControlC;
  TestP.Leds -> LedsC;
  
  TestP.CC2500ReceiveInterrupt -> HplCC2500PinsC.Gdo2_int;
   
  TestP.Receive -> BlazeReceiveC.Receive[ CC2500_RADIO_ID ];
  TestP.ReceiveController -> BlazeReceiveC.ReceiveController[ CC2500_RADIO_ID ];
  TestP.BlazePacketBody -> BlazePacketC;
  
  TestP.AsyncSend -> BlazeTransmitC.AsyncSend[ CC2500_RADIO_ID ];
 
  BlazeTransmitC.Csn[ CC2500_RADIO_ID ] -> HplCC2500PinsC.Csn;
  BlazeReceiveC.Csn[ CC2500_RADIO_ID ] -> HplCC2500PinsC.Csn;
  
}

