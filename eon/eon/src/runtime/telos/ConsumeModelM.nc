

module ConsumeModelM
{
  provides
  {
    interface StdControl;
    interface IConsumeModel;
  }

  uses
  {
    interface Random;
  }

}

implementation
{

enum {
PATH_ENERGY_WEIGHT = 5,

}
	
	uint32_t event_count;
	uint32_t prediction;
	
	uint8_t srcprob[NUMSOURCES];
	uint8_t prob[NUMPATHS];
	int32_t pathenergy[NUMPATHS];
	uint8_t history_index;


  command result_t StdControl.init ()
  {
  	int i=0;
  	int j=0;
  	int numpaths = 0;
  	
  	for (j=0; j < NUMSOURCES; j++)
  	{
  		numpaths = 0;
  		for (i=0; i < NUMPATHS; i++)
  		{
  			if (pathSrc[i] == j) numpaths++;
  		}
  		for (i=0; i < NUMPATHS; i++)
  		{
  			prob[i] = (100 / numpaths);
  		}
  	}
  	
  	for (i=0; i < NUMPATHS; i++)
  	{
  		pathenergy[i] = -1;
  	}
  	call Random.init();
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

	/*uint32_t getMaxValue(uint32_t limit, bool dolimit)
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
*/
  /*task void PredictTask()
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
*/
  

  command result_t pathDone(uint16_t pathNum, 
  							uint8_t state, 
  							uint32_t energy)
  {
  	uint16_t rnd;
  	int i, sum;
  	int src;
  	
  	src = pathSrc[pathNum];
  	
  	//update src probabilities.
  	if (!isTimedPath[numPath])
  	{
  		atomic
  		{
  			srcprob[src]++;
  			//get random number(1-100)
  			rnd = (call Random.rand() % 100)+1;
			//deduct
			i=0;
  			sum = 0;
  			while (sum < rnd && i < NUMPATHS-1)
  			{
  				sum += srcprob[i];
  				if (sum >= rnd) break;
  				i++;
  			}
  			srcprob[i]--;
  		}
  	} //end srcprob adjustment
  	
  	//update path probabilities.
  	atomic
  	{
  		prob[pathNum]++;
  		//get random number(1-100)
  		rnd = (call Random.rand() % 100)+1;
		//deduct
		i=0;
  		sum = 0;
  		while (sum < rnd && i < NUMPATHS-1)
  		{
  			//is same source
  			if (pathSrc[i] == src)
  			{
  				sum += prob[i];
  				if (sum >= rnd) break;
  			}
  			i++;
  		}
  		prob[i]--;
  	}
  	
  	//update energy estimate
  	
  	if (pathenergy[pathNum] == -1)
  	{
  		pathenergy[pathNum] = energy * 100;
  	} else {
  		pathenergy[pathNum] = ((pathenergy[pathNum] * (PATH_ENERGY_WEIGHT-1)) + (energy * 100)) / PATH_ENERGY_WEIGHT;
  	}
  	
  	
  	
	return SUCCESS;
	
  }
  
  
  	command uint32_t getComsumePrediction(uint16_t hours, 
  											uint32_t xevents, 
  											uint8_t state,
  											bool min)
	{
		uint32_t energysum  = 0;
		uint32_t hours32 = hours;
		uint32_t pathsum = 0;
		uint32_t timedrate;	
		int i=0;
		int j=0;
		
		for (i=0; i < NUMPATHS; i++)
		{
			//cost of path
			pathsum = ((xevents * prob[i]) / 100) * (pathenergy[i]/100);
			energysum += pathsum;
		}
		
		//now add timed srcs
		for (j=0; j < NUMSOURCES; j++)
		{
			for (i=0; i < NUMPATHS; i++)
			{
				if (pathSrc[i] == j)
				{
					if (isPathTimed[i])
					{
						if (min)
						{
							timedrate = (3600000 * hours32) / timerVals[j][state][1]; //how many evnts
						} else {
							timedrate = (3600000 * hours32) / timerVals[j][state][0]; //how many events
						}
				
						pathsum = ((timedrate * prob[i])/100)  * (pathenergy[i]/100);
						energysum += pathsum;
						
					} else {
						break;
					}
				}
			}
		}
		
		return energysum;
	}

  

}
