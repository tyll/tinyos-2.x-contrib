



module LoadModelM
{
  provides
  {
    interface StdControl;
    interface ILoadModel;
  }

  uses
  {
    interface Timer;
  }

}

implementation
{

#include "rt_structs.h"
	
	uint32_t event_count;
	uint32_t prediction;
	
	


  command result_t StdControl.init ()
  {
	event_count = 0;
	prediction = 0;
	__rtstate.load_avg = 0;
	return SUCCESS;
  }

  command result_t StdControl.start ()
  {
    //call Timer.start (TIMER_REPEAT, 60L * 60L * 1024L);	//60min timer
	call Timer.start (TIMER_REPEAT, 60L * 1024L);	//60s timer
    return SUCCESS;
  }

  command result_t StdControl.stop ()
  {
    call Timer.stop ();
    return SUCCESS;
  }

	/*uint32_t getMaxValue(uint32_t limit, bool dolimit)
	{
		uint32_t max = 0;
		int i;
		
		for (i=0; i < LOAD_HISTORY; i++)
		{
			if (__rtstate.load_history[i] > max && (__rtstate.load_history[i] < limit || !dolimit))
			{
				max = __rtstate.load_history[i];
			}
		}
		return max;
	}*/

  /*task void PredictTask()
  {
	int i= 0;
	int samples = LOAD_HISTORY / LOAD_DOUBT;
	bool limit = FALSE;
	uint32_t last_sample = 0;
	//uint32_t next_sample;
	
	for (i=0; i < samples; i++)
	{
		last_sample = getMaxValue(last_sample, limit);
		limit = TRUE;
	}
	prediction = last_sample;
  }*/

  event result_t Timer.fired ()
  {
  	double d_events;
	
  	atomic {
		d_events = event_count;
		__rtstate.load_avg = (__rtstate.load_avg * (1.0 - LOAD_WEIGHT)) + (d_events * LOAD_WEIGHT);
		event_count = 0;
	}
	prediction = __rtstate.load_avg;
    return SUCCESS;
  }

  command result_t ILoadModel.pathDone(uint16_t pathNum)
  {
  	//check that path is not timed.
  	if (isPathTimed[pathNum]) return SUCCESS;
  	
  	//else
  	atomic event_count++;
	return SUCCESS;
	
  }
  
	command int32_t ILoadModel.getLoadPrediction(uint16_t hours)
	{
		//give the current prediction in terms of hours.
		uint32_t result;
		uint32_t hours32 = hours;
		
		result = prediction * hours32;
		return result;
	}

  

}
