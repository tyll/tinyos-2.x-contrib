#include "rt_structs.h"

module ConsumeModelM
{
  provides
  {
  	interface Init;
    interface StdControl;
    interface IConsumeModel;
  }
  uses{
  	interface RuntimeState;
  }

  /*uses
  {
    interface Random;
  }*/

}

implementation
{


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
	

  command error_t Init.init ()
  {  	
	return SUCCESS;
  }

  command error_t StdControl.start ()
  {
    return SUCCESS;
  }

  command error_t StdControl.stop ()
  {
    return SUCCESS;
  }

	task void SrcProbTask()
	{
		int i;
		static int sp_count = 0;
		static int init = 0;
		uint16_t sum, temp,divis;
		__runtime_state_t *rtstate;
		rtstate = call RuntimeState.getState();
	
		
		
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
			sum += rtstate->spc[i];
		}
		if (sum > 200)
		{
			divis = 10;
		} else {
			divis = 1;
		}
		for (i=0; i < NUMSOURCES; i++)
		{
			temp = rtstate->spc[i];
			if (sum == 0)
			{
				sum = 1;
			}
			temp = (temp * 100) / sum;
			
			rtstate->srcprob[i] = temp;
			rtstate->spc[i] = rtstate->spc[i] / divis;
		}
	}
	
	task void ProbTask()
	{
		int s,p,src;
		static int sp_count = 0;
		static int init = 0;
		
		uint16_t sum[NUMSOURCES];
		uint16_t temp,divis;
		__runtime_state_t *rtstate;
		rtstate = call RuntimeState.getState();
	
		
		
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
			src = pathSrc[p];
			sum[src] += rtstate->pc[p];
			
		}
			
		for (p=0; p < NUMPATHS; p++)
		{
			src = pathSrc[p];
			
			if (sum[src] > 200)
			{
				divis = 10;
			} else {
				divis = 1;
			}
			
			temp = rtstate->pc[p];
			if (sum[src] > 0)
			{
				temp = (temp * 100) / sum[src];
			} else {
				temp = 1;
			}
			
			rtstate->prob[p] = temp;
			rtstate->pc[p] = rtstate->pc[p] / divis;
		}
	}

command error_t IConsumeModel.pathDone(uint16_t pathNum, 
						uint8_t state, 
						uint32_t energy)
{
	int src;
	__runtime_state_t *rtstate;
	rtstate = call RuntimeState.getState();
	
	
	src = pathSrc[pathNum];
	
	
	//update src probabilities.
	if (!isPathTimed[pathNum])
	{
		rtstate->spc[src]++;
		post SrcProbTask();
	} //end srcprob adjustment
	
	
	//update path probabilities.
	rtstate->pc[pathNum]++;
	post ProbTask();
	
	
	//update energy estimate
	if (energy != 0xFFFFFFFF)
	{
		if (rtstate->pathenergy[pathNum] == -1)
		{
			rtstate->pathenergy[pathNum] = energy * 100;
		} else {
			rtstate->pathenergy[pathNum] = ((rtstate->pathenergy[pathNum] * (PATH_ENERGY_WEIGHT-1)) + (energy * 100)) / PATH_ENERGY_WEIGHT;
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
			
		__runtime_state_t *rtstate;
		rtstate = call RuntimeState.getState();
		
			
		
		for (i=0; i < NUMPATHS; i++)
		{
			if (pathSrc[i] == src)
			{
				if (!tset)
				{
					timed = isPathTimed[i];
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
				
					if (rtstate->pathenergy[i] != -1)
					{
						pathsum = ((timedrate * rtstate->prob[i])/100)  * (rtstate->pathenergy[i]/100);
							
						energysum += pathsum;
					}
							
				} else {
					intermed = rtstate->srcprob[src];
					intermed = intermed * rtstate->prob[i];
					if (rtstate->pathenergy[i] != -1)
					{
						pathsum = ((xevents * intermed) / 10000) * (rtstate->pathenergy[i]/100);
						energysum += pathsum;
					}
				}
			}
		}
			
		return energysum;
	}
  	
  

}
