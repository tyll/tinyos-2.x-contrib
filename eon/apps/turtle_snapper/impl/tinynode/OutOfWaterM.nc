includes structs;
#include "GetGPS.h"

module OutOfWaterM
{
  provides
  {
    interface StdControl;
    interface IOutOfWater;
  }
  uses
  {
  	interface Timer;
	command bool getLevel(uint16_t *data);
  }
}
implementation
{
#include "fluxconst.h"

#define WATER_SAMPLE_VALUE (1000L * 60L * 5L) //5 minutes

bool wet;
OutOfWater_out * node_out;

  command result_t StdControl.init ()
  {
  	wet = TRUE;
    return SUCCESS;
  }

  command result_t StdControl.start ()
  {
  	call Timer.start(TIMER_REPEAT, WATER_SAMPLE_VALUE);
    return SUCCESS;
  }

  command result_t StdControl.stop ()
  {
    return SUCCESS;
  }

  command result_t IOutOfWater.srcStart (OutOfWater_out * out)
  {
  	node_out = out;
    return SUCCESS;
  }
  
  event result_t Timer.fired()
  {
  	uint16_t level;
	bool newwet;
  	call getLevel(&level);
	
	newwet = (level > WETNESS_THRESHOLD);
	if (wet && !newwet && g_missed_last_reading)
	{
		signal IOutOfWater.srcFired(node_out);
	}
	wet = newwet;
	
  	return SUCCESS;
  }

}
