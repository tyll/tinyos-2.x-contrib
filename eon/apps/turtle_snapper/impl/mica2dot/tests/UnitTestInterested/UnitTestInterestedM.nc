includes structs;

module UnitTestInterestedM
{
  provides
  {
    interface StdControl;
    interface UnitTest;
    interface VersionStore;
    interface SendMsg;
  }
  uses
    {
      interface Timer;
      interface IInterested;
	  //interface Random;
    }
}
implementation
{
#include "fluxconst.h"
#include "tinyunittest.h"


#define TEST_ADDR  7
#define TEST_VERSION 5
#define TEST_TIMEOUT 2


  Interested_in node_in;
  Interested_out node_out;
  
  Interested_in node_in2;
  Interested_out node_out2;
  
  
  Interested_in* p_in;
  Interested_out* p_out;
  
  bool started;
  int num_sent;

	
  command result_t StdControl.init ()
  {
  	p_in = &node_in;
	p_out = &node_out;
	started = FALSE;
	
	node_in.addr = TEST_ADDR;
	
    return SUCCESS;
  }

  command result_t StdControl.start ()
  {
    return SUCCESS;
  }

  command result_t StdControl.stop ()
  {
    return SUCCESS;
  }

  command result_t UnitTest.StartTest ()
  {
  	result_t res;
	int r;
	
	node_in.addr = TEST_ADDR;
	node_in.version = TEST_VERSION;	
	
	num_sent = 0;
	started = TRUE;
	
	res = call Timer.start(TIMER_ONE_SHOT, ((uint32_t)(TEST_TIMEOUT)) * 1024);
	__TINY_TEST(res == SUCCESS, "Could not start timeout timer");
	
	res = call IInterested.nodeCall(&p_in, &p_out);
	__TINY_TEST(res == SUCCESS, "IInterested nodeCall returned Fail");
	
    return res;
  }

  
  event result_t IInterested.nodeDone(Interested_in** in, Interested_out** out, uint8_t error)
  {
  	int cin, cout, fixc;
	
	call Timer.stop();
	
  	
	
	__TINY_TEST(started == TRUE, "nodeDone but not started?");
	__TINY_TEST(*in == p_in, "Pointer error in");
	__TINY_TEST(*out == p_out, "Pointer error out");
	
	cin = memcmp(*in, p_in, sizeof(Interested_in));
	//make sure they didn't muck with the runtime system's data
	cout = memcmp(&((*out)->_pdata), &(p_out->_pdata), sizeof(rt_data));
	__TINY_TEST(cin == 0, "Changed input");
	__TINY_TEST(cout == 0, "Changed output rtdata");
	

	

	
		
	signal UnitTest.TestDone(SUCCESS);
	
	
	return SUCCESS;
  }
  
  

  
  
}
