
#include "TestCase.h"

/**
 * @author David Moss
 */
configuration TestRadioC {
}

implementation {
  components
      new TestCaseC() as TestInUseDutyCycleC;
      
  components TestRadioP,
      ActiveMessageC,
      new AMSenderC(4),
      new AMReceiverC(4),
      new TimerMilliC(),
      new StateC(),
      LedsC;

  TestRadioP.SetUp -> TestInUseDutyCycleC.SetUp;
  
  TestRadioP.TestInUseDutyCycle -> TestInUseDutyCycleC;
  
  TestRadioP.SplitControl -> ActiveMessageC;
  TestRadioP.AMSend -> AMSenderC;
  TestRadioP.Receive -> AMReceiverC;
  TestRadioP.PacketAcknowledgements -> ActiveMessageC;
  TestRadioP.Timer -> TimerMilliC;
  TestRadioP.State -> StateC;
  TestRadioP.Leds -> LedsC;

}
