includes structs;

module GetGPSM
{
  provides
  {
    interface StdControl;
    interface IGetGPS;
  }
  uses
  {
  	interface StdControl as GpsControl;
	
	interface ConnMgr;
  	interface GpsFix;
	
	interface Timer as GpsTimer;
	interface Timer as SNRTimer;
	interface Timer as LockTimer;
	interface SysTime;
	interface IAccum;
	interface Leds;
  }
}
implementation
{

#include "GetGPS.h"

#define MAX_HDILUTION	50L
#define VALID_VALUE		0x01

#define LOCK_WAIT		500
#define LOCK_RETRIES	10

GetGPS_in* node_in;
GetGPS_out* node_out;


bool gotfix;
int snrcount;
int retries;


  command result_t StdControl.init ()
  {
  	call Leds.init();
  	call GpsControl.init();
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

  
  
  void signalDone()
  {
  		call ConnMgr.unlock();
  		call LockTimer.stop();
  		call GpsTimer.stop();
		call SNRTimer.stop();
		call GpsControl.stop();
		g_in_gps = FALSE;
		call ConnMgr.radioOn();
		signal IGetGPS.nodeDone(node_in, node_out, ERR_OK);
  }
  
  task void GpsStartTask()
  {
  	//turn on GPS
	call GpsControl.start();
	//turn off radio---maybe
	call ConnMgr.radioOff();
	call GpsTimer.start(TIMER_ONE_SHOT, ((uint32_t)GPS_TIMEOUT)*1000L);
	
	//timer to stop early to do an Signal-to-noise ratio check
	//to see if it makes sense to continue
	call SNRTimer.start(TIMER_ONE_SHOT, ((uint32_t)SNR_TIMEOUT)*1000L);
  }
  
  task void LockTask()
  {
  	if (call ConnMgr.lock() == SUCCESS)
	{
		post GpsStartTask();
	} else {
		retries--;
		if (retries <= 0)
		{
			//try anyway.
			post GpsStartTask();
		} else {
			call LockTimer.start(TIMER_ONE_SHOT, LOCK_WAIT);
		}
	}
  }
  
  event result_t LockTimer.fired()
  {
  	
  	post LockTask();
	return SUCCESS;
  }
  
  //GetGPS
  // IN:	
  // OUT: 	GpsData_t data
  command result_t IGetGPS.nodeCall (GetGPS_in * in, GetGPS_out * out)
  {
//PUT NODE IMPLEMENTATION HERE
	node_in = in;
	node_out = out;
	
	gotfix = FALSE;
	
	node_out->data.timevalid = FALSE;
	
	node_out->toofew = FALSE;
	memset((node_out->data.date), 0, NMEA_CHARS_PER_FIELD);
	memset((node_out->data.time), 0, NMEA_CHARS_PER_FIELD);
	memset(&(node_out->data.fix), 0, sizeof((node_out->data.fix)));

	
#ifdef GPSTEST
	//start_time = call SysTime.getTime32();
	start_time = 0;
#endif
	
	
	node_out->numsats  = 0;
	
	g_in_gps = TRUE;
	retries = LOCK_RETRIES;
	
	//it turns out that at voltages < 3.85
	//GPS performance degrades badly.
	//This may be a property of the GPS units, but more
	//likely a combination of the chosen battery and power supply, just not being
	//able to source enough current.
	if (call IAccum.getVoltage() < 3850 || !g_active)
	{
		node_out->toofew = TRUE;
		signalDone();
		return SUCCESS;
	}
	post LockTask();
	
	/*		
	//turn on GPS
	call GpsControl.start();
	//turn off radio
	call ConnMgr.radioOff();
	call GpsTimer.start(TIMER_ONE_SHOT, ((uint32_t)GPS_TIMEOUT)*1000L);
	
	//timer to stop early to do an Signal-to-noise ratio check
	//to see if it makes sense to continue
	call SNRTimer.start(TIMER_ONE_SHOT, ((uint32_t)SNR_TIMEOUT)*1000L);
	*/
	return SUCCESS;
}


  
  task void AreWeDoneYet()
  {

  	if (gotfix 
		 && node_out->data.timevalid
		 && node_out->data.fix.hdilution <= MAX_HDILUTION
		 && node_out->data.fix.hdilution >= 5)
	{
		signalDone();
		
	}
  }
  
  event result_t GpsFix.gotFix(GpsFixPtr fix)
  {
  	//new fix
	//we want to record this one if
	// 1) we haven't got a valid fix yet ('cuz it might have some useful data)
	// 2) we already have a fix but this one is better (bettery hdop) 
	// 		-- beware of null HDOP.  Seems like it shouldn't every happen
	//			but sometimes it does.
	
	if (!gotfix || (fix->hdilution < node_out->data.fix.hdilution))
	{
  		memcpy(&(node_out->data.fix), fix, sizeof(GpsFixData));
		if (fix->valid && fix->hdilution >= 5)
		{
			
			gotfix = TRUE;
			
			call GpsTimer.start(TIMER_ONE_SHOT, ((uint32_t)GPS_IMPROVEMENT_TIMEOUT)*1000L);
			post AreWeDoneYet();
		} else {
			//need to set this since it seems we can have this corner case
			//where the HDOP gets set to zero and that throws off the
			//reasoning that lower HDOP is better
			node_out->data.fix.hdilution = 255;
		}
	}
	
	return SUCCESS;
  }
  
  event result_t GpsFix.gotDateTime(bool valid, char *gpsdate, char *gpstime)
  {
  	if (valid)
	{
		call Leds.redToggle();
	}
  	if (!node_out->data.timevalid ||  valid)
	{
  		memcpy((node_out->data.date), gpsdate, NMEA_CHARS_PER_FIELD);
		memcpy((node_out->data.time), gpstime, NMEA_CHARS_PER_FIELD);
		if (valid || (node_out->data.date[4] == 0 && node_out->data.date[5] > 7))
		{
			
			node_out->data.timevalid = TRUE;
			
		}
	}
	
	
	post AreWeDoneYet();
	return SUCCESS;
  }
  
  
  
  event result_t GpsTimer.fired()
  {
  	signalDone();
	return SUCCESS;
  }
  
  event result_t SNRTimer.fired()
  {
  	int highCount;
  	//time to check the SNR
	highCount = call GpsFix.numSNRHigh(SNR_THOLD);
	
	node_out->numsats = highCount;	
	//if SNR is too low, 
	//or if the battery voltage is too low, then
	//there's no point in continuing.
	if (highCount < 3 || call IAccum.getVoltage() < 3800)
	{
		node_out->toofew = TRUE;
		signalDone();
	}
	return SUCCESS;
  }
  
  event void IAccum.update(int32_t inuJ, int32_t outuJ)
  {
  }
}
