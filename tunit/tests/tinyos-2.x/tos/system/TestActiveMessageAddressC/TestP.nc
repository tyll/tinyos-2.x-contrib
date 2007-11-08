
#include "TestCase.h"

module TestP {
  uses {
    interface TestCase as TestSet;
    interface ActiveMessageAddress;
  }
}

implementation {

  enum {
    GROUP = 50,
    ADDRESS = 2048,
  };
  
  
  /**
   * Change the node's active message address parameters.  Verify the changed()
   * event gets fired (otherwise timeout) and verify each setting.
   */
  event void TestSet.run() {
    assertEquals("Wrong init address", 0, call ActiveMessageAddress.amAddress());
    assertEquals("Wrong init group", 0x22, call ActiveMessageAddress.amGroup());
    call ActiveMessageAddress.setAddress(GROUP, ADDRESS);
  }
  
  async event void ActiveMessageAddress.changed() {
    assertEquals("Wrong group", GROUP, call ActiveMessageAddress.amGroup());
    assertEquals("Wrong address", ADDRESS, call ActiveMessageAddress.amAddress());
    call TestSet.done();
  }
  
}

