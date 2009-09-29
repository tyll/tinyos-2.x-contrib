
#include "TestCase.h"

#include "CC1100.h"
#include "Ccxx00Nbd.h"
#include "CC2500.h"

/**
 * Test the ability to send packets through multiple radios.
 * The strategy is as follows:
 *
 * On the TRANSMITTER side, use RadioSelect to define which radio
 * the packet should be sent through.
 *
 * On the RECEIVER side, use RfResource to select the default radio to sit
 * on.  We could access that radio in other ways too, like through RadioResource.
 * But RfResource it is. When the receiver receives a packet, it asserts
 * success and causes the test to move on to the next one.
 * When the receiver gets packets on all 3 radios, the test is complete.
 * 
 * The order of header #include's at the top of this configuration file
 * defines what order the radios are tested in.
 * 
 * @author David Moss
 */
configuration TestC {
}

implementation {

  components new TestCaseC() as TestRadioOneC,
      new TestCaseC() as TestRadioTwoC,
      new TestCaseC() as TestRadioThreeC;
      
  components TestP,
      ActiveMessageC,
      new AMSenderC(0),
      new AMReceiverC(0),
      LedsC;
  
  TestP.SetUpOneTime -> TestRadioOneC.SetUpOneTime;
  
  TestP.TestRadioOne -> TestRadioOneC;
  TestP.TestRadioTwo -> TestRadioTwoC;
  TestP.TestRadioThree -> TestRadioThreeC;
  
  TestP.AMSend -> AMSenderC;
  TestP.Receive -> AMReceiverC;
  TestP.RadioSelect -> ActiveMessageC;
  TestP.RfResource -> ActiveMessageC;
  TestP.AMPacket -> ActiveMessageC;
  TestP.Leds -> LedsC;
  
}

