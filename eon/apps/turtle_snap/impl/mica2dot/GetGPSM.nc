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
  	interface GpsFix;
	interface Timer as CountTimer;
	interface Timer as GpsTimer;
	interface Leds;
	interface SysTime;
	command bool getLevel(uint16_t *data);
  }
}
implementation
{
#include "fluxconst.h"
#include "GetGPS.h"

#define MAX_HDILUTION	50
#define VALID_VALUE		0x01
#define TIMER_RES 500000L
#define GPSTEST


GetGPS_in** node_in;
GetGPS_out** node_out;

uint16_t waterlevel;
bool gotfix, gotdatetime;
#ifdef GPSTEST
	uint16_t start_time;
#endif


  command result_t StdControl.init ()
  {
  	
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

  command bool IGetGPS.ready ()
  {
//PUT READY IMPLEMENTATION HERE

    return TRUE;
  }

  
  /*task void waterCheck()
  {
  	call WaterControl.start();
	call WaterTimer.start(TIMER_REPEAT, 400);
	
  }*/
  
  //GetGPS
  // IN:	
  // OUT: 	GpsData_t data
  command result_t IGetGPS.nodeCall (GetGPS_in ** in, GetGPS_out ** out)
  {
//PUT NODE IMPLEMENTATION HERE
	node_in = in;
	node_out = out;
	
	gotfix = FALSE;
	gotdatetime = FALSE;

	memset(((*node_out)->data.date), 0, NMEA_CHARS_PER_FIELD);
	memset(((*node_out)->data.time), 0, NMEA_CHARS_PER_FIELD);
	memset(&((*node_out)->data.fix), 0, sizeof(((*node_out)->data.fix)));

	//(*node_out)->data.fix.altitude = (*in)->howwet;
#ifdef GPSTEST
	//start_time = call SysTime.getTime32();
	start_time = 0;
#endif
	
	//FIXME: altitude is not wetness
	call getLevel(&((*node_out)->data.fix.altitude));
	waterlevel = (*node_out)->data.fix.altitude;
	
	if ((*node_out)->data.fix.altitude > WETNESS_THRESHOLD)
	{
		signal IGetGPS.nodeDone (node_in, node_out, ERR_OK);
		return SUCCESS;
	} else {
		call GpsControl.start();
		call GpsTimer.start(TIMER_REPEAT, ((uint32_t)GPS_TIMEOUT)*1024L);
		call CountTimer.start(TIMER_REPEAT, 1024);
	}
	
	return SUCCESS;
}

/*
	
#ifdef GPSTEST
	start_time = call SysTime.getTime32();
	(*node_out)->data.fix.altitude = 0;
	//(*in)->howwet = 0;
#endif

	//how wet am I?
	if ((*in)->howwet > WETNESS_THRESHOLD)
	{
		//too wet to try
		signal IGetGPS.nodeDone (in, out, ERR_OK);
		return SUCCESS;
	}
	
	//start the timeout timer
	call Timer.start(TIMER_ONE_SHOT, ((uint32_t)GPS_TIMEOUT)*1024);
	
	//turn on the GPS and inverter
	call GpsControl.start();
	
//Done signal can be moved if node makes split phase calls.
    //signal IGetGPS.nodeDone (in, out, ERR_OK);
    return SUCCESS;
  }*/
  
  /*event result_t WaterTimer.fired()
  {
  	bool valid;
	uint16_t level;

  	call WaterTimer.stop();
	valid = call getLevel(&level);
	call WaterControl.stop();
	
	
	waterlevel = level;
	(*node_out)->data.fix.altitude = level;
	if (!valid || level > WETNESS_THRESHOLD)
	{
		signal IGetGPS.nodeDone (node_in, node_out, ERR_OK);
		return SUCCESS;
	} else {
		call GpsControl.start();
		call GpsTimer.start(TIMER_REPEAT, ((uint32_t)GPS_TIMEOUT)*1024);
	}
  }*/
  
  task void AreWeDoneYet()
  {
//  	#ifdef GPSTEST
//  		uint32_t end_time, elapsed;
//	#endif
  
  	if (gotfix 
		 && gotdatetime
		 && (*node_out)->data.fix.hdilution <= MAX_HDILUTION)
	{
		call GpsTimer.stop();
		call CountTimer.stop();
		call GpsControl.stop();
		
		#ifdef GPSTEST
//			end_time = call SysTime.getTime32();
//			if (end_time < start_time)
//			{
//				elapsed = (0xFFFFFFFF - start_time) + end_time;
//			} else {
//				elapsed = end_time - start_time;
//			}
			(*node_out)->data.fix.altitude = start_time; //piggy back here
		#endif
		
		
		signal IGetGPS.nodeDone(node_in, node_out, ERR_OK);
		
	}
  }
  
  event result_t GpsFix.gotFix(GpsFixPtr fix)
  {
  	
	  if (fix->valid == VALID_VALUE) 
	{
		if (
				  !gotfix ||
				  fix->hdilution < (*node_out)->data.fix.hdilution
		   )
		{
  		memcpy(&((*node_out)->data.fix), fix, sizeof(GpsFixData));
		(*node_out)->data.fix.altitude = waterlevel;
		gotfix = TRUE;
		post AreWeDoneYet();
		}
	}
	return SUCCESS;
  }
  
  event result_t GpsFix.gotDateTime(char *gpsdate, char *gpstime)
  {
  	//
  	memcpy(((*node_out)->data.date), gpsdate, NMEA_CHARS_PER_FIELD);
	memcpy(((*node_out)->data.time), gpstime, NMEA_CHARS_PER_FIELD);
	gotdatetime = TRUE;
	post AreWeDoneYet();
	return SUCCESS;
  }
  
  event result_t CountTimer.fired()
  {
  	start_time++;
	return SUCCESS;
  }
  
  event result_t GpsTimer.fired()
  {
  	//we timed out.
	call GpsTimer.stop();
	call CountTimer.stop();
	call GpsControl.stop();
	
#ifdef GPSTEST
		//(*node_out)->data.fix.altitude = 0xFFFF; //piggy back here
		(*node_out)->data.fix.altitude = start_time; //piggy back here
#endif
	
	if (gotfix)
	{
		//memset(((*node_out)->data.date), 0, NMEA_CHARS_PER_FIELD);
		//memset(((*node_out)->data.time), 0, NMEA_CHARS_PER_FIELD);
		signal IGetGPS.nodeDone(node_in, node_out, ERR_OK);
	} else {
		//signal IGetGPS.nodeDone(node_in, node_out, ERR_USR);
		//changed this so that I could verify that failed attempts happened
		signal IGetGPS.nodeDone(node_in, node_out, ERR_OK);
	}
	return SUCCESS;
  }
}
