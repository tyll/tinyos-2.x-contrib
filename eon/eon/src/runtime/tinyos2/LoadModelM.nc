



module LoadModelM
{
  provides
  {
  	interface Init;
    interface StdControl;
    interface ILoadModel;
  }

  uses
  {
    interface Timer<TMilli> as Timer0;
	interface RuntimeState;
  }

}

implementation
{

#include "rt_structs.h"
	
	uint32_t event_count;
	uint32_t prediction;
	
	


  command error_t Init.init ()
  {
  	__runtime_state_t *rtstate;
	rtstate = call RuntimeState.getState();
	event_count = 0;
	prediction = 0;
	rtstate->load_avg = 0;
	return SUCCESS;
  }

  command error_t StdControl.start ()
  {
    //call Timer.start (TIMER_REPEAT, 60L * 60L * 1024L);	//60min timer
	call Timer0.startPeriodic(60L * 1024L);	//60s timer
    return SUCCESS;
  }

  command error_t StdControl.stop ()
  {
    call Timer0.stop ();
    return SUCCESS;
  }

	

  event void Timer0.fired ()
  {
  	double d_events;
	__runtime_state_t *rtstate;
	
	rtstate = call RuntimeState.getState();
	
  	d_events = event_count;
	rtstate->load_avg = (rtstate->load_avg * (1.0 - LOAD_WEIGHT)) + (d_events * LOAD_WEIGHT);
	event_count = 0;
	
	prediction = rtstate->load_avg;
  }

  command error_t ILoadModel.pathDone(uint16_t pathNum)
  {
  	//check that path is not timed.
  	if (isPathTimed[pathNum]) return SUCCESS;
  	
  	//else
  	event_count++;
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
