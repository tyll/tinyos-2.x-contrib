includes structs;
//#include "GetGPS.h"

module GoodMorningM
{
  provides
  {
    interface StdControl;
    interface IGoodMorning;
	interface Calib;
  }
  uses
  {
  	interface Timer;
	interface IDayNight;
  }
}
implementation
{
#include "fluxconst.h"

#define HOUR_TIMER_VALUE (1000L * 60L * 60L * 1L) //1 hours
#define HOURS_BN_MORNINGS (22L)  //at least 22 hours between signals

bool day;
int night_hours;
int hrs_since_morning;
GoodMorning_out * node_out;

  command result_t StdControl.init ()
  {
  	day = TRUE;
	night_hours = 0;
	hrs_since_morning = 0;
    return SUCCESS;
  }

  command result_t StdControl.start ()
  {
  	call Timer.start(TIMER_REPEAT, HOUR_TIMER_VALUE);
    return SUCCESS;
  }

  command result_t StdControl.stop ()
  {
  	call Timer.stop();
    return SUCCESS;
  }

  command result_t IGoodMorning.srcStart (GoodMorning_out * out)
  {
  	node_out = out;
    return SUCCESS;
  }
  
  command result_t Calib.init()
  {
  	return signal IGoodMorning.srcFired(node_out); 
  }
  
  event result_t Timer.fired()
  {
  	
	//if (night) night_hours++;	
	hrs_since_morning++;
	
  	return SUCCESS;
  }
  
  event void IDayNight.update(bool isDay)
  {
  	day = isDay;
  	if (!isDay) 
	{
		night_hours++;
	} else {
		if (night_hours > 0 && hrs_since_morning >= HOURS_BN_MORNINGS)
		{
			signal IGoodMorning.srcFired(node_out);
			hrs_since_morning = 0;
		}
		night_hours = 0;
	}
	
  }

}
