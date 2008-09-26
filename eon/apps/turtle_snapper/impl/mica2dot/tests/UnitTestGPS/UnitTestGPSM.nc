includes structs;

module UnitTestGPSM
{
  provides
  {
    interface StdControl;
    interface UnitTest;
    interface StdControl as GpsControl;
    interface GpsFix;
  }
  uses
    {
      interface Timer;
      interface Timer as FixMsgTimer;
      interface Timer as FixTimer;
      interface Timer as DTTimer;
      interface IGetGPS;
    }
}
implementation
{
#include "fluxconst.h"
#include "tinyunittest.h"
#include "GetGPS.h"

#define FAKE_DATE "12251989"
#define FAKE_TIME "120378.54"

  GetGPS_in node_in;
  GetGPS_out node_out;
  
  GetGPS_in node_in2;
  GetGPS_out node_out2;
  
  
  GetGPS_in* p_in;
  GetGPS_out* p_out;
  
  
  uint8_t num_sent;
  bool started;
  bool gc_start, gc_stop;
  bool gotfix, gotdt;
  bool fixfail;
  bool dtfail;
  
  
  GpsFixData data;
  

	
  command result_t StdControl.init ()
  {
  	p_in = &node_in;
	p_out = &node_out;
	started = FALSE;
	
	data.valid = TRUE;	
	data.hr = 5;
	data.min = 40;
	data.sec = 25;
	data.lat_deg = 43;
	data.lat_min = 2335;
	data.ns = 0;
	data.long_deg = 124;
	data.long_min = 2342;
	data.ew = 1;
	data.sats = 8;
	data.hdilution = 3;
	data.altitude = 145;  

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
	
  	memset(&node_in, 3, sizeof(GetGPS_in));
	memset(&node_out, 0, sizeof(GetGPS_out));
	memcpy(&node_in2, &node_in, sizeof(GetGPS_in));
	memcpy(&node_out2, &node_out, sizeof(GetGPS_out));
	
	
	num_sent = 0;
	started = TRUE;
	gc_start = FALSE;
	gc_stop = FALSE;
	gotfix = FALSE;
	gotdt = FALSE;
	
	//randomly decide what will happen
	srand(clock() * TOS_LOCAL_ADDRESS);
	r = (rand() >> 4) % 100;
	fixfail = FALSE;
	dtfail = FALSE;
	if (r >= 25 && r < 50) 
	{
		fixfail = TRUE;
		dtfail = FALSE;
	}
	if (r >= 50 && r < 75) 
	{
		fixfail = FALSE;
		dtfail = TRUE;
	}
	if (r >= 75) 
	{
		fixfail = TRUE;
		dtfail = TRUE;
	}
	
	res = call Timer.start(TIMER_ONE_SHOT, ((uint32_t)(GPS_TIMEOUT + 5)) * 1024);
	__TINY_TEST(res == SUCCESS, "Could not start timerout timer");
	
	res = call IGetGPS.nodeCall(&p_in, &p_out);
	__TINY_TEST(res == SUCCESS, "GetGPS nodeCall returned Fail");
	
    return res;
  }

  
  event result_t IGetGPS.nodeDone(GetGPS_in** in, GetGPS_out** out, uint8_t error)
  {
  	int cin, cout, fixc;
	
	call Timer.stop();
	
  	
	
	__TINY_TEST(started == TRUE, "nodeDone but not started?");
	__TINY_TEST(*in == p_in, "Pointer error in");
	__TINY_TEST(*out == p_out, "Pointer error out");
	
	cin = memcmp(*in, p_in, sizeof(GetGPS_in));
	//make sure they didn't muck with the runtime system's data
	cout = memcmp(&((*out)->_pdata), &(p_out->_pdata), sizeof(rt_data));
	__TINY_TEST(cin == 0, "Changed input");
	__TINY_TEST(cout == 0, "Changed output rtdata");
	
	
	__TINY_TEST(gc_start == TRUE, "Never started GPS unit");
	__TINY_TEST(gc_stop == TRUE, "Forgot to stop GPS unit");
	
	if (fixfail)
	{
		__TINY_TEST(error == ERR_USR, "GetGPS did not return an error (but should)");
	} else {
		__TINY_TEST(error == ERR_OK, "GetGPS returned an error (but should not have)");
		fixc = memcmp(&data, &((*out)->data.fix), sizeof(GpsFixData));
		__TINY_TEST(fixc == 0, "Fix data corruption.");
		__TINY_TEST((*out)->data.fix.valid == 1, "Invalid fix");
	}

	
		
	signal UnitTest.TestDone(SUCCESS);
	
	
	return SUCCESS;
  }
  
  

   command result_t GpsControl.init ()
  {
	__TINY_TEST(started == FALSE, "GetGPS Should not call init()");
	return SUCCESS;
  }

  command result_t GpsControl.start ()
  {
  	uint32_t fval, dtval;
	 
  	__TINY_TEST(gc_start == FALSE, "Already started");
	__TINY_TEST(gc_stop == FALSE, "Already stopped");
	gc_start = TRUE;
	
	__TINY_TEST_INFO(fixfail == TRUE, "FixFail");
	__TINY_TEST_INFO(dtfail == TRUE, "DTFail");
	
	if (fixfail == FALSE)
	{
		fval = (rand() % (GPS_TIMEOUT * 512)) + 2048;
		call FixTimer.start(TIMER_ONE_SHOT, fval);
	}
	
	if (dtfail == FALSE)
	{
		dtval = (rand() % (GPS_TIMEOUT * 512)) + 2048;
		call DTTimer.start(TIMER_ONE_SHOT, dtval);
	}
	call FixMsgTimer.start(TIMER_REPEAT, 1024);
    return SUCCESS;
  }

  command result_t GpsControl.stop ()
  {
  	call FixMsgTimer.stop();
	call FixTimer.stop();
	call DTTimer.stop();
	
  	__TINY_TEST(gc_start == TRUE, "Not yet started");
	__TINY_TEST(gc_stop == FALSE, "Already stopped(2)");
	gc_stop = TRUE;
	
	__TINY_TEST((fixfail || gotfix), "fixfail(FALSE) and did not get fix!");
	__TINY_TEST((dtfail || gotdt), "dtfail(FALSE) and did not get dt!");
	__TINY_TEST((!fixfail || !gotfix), "fixfail(TRUE) but did get fix!");
	__TINY_TEST((!dtfail || !gotdt), "dtfail(TRUE) but did get dt!");
	
    return SUCCESS;
  }
  
  
  
  
  event result_t FixTimer.fired()
  {
  	__TINY_TEST(gc_start == TRUE,"FixTimer fired but not started?");
	__TINY_TEST(gc_stop == FALSE,"FixTimer fired but already stopped?");
  	
	gotfix = TRUE;
	
  	return SUCCESS;
  }
  
  event result_t FixMsgTimer.fired()
  {
  	__TINY_TEST(gc_start == TRUE,"FixMsgTimer fired but not started?");
	__TINY_TEST(gc_stop == FALSE,"FixMsgTimer fired but already stopped?");
  	
	data.valid = gotfix;
	signal GpsFix.gotFix(&data);
	return SUCCESS;
  }
  
  event result_t DTTimer.fired()
  {
  	__TINY_TEST(gc_start == TRUE,"DTTimer fired but not started?");
	__TINY_TEST(gc_stop == FALSE,"DTTimer fired but already stopped?");
  	
	signal GpsFix.gotDateTime(FAKE_DATE, FAKE_TIME);
	gotdt = TRUE;
	
	
  	return SUCCESS;
  }
  
  event result_t Timer.fired()
	{
		__TINY_TEST(started == TRUE, "node timeout but not started?");
		started = FALSE;
		signal UnitTest.TestDone(FAIL);
	  	return SUCCESS;
	}

  
}
