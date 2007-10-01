
#include "TestCase.h"

/**
 * Test all bounds of an isolated AmRegistryC component
 * @author David Moss
 */
configuration TestQueueC {
}

implementation {

  components //new TestCaseC() as TestTooManyMessagesC,
      //new TestCaseC() as TestMultipleMessagesC,
      new TestCaseC() as TestSingleMessageC;
      
  components TestQueueP,
      PriorityQueueC,
      new StateC(),
      LedsC;
  
  TestQueueP.AMSend -> PriorityQueueC.AMSend;
  TestQueueP.Leds -> LedsC;
  TestQueueP.State -> StateC;
  
  TestQueueP.SetUp -> TestSingleMessageC.SetUp;
  //TestQueueP.TestTooManyMessages -> TestTooManyMessagesC;
  TestQueueP.TestSingleMessage -> TestSingleMessageC;
  //TestQueueP.TestMultipleMessages -> TestMultipleMessagesC;
   
  /***************** QueueP Wrapper Configuration *****************/
  PriorityQueueC.SubSend -> TestQueueP.SubSend;
  TestQueueP.AM55 -> PriorityQueueC.AmRegistry[0x55];
  TestQueueP.AM56 -> PriorityQueueC.AmRegistry[0x56];
  TestQueueP.AM57 -> PriorityQueueC.AmRegistry[0x57];
  TestQueueP.AM58 -> PriorityQueueC.AmRegistry[0x58];
  
}

