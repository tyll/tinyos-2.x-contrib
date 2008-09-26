



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

enum {
LOAD_HISTORY = 24,
LOAD_DOUBT = 8;

}
	
	uint32_t event_count;
	uint32_t prediction;
	uint32_t history[LOAD_HISTORY];
	uint8_t history_index;


  command result_t StdControl.init ()
  {
	event_count = 0;
	prediction = 0;
	memset(history, 0, sizeof(history));
	return SUCCESS;
  }

  command result_t StdControl.start ()
  {
    call Timer.start (TIMER_REPEAT, 60 * 60 * 1024);	//60min timer
    return SUCCESS;
  }

  command result_t StdControl.stop ()
  {
    call Timer.stop ();
    return SUCCESS;
  }

	uint32_t getMaxValue(uint32_t limit, bool dolimit)
	{
		uint32_t max = 0;
		int i;
		
		for (i=0; i < LOAD_HISTORY; i++)
		{
			if (history[i] > max && (history[i] < limit || !dolimit))
			{
				max = history[i];
			}
		}
		return max;
	}

  task void PredictTask()
  {
	int i= 0;
	int samples = LOAD_HISTORY / LOAD_DOUBT;
	bool limit = FALSE;
	uint32_t last_sample, next_sample;
	
	for (i=0; i < samples; i++)
	{
		last_sample = getMaxValue(last_sample, limit);
		limit = TRUE;
	}
	cur_prediction = last_sample;
  }

  event result_t Timer.fired ()
  {
  	atomic {
		history[history_index] = event_count;
		event_count = 0;
		history_index = (history_index +1) % LOAD_HISTORY;
	}
	post PredictTask();
    return SUCCESS;
  }

  command result_t pathDone(uint16_t pathNum)
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
		
		result = cur_prediction * hours32;
		return result;
	}

  

}
