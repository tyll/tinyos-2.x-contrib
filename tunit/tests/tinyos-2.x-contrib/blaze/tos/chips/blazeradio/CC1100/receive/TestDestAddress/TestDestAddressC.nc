
/**
 * Send messages from Node 0 to Node 1 with the low-byte of the address = 1,
 * which matches up in hardware, and the high-byte of the address = something,
 * which would pass the hardware test but would fail the software test in
 * the BlazeActiveMessage layer.
 * 
 * @author David Moss
 */
 
#include "TestCase.h"

configuration TestDestAddressC {
}

implementation {
  components new TestCaseC() as TestWrongAddressC;
      
  components TestDestAddressP,
      new AMSenderC(0),
      BlazeC,
      LedsC;
      
  TestDestAddressP.SplitControl -> BlazeC;
  TestDestAddressP.AMPacket -> BlazeC;
  TestDestAddressP.AMSend -> AMSenderC;
  TestDestAddressP.Snoop -> BlazeC.Snoop[0];
  TestDestAddressP.Receive -> BlazeC.Receive[0];
  TestDestAddressP.Leds -> LedsC;

  TestDestAddressP.SetUpOneTime -> TestWrongAddressC.SetUpOneTime;
  TestDestAddressP.TestWrongAddress -> TestWrongAddressC;   
  TestDestAddressP.TearDownOneTime -> TestWrongAddressC.TearDownOneTime;

}

