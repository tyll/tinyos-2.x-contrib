
#include "TestCase.h"

/**
 * @author David Moss
 */
configuration TestRadioC {
}

implementation {
  components
      new TestCaseC() as TestActiveMessageAddressC;
      
  components TestRadioP,
      ActiveMessageC,
      ActiveMessageAddressC,
      CC1100ControlC,
      new AMSenderC(4),
      new AMReceiverC(4),
      new TimerMilliC(),
      new StateC(),
      LedsC;

  TestRadioP.SetUpOneTime -> TestActiveMessageAddressC.SetUpOneTime;
  TestRadioP.TearDownOneTime -> TestActiveMessageAddressC.TearDownOneTime;
  
  TestRadioP.TestActiveMessageAddress -> TestActiveMessageAddressC;
  
  TestRadioP.ActiveMessageAddress -> ActiveMessageAddressC;
  TestRadioP.SplitControl -> ActiveMessageC;
  TestRadioP.BlazeConfig -> CC1100ControlC;
  TestRadioP.AMPacket -> ActiveMessageC;
  TestRadioP.AMSend -> AMSenderC;
  TestRadioP.Receive -> AMReceiverC;
  TestRadioP.PacketAcknowledgements -> ActiveMessageC;
  TestRadioP.Timer -> TimerMilliC;
  TestRadioP.State -> StateC;
  TestRadioP.Leds -> LedsC;

}
