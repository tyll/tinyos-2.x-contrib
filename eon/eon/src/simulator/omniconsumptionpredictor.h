#ifndef CONSUMPTIONPREDICTOR_H
#define CONSUMPTIONPREDICTOR_H
#include "simulator.h"
#include "nodes.h"

using namespace std;

#define PATH_ENERGY_WEIGHT  5


/*extern uint8_t isPathTimed[NUMPATHS];
extern uint8_t pathSrc[NUMPATHS];
extern uint8_t timedPaths[NUMTIMEDPATHS];
extern uint16_t timerVals[NUMSOURCES][NUMSTATES][2];
extern uint8_t srcNodes[NUMSOURCES][2];*/

int64_t cp_event_count;
int64_t cp_prediction;
	
int8_t cp_srcprob[NUMSOURCES];
int8_t cp_prob[NUMPATHS];
int64_t cp_pathenergy[NUMPATHS];
int32_t cp_history_index;
extern vector < int64_t > path_costs[NUMPATHS];

void init_consumption_predictor()
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
  			//cp_prob[i] = (100 / numpaths);
  			if (i==3)
  			{
  				cp_prob[i] = 100;
  			} else {
  				cp_prob[i] = 0;
  			}
  		}
  		
  	}
  	
  	for (i=0; i < NUMPATHS; i++)
  	{
  		uint64_t energysum = 0;
  		
  		for (j=0; j < path_costs[i].size(); j++)
  		{
  			energysum += path_costs[i].at(j);
  		}
  		
  		cp_pathenergy[i] = (energysum * 100) / path_costs[i].size();
  		printf("cp_p[%d] = %lld / %d = %lld\n",i,energysum, path_costs[i].size(), cp_pathenergy[i]);
  	}	
  	  	
}


void cp_path_done(uint16_t pathNum, 
  					uint8_t state, 
  					int64_t energy)
  {
  	uint16_t rnd;
  	int i, sum;
  	int src;
  	
  	return;
  	
  	src = pathSrc[pathNum];
  	//printf("PATH : %d = %lld\n",pathNum,energy);
  	//update src probabilities.
  	if (!isPathTimed[pathNum])
  	{
		cp_srcprob[src]++;
		//get random number(1-100)
		rnd = (rand() % 100)+1;
		//deduct
		i=0;
  		sum = 0;
  		while (sum < rnd && i < NUMPATHS-1)
  		{
  			sum += cp_srcprob[i];
  			if (sum >= rnd) break;
  			i++;
  		}
  		cp_srcprob[i]--;
  	
  	} //end srcprob adjustment
  	
  	
  	
  	//update path probabilities.
  	cp_prob[pathNum]++;
  	//get random number(1-100)
  	rnd = (rand() % 100)+1;
	//deduct
	i=0;
  	sum = 0;
  	while (sum < rnd && i < NUMPATHS-1)
  	{
  		//is same source
  		if (pathSrc[i] == src)
  		{
  			sum += cp_prob[i];
  			if (sum >= rnd) break;
  		}
  		i++;
  	}
  	cp_prob[i]--;
  	
  	
  	//update energy estimate
  	
  	if (cp_pathenergy[pathNum] == -1)
  	{
  		cp_pathenergy[pathNum] = energy * 100;
  	} else {
  		cp_pathenergy[pathNum] = ((cp_pathenergy[pathNum] * (PATH_ENERGY_WEIGHT-1)) + (energy * 100)) / PATH_ENERGY_WEIGHT;
  	}
  	

	
}



int64_t cp_predict_consumption(int64_t hours, 
  							int64_t xevents, 
  							uint8_t state,
  							double grade)
	{
		uint64_t energysum  = 0;
		
		uint64_t pathsum = 0;
		uint64_t timedrate;
		uint64_t maxrate, minrate;	
		int i=0;
		int j=0;
		
		for (i=0; i < NUMPATHS; i++)
		{
			//cost of path
			pathsum = ((xevents * cp_prob[i]) / 100) * (cp_pathenergy[i]/100);
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
						//minrate = (3600000 * hours) / timerVals[j][state][1]; //how many evnts
						double tdelta = (double)(timerVals[j][state][1]-timerVals[j][state][0]);
						double dval = ((double)timerVals[j][state][1]) - (grade * tdelta);
						uint32_t newval = (uint32_t)round(dval);
						timedrate = (3600000 * hours) / newval;
 	
				
						pathsum = ((timedrate * cp_prob[i])/100)  * (cp_pathenergy[i]/100);
						energysum += pathsum;
						
						//printf("cp-->td=%lf,dv=%lf,nv=%ld,rate=%lld,p=%d,e=%lld --> es=%lld\n",
						//	tdelta,dval,newval,timedrate,cp_prob[i],cp_pathenergy[i],energysum);
						
					} else {
						break;
					}
				}
			}
		}
		//printf("predict_consumption(%lld, %lld, %d, %lf)->%lld\n",hours,xevents,state,grade,energysum);
		return energysum;
	}



#endif
