
module RunUnitTestsM
{
  provides
  {
    interface StdControl;
    
  }
  uses
    {
      interface UnitTest[uint8_t id];
    }
}
implementation
{

#include "tinyunittest.h"

  uint8_t testcount;

  task void NextTest()
  {
  	result_t res;
	
  	if (testcount >= uniqueCount("TestCase"))
	{
		return;
	} else {
		res = call UnitTest.StartTest[testcount]();
		__TINY_TEST_VAR(res == SUCCESS, "StartTest failed %d",testcount);
		if (res == FAIL)
		{
			testcount++;
			post NextTest();
		}
	}	
  }
  
  default command result_t UnitTest.StartTest[uint8_t id]()
  {
  	return FAIL;
  }
  
  command result_t StdControl.init ()
  {
  	
    return SUCCESS;
  }

  command result_t StdControl.start ()
  {
  	testcount = 0;
	post NextTest();
    return SUCCESS;
  }

  command result_t StdControl.stop ()
  {
    return SUCCESS;
  }

  event result_t UnitTest.TestDone[uint8_t id] (result_t testresult)
  {
  	result_t res;
	
  	__TINY_TEST_VAR(testresult == SUCCESS, "Test %d finished", id);
	
    return res;
  }

  
  


  
}

