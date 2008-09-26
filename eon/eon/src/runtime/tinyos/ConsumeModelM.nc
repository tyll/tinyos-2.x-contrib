

module ConsumeModelM
{
  provides
  {
    interface StdControl;
    interface IConsumeModel;
  }

  /*uses
  {
    interface Random;
  }*/

}

implementation
{

#include "rt_structs.h"

enum {
PATH_ENERGY_WEIGHT = 5,

};
	
	uint32_t event_count;
	uint32_t prediction;
	
	
int32_t doewma(int32_t oldv, int32_t newv, int32_t num, int32_t den)
{
	int32_t retval;
	
	retval = ((oldv * (den-num)) + (newv * num))/den;
	return retval;
}
	

  command result_t StdControl.init ()
  {  	
  	//call Random.init();
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

	task void SrcProbTask()
	{
		int i;
		static int sp_count = 0;
		static int init = 0;
		uint16_t sum, temp,divis;
		
		sp_count++;
		if (sp_count < 15 && init)
		{
			return;
		}
		init = 1;
		sp_count = 0;
		sum = 0;
		for (i=0; i < NUMSOURCES; i++)
		{
			sum += __rtstate.spc[i];
		}
		if (sum > 200)
		{
			divis = 10;
		} else {
			divis = 1;
		}
		for (i=0; i < NUMSOURCES; i++)
		{
			temp = __rtstate.spc[i];
			if (sum == 0)
			{
				sum = 1;
			}
			temp = (temp * 100) / sum;
			
			__rtstate.srcprob[i] = temp;
			__rtstate.spc[i] = __rtstate.spc[i] / divis;
		}
	}
	
	task void ProbTask()
	{
		int s,p,src;
		static int sp_count = 0;
		static int init = 0;
		
		uint16_t sum[NUMSOURCES];
		uint16_t temp,divis;
		
		sp_count++;
		if (sp_count < 15 && init)
		{
			return;
		}
		init = 1;
		sp_count = 0;
		
		
		
		for (s=0; s < NUMSOURCES; s++)
		{
			sum[s] = 0;
		}
		
		for (p=0; p < NUMPATHS; p++)
		{
			src = read_pgm_int8((int8_t*)&pathSrc[p]);
			sum[src] += __rtstate.pc[p];
			
		}
			
		for (p=0; p < NUMPATHS; p++)
		{
			src = read_pgm_int8((int8_t*)&pathSrc[p]);
			
			if (sum[src] > 200)
			{
				divis = 10;
			} else {
				divis = 1;
			}
			
			temp = __rtstate.pc[p];
			if (sum[src] > 0)
			{
				temp = (temp * 100) / sum[src];
			} else {
				temp = 1;
			}
			
			__rtstate.prob[p] = temp;
			__rtstate.pc[p] = __rtstate.pc[p] / divis;
		}
	}

command result_t IConsumeModel.pathDone(uint16_t pathNum, 
						uint8_t state, 
						uint32_t energy)
{
	int src;
	
	src = read_pgm_int8((int8_t*)&pathSrc[pathNum]);
	
	
	//update src probabilities.
	if (!read_pgm_int8((int8_t *)&isPathTimed[pathNum]))
	{
		__rtstate.spc[src]++;
		post SrcProbTask();
	} //end srcprob adjustment
	
	
	//update path probabilities.
	__rtstate.pc[pathNum]++;
	post ProbTask();
	
	
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
		//int j=0;
		uint32_t intermed;
		bool tset = FALSE;
		bool timed;
			
		
			
			
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
  	
  

}
