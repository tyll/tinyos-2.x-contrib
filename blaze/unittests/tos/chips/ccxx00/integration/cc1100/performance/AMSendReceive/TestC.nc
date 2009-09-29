
#include "CC1100.h"

configuration TestC {
}

implementation {
  components new TestCaseC() as TestAmC;
  
  components ActiveMessageC,
      new AMSenderC(0),
      new AMReceiverC(0),
      LedsC,
      TestP;
   
  TestP.SetUpOneTime -> TestAmC.SetUpOneTime;
  TestP.TearDownOneTime -> TestAmC.TearDownOneTime;
  TestP.TestAm -> TestAmC;
  
  TestP.SplitControl -> ActiveMessageC;
  TestP.AMSend -> AMSenderC;
  TestP.PacketAcknowledgements -> ActiveMessageC;
  TestP.Receive -> AMReceiverC;
  TestP.Leds -> LedsC;
  
}

