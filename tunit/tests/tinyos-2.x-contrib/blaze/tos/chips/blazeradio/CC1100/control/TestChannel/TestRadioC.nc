
#include "TestCase.h"

/**
 * @author David Moss
 */
configuration TestRadioC {
}

implementation {
  components
      new TestCaseC() as TestChangeFrequencyC;
      
  components TestRadioP,
      ActiveMessageC,
      new AMSenderC(4),
      new AMReceiverC(4),
      new TimerMilliC(),
      new StateC(),
      CC1100ControlC,
      LedsC;

  TestRadioP.SetUpOneTime -> TestChangeFrequencyC.SetUpOneTime;
  TestRadioP.TearDownOneTime -> TestChangeFrequencyC.TearDownOneTime;
  
  TestRadioP.TestChangeFrequency -> TestChangeFrequencyC;
  TestRadioP.SplitControl -> ActiveMessageC;
  TestRadioP.PacketAcknowledgements -> ActiveMessageC;
  TestRadioP.AMSend -> AMSenderC;
  TestRadioP.Receive -> AMReceiverC;
  TestRadioP.Timer -> TimerMilliC;
  TestRadioP.State -> StateC;
  TestRadioP.BlazeConfig -> CC1100ControlC;
  TestRadioP.Leds -> LedsC;

}
