includes structs;

module UnitTestBeaconM
{
  provides
  {
    interface StdControl;
    interface UnitTest;
    interface SendMsg;
	interface VersionStore;
  }
  uses
    {
      interface Timer;
      interface IBeacon;
    }
}
implementation
{
#include "fluxconst.h"
#include "tinyunittest.h"
#include "beacon.h"

  Beacon_in node_in;
  Beacon_out node_out;
  
  Beacon_in node_in2;
  Beacon_out node_out2;
  
  
  Beacon_in* p_in;
  Beacon_out* p_out;
  
  #define TESTVERSION 5
  
  uint8_t num_sent;
  bool started, gotversion;
  TOS_Msg m_msg;
  
  //Simulated radio stack
  TOS_Msg* p_msg;

  command result_t StdControl.init ()
  {
  	p_in = &node_in;
	p_out = &node_out;
	started = FALSE;
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
	
  	memset(&node_in, 3, sizeof(Beacon_in));
	memset(&node_out, 5, sizeof(Beacon_out));
	memcpy(&node_in2, &node_in, sizeof(Beacon_in));
	memcpy(&node_out2, &node_out, sizeof(Beacon_out));
	num_sent = 0;
	started = TRUE;
	gotversion = FALSE;
	
	res = call Timer.start(TIMER_ONE_SHOT, BEACON_INTERVAL * BEACON_COUNT * 3);
	
	__TINY_TEST(res == SUCCESS, "Could not start timerout timer");
	
	res = call IBeacon.nodeCall(&p_in, &p_out);
	__TINY_TEST(res == SUCCESS, "Beacon nodeCall returned Fail");
	
    return res;
  }

  
  event result_t IBeacon.nodeDone(Beacon_in** in, Beacon_out** out, uint8_t error)
  {
  	int cin, cout;
	
  	__TINY_TEST(error == ERR_OK, "Beacon returned an error");
	__TINY_TEST(started == TRUE, "nodeDone but not started?");
	__TINY_TEST(*in == p_in, "Pointer error in");
	__TINY_TEST(*out == p_out, "Pointer error out");
	
	cin = memcmp(*in, p_in, sizeof(Beacon_in));
	cout = memcmp(*out, p_out, sizeof(Beacon_out));
	
	__TINY_TEST(cin == 0, "Changed input");
	__TINY_TEST(cout == 0, "Changed output");
	__TINY_TEST(gotversion == TRUE, "Changed output");
	
	call Timer.stop();
	signal UnitTest.TestDone(SUCCESS);
	
	
	return SUCCESS;
  }
  
  task void doSendDone()
  {
  	signal SendMsg.sendDone(p_msg, SUCCESS);
  }

  command result_t SendMsg.send( uint16_t address, uint8_t length, TOS_MsgPtr p)
  {
  	BeaconMsg_t* body = (BeaconMsg_t*)p->data;
  	num_sent++;
	
	__TINY_TEST(body->version_num == TESTVERSION, "WRONG VERSION");
	
  	p_msg = p;
  	post doSendDone();
  	return SUCCESS;
  }
  
  event result_t Timer.fired()
	{
		__TINY_TEST(started == TRUE, "node timeout but not started?");
		started = FALSE;
		signal UnitTest.TestDone(FAIL);
	  	return SUCCESS;
	}

	command result_t VersionStore.versionSet (uint16_t turtle_addr, uint8_t version_num)
	{
		__TINY_TEST(FALSE, "AAH!  Beacon should not set the version");
		return FAIL;
	}
  command result_t VersionStore.versionGet (uint16_t turtle_addr, uint8_t * version_num)
  {
  		if (version_num == NULL)
		{
			__TINY_TEST(FALSE, "versionGet NULL pointer.");
		}
  		gotversion = TRUE;
		*version_num = TESTVERSION;
		return SUCCESS;
  }
  command result_t VersionStore.versionIncrement ()
  {
  		__TINY_TEST(FALSE, "AAH!  Beacon should not increment version");
		return FAIL;
  } 
  
  command result_t VersionStore.versionReadFromFlash()
  {
  		__TINY_TEST(FALSE, "AAH!  Beacon should not read version from flash");
		return FAIL;
  }
  
}
