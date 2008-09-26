

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

#include "rt_structs.h"

enum {
PATH_ENERGY_WEIGHT = 5,

};
	
	uint32_t event_count;
	uint32_t prediction;
	
	


  command result_t StdControl.init ()
  {  	
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

	

command result_t IConsumeModel.pathDone(uint16_t pathNum, 
						uint8_t state, 
						uint32_t energy)
{
	uint16_t rnd;
	int i, sum;
	int src;
	uint8_t srcnode;
	
	src = read_pgm_int8((int8_t*)&pathSrc[pathNum]);
	
	
	//update src probabilities.
	if (!read_pgm_int8((int8_t *)&isPathTimed[pathNum]))
	{
		atomic
		{
			__rtstate.srcprob[src]++;
			//get random number(1-100)
			rnd = (call Random.rand() % 100)+1;
			//deduct
			i=0;
			sum = 0;
			// USED TO BE: while (sum < rnd && i < NUMPATHS-1)  AK Fix
			while (sum < rnd && i < NUMSOURCES)
			{
				if (!read_pgm_int8((int8_t *)&srcNodes[i][0]))
				{
					sum += __rtstate.srcprob[i];
					
					if (sum >= rnd) break;
				}
				i++;
			}
			if (i < NUMSOURCES)
			{
				__rtstate.srcprob[i]--;
			}
		}
	} //end srcprob adjustment
	
	
	//update path probabilities.
	atomic
	{
		__rtstate.prob[pathNum]++;
		//get random number(1-100)
		rnd = (call Random.rand() % 100)+1;
		//deduct
		i=0;
		sum = 0;
		while (sum < rnd && i < NUMPATHS-1)
		//while (sum < rnd && i < NUMSOURCES-1)
		
		{
			//is same source
			if (read_pgm_int8((int8_t*)&pathSrc[i]) == src)
			{
				sum += __rtstate.prob[i];
				if (sum >= rnd) break;
			}
			i++;
		}
		__rtstate.prob[i]--;
	}
	
	
	//update energy estimate
	if (energy != 0xFFFFFFFF)
	{
		if (__rtstate.pathenergy[pathNum] == -1)
		{
			__rtstate.pathenergy[pathNum] = energy * 100;
		} else {
			__rtstate.pathenergy[pathNum] = ((__rtstate.pathenergy[pathNum] * (PATH_ENERGY_WEIGHT-1)) + (energy * 100)) / PATH_ENERGY_WEIGHT;
		}
	}
	
	return SUCCESS;
}
  
  
  	command uint64_t IConsumeModel.getConsumePrediction(uint16_t hours, 
														uint32_t xevents, 
														uint8_t state,
														double grade,
													   	uint8_t src)
	{
		uint64_t energysum  = 0;
		uint64_t hours64 = hours;
		uint32_t pathsum = 0;
		uint32_t timedrate;	
		uint32_t timerV;
		int32_t minval, maxval;
		int i=0;
		int j=0;
		uint32_t intermed;
		bool tset = FALSE;
		bool timed;
			
		/*for (i=0; i < NUMPATHS; i++)
		{
			//src = read_pgm_int8((int8_t*)&pathSrc[i]);
				//cost of path
			intermed = srcprob[src];
			intermed = intermed * prob[i];
			pathsum = ((xevents * intermed) / 10000) * (pathenergy[i]/100);
			energysum += pathsum;
	}*/
			
			
			//now add timed srcs
		for (i=0; i < NUMPATHS; i++)
		{
			if (read_pgm_int8((uint8_t*)&pathSrc[i]) == src)
			{
				if (!tset)
				{
					timed = read_pgm_int8((int8_t*)&isPathTimed[i]);
				}
				if (timed)
				{
						
					minval = get_timer_interval(src,state,TRUE);
					maxval = get_timer_interval(src,state,FALSE);
						
						
					timerV = minval - (uint32_t)(grade * ((double)(minval-maxval)));
					
					if (timerV == 0)	
					{
						timerV = 1;
					}
									
									
					timedrate = (3600000LL * hours64) / timerV; //how many events
				
					if (__rtstate.pathenergy[i] != -1)
					{
						pathsum = ((timedrate * __rtstate.prob[i])/100)  * (__rtstate.pathenergy[i]/100);
							
						energysum += pathsum;
					}
							
				} else {
					intermed = __rtstate.srcprob[src];
					intermed = intermed * __rtstate.prob[i];
					if (__rtstate.pathenergy[i] != -1)
					{
						pathsum = ((xevents * intermed) / 10000) * (__rtstate.pathenergy[i]/100);
						energysum += pathsum;
					}
				}
			}
		}
			
		return energysum;
	}
  	/*command uint64_t IConsumeModel.getConsumePrediction(uint16_t hours, 
  											uint32_t xevents, 
  											uint8_t state,
  											double grade)
	{
		uint64_t energysum  = 0;
		uint64_t hours64 = hours;
		uint32_t pathsum = 0;
		uint32_t timedrate;	
		uint32_t timerV;
		int32_t minval, maxval;
		int i=0;
		int j=0;
		uint8_t src;
		uint32_t intermed;
		
		for (i=0; i < NUMPATHS; i++)
		{
			src = read_pgm_int8((int8_t*)&pathSrc[i]);
			//cost of path
			intermed = srcprob[src];
			intermed = intermed * prob[i];
			pathsum = ((xevents * intermed) / 10000) * (pathenergy[i]/100);
			energysum += pathsum;
		}
		
		
		//now add timed srcs
		for (j=0; j < NUMSOURCES; j++)
		{
			for (i=0; i < NUMPATHS; i++)
			{
				if (read_pgm_int8((uint8_t*)&pathSrc[i]) == j)
				{
					if (read_pgm_int8((int8_t*)&isPathTimed[i]))
					{
						
						minval = get_timer_interval(j,state,TRUE);
						maxval = get_timer_interval(j,state,FALSE);
						
						
						timerV = minval - (uint32_t)(grade * ((double)(minval-maxval)));
					
						if (timerV == 0)	
						{
							timerV = 1;
						}
									
									
						timedrate = (3600000L * hours64) / timerV; //how many events
				
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
	*/
  

}
