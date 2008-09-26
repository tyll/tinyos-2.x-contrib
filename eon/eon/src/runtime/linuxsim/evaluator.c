#include <pthread.h>
#include "energymgr.h"
//#include <stdint.h>
#include "../mNodes.h"
#include <math.h>





#ifndef NUMTIMEFRAMES
#define NUMTIMEFRAMES 12
#endif

#ifdef STATIC_POLICY
int static_state = STATIC_STATE;
double static_grade = STATIC_GRADE;
#endif

int ENERGY_TIMESCALES[NUMTIMEFRAMES];
extern unsigned int __path_costs[NUMPATHS];
extern unsigned int __path_count[NUMPATHS];
extern unsigned int __path_pred_count[NUMPATHS][NUMSTATES];
extern int idle_uW;

void init_evaluator()
{
	int i;
//	printf("NUMTIMEFRAMES = %d\n",NUMTIMEFRAMES);
	ENERGY_TIMESCALES[0] = 1;
	
	for (i=1; i < NUMTIMEFRAMES; i++)
	{
		ENERGY_TIMESCALES[i] = ENERGY_TIMESCALES[i-1]*2;	
	}
	
	printf("init_evaluator done\n");
}


int64_t predict_consumption(int64_t hours, int state, double grade)
{
	uint64_t energysum  = 0;
		
	uint64_t pathsum = 0;
	uint64_t timedrate;
	uint64_t maxrate, minrate;	
	int i=0;
	int j=0;
		
	for (i=0; i < NUMPATHS; i++)
	{
		if (!isPathTimed[i])
		{
			//cost of path
			pathsum = __path_pred_count[i][state];
			pathsum = pathsum * __path_costs[i];
			pathsum = pathsum * hours;
			energysum += pathsum;
		}
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
						
						double tdelta = (double)(timerVals[j][state][1]-timerVals[j][state][0]);
						double dval = ((double)timerVals[j][state][1]) - (grade * tdelta);
						uint32_t newval = (uint32_t)rint(dval);
						timedrate = (3600000 * hours) / newval;
 	
				
						
						pathsum = (timedrate)  * (__path_costs[i]);

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
		
		energysum += (idle_uW * hours * 3600);
		
		return energysum;

}

int64_t predict_energy (uint8_t timeframe, uint8_t state, double grade)
{
	int64_t src_energy;
	int64_t consumption;
	int64_t load;
	int64_t netenergy, idleloss;
	
	
	if (state > NUMSTATES)
	{
		printf("ERROR: Invalid state!!! (s=%d)\n",state);
		exit(2);
	}
	
	src_energy = predict_src_energy(ENERGY_TIMESCALES[timeframe]);//predict source
	consumption = predict_consumption(ENERGY_TIMESCALES[timeframe], 					state, grade);
						
								
	
	netenergy = src_energy - consumption;
	
	//printf("predict_energy(%lld, %d, %d, %lf)->(%lld,%lld,%lld,%lld)\n", 
		//	current_index,timeframe,state,grade,src_energy,load,consumption, idleloss);
	return netenergy;
}

bool predict_state (int64_t thebattery, int64_t battery_capacity,
						uint8_t state, double grade, int64_t *energy_result)
{
	int timeframe = 0;
	uint64_t waste_energy = 0;
	int64_t netenergy, newbattery = 0;
	int64_t immediate_waste = 0;
	bool dead = FALSE;
	int64_t battery;
	
	battery = thebattery;
	
	
	while (timeframe < NUMTIMEFRAMES && !dead)
	{
		dead = TRUE;
		
		netenergy = predict_energy(timeframe, state, grade);
			
		newbattery = battery + netenergy - waste_energy;
		if (energy_result != NULL)
		{
			*energy_result = newbattery;
		}
		
		if (newbattery <= battery_capacity)
		{
			immediate_waste = 0;
		} else {
			immediate_waste = newbattery - battery_capacity;
			newbattery = battery_capacity;
		}
			
		waste_energy += immediate_waste;
		
		//printf("t=%d---s=%d --> ",timeframe, state);
		//printf("(%lld,%lld,%lld,%lld)\n",battery, netenergy, waste_energy, immediate_waste);
		
		if (newbattery <= 0)
		{
			dead = TRUE;
			//printf("DEAD!\n");
		} else {
			dead = FALSE;
			//printf("Not Dead\n");
		}
		
		if (!dead)
		{
			timeframe++;
		}
	}
	return !dead;
}

energy_evaluation_struct_t *reevaluate_energy_level(int64_t battery_state, int64_t battery_capacity)
{
	energy_evaluation_struct_t * ret = (energy_evaluation_struct_t*)malloc(sizeof(energy_evaluation_struct_t));
	
	
	uint8_t state = 0; //set to max state
	bool minalive = FALSE;
	bool maxalive;
	int64_t minenergy = 0;
	int64_t maxenergy = 0;
	
	while (state <= STATE_BASE && !minalive)
	{
		minalive = predict_state(battery_state, battery_capacity, state, 0.0, &minenergy);
		if (!minalive)
		{
			state++;
		}
	}
	//we have the right state...now get the grade
	if (!minalive)
	{
		state = STATE_BASE;
		ret->state_grade = 0.0;

	} else {
		maxalive = predict_state(battery_state, battery_capacity, state, 1.0, &maxenergy);		
		if (maxalive)
		{
			ret->state_grade = 1.0;
		} else {
			
			double mingrade = 0.0;
			double maxgrade = 1.0;
			double midgrade;
			
			while ((maxgrade - mingrade) > .001)
			{
				midgrade = (mingrade + maxgrade)/2;
				if (predict_state(battery_state, battery_capacity, state, midgrade,NULL))
				{
					mingrade = midgrade;
				} else {
					maxgrade = midgrade;
				}
			}
			ret->state_grade = midgrade;
			
		}
	}
	
	
	ret->energy_state = state;
	ret->cost_of_reevaluation = 0;
	
	printf("state = %d(%lf)\n",state, ret->state_grade);
	
	return ret; 
}


