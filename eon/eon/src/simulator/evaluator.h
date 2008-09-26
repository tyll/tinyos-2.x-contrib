#ifndef EVALUATOR_H
#define EVALUATOR_H
#include "simulator.h"
#include <stdint.h>



#ifdef PLOAD
#include "omniloadpredictor.h"
#include "consumptionpredictor.h"
#else
#include "loadpredictor.h"
#include "consumptionpredictor.h"
#endif

#ifdef PENERGY
#include "omnienergypredictor.h"
#else
#ifdef EWMA
#include "ewmapredictor.h"
#else
#include "energypredictor.h"
#endif
#endif



using namespace std;

typedef struct
{
	int energy_state;
	double state_grade;
	int64_t cost_of_reevaluation;
} energy_evaluation_struct_t;


#ifndef NUMTIMEFRAMES
#define NUMTIMEFRAMES 12
#endif

#ifdef STATIC_POLICY
int static_state = STATIC_STATE;
double static_grade = STATIC_GRADE;
#endif

uint16_t ENERGY_TIMESCALES[NUMTIMEFRAMES];
extern int64_t loss_per_unit_time;
extern int64_t battery_capacity;
int64_t perceived_battery = 0;

void init_evaluator()
{
	int i;
	printf("NUMTIMEFRAMES = %d\n",NUMTIMEFRAMES);
	perceived_battery = battery_capacity/2;
	ENERGY_TIMESCALES[0] = 1;
	
	for (i=1; i < NUMTIMEFRAMES; i++)
	{
		ENERGY_TIMESCALES[i] = ENERGY_TIMESCALES[i-1]*2;	
	}
	
	init_energy_predictor();
	init_load_predictor();
	printf("here\n");
	init_consumption_predictor();
	printf("init_evaluator done\n");
}

void eval_more_energy(int64_t energy, int64_t timestamp)
{
	ep_more_energy(energy,timestamp);
}

void eval_increase_battery(int64_t energy){
	char buf[512];
	int64_t newfullness = perceived_battery + energy;
	
	if (newfullness > battery_capacity)
	{
		newfullness = battery_capacity;
	}
	if (newfullness < 0){
		newfullness=  0;
	}
	
	perceived_battery = newfullness;
}

void eval_path_done(int pathNum, int state, int64_t energy, int64_t timestamp)
{
	cp_path_done(pathNum,state,energy);
	lp_path_done(pathNum, timestamp);
}


int64_t predict_energy (vector<event_t*> *time_line,
						int64_t current_index,
						uint8_t timeframe, uint8_t state, double grade)
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
	
	src_energy = predict_energy(time_line, current_index,
					ENERGY_TIMESCALES[timeframe]);//predict source
	load = lp_predict_load(time_line, current_index,
					ENERGY_TIMESCALES[timeframe]);
	consumption = cp_predict_consumption(ENERGY_TIMESCALES[timeframe], 
									load, state, grade);
						
								
	idleloss = (ENERGY_TIMESCALES[timeframe] * (loss_per_unit_time * 60));
	netenergy = src_energy - (consumption + idleloss);
	//netenergy = src_energy-consumption;
	printf("predict_energy(%lld, %d, %d, %lf)->(%lld,%lld,%lld,%lld)\n", 
			current_index,timeframe,state,grade,src_energy,load,consumption, idleloss);
	return netenergy;
}

bool predict_state (vector<event_t*> *time_line,
						int64_t thebattery, int64_t current_index,
						uint8_t state, double grade, int64_t *energy_result)
{
	int timeframe = 0;
	uint64_t waste_energy = 0;
	int64_t netenergy, newbattery = 0;
	int64_t immediate_waste = 0;
	bool dead = FALSE;
	int64_t battery;
	
	#ifdef PERFECT_BATTERY
	battery = thebattery;
	#else
	battery = perceived_battery;
	#endif
	
	while (timeframe < NUMTIMEFRAMES && !dead)
	{
		dead = TRUE;
		
		netenergy = predict_energy(time_line, current_index, timeframe, state, grade);
			
		newbattery = battery + netenergy - waste_energy;
		if (energy_result != NULL)
		{
			*energy_result = newbattery;
		}
		
		if (newbattery <= (int64_t)battery_capacity)
		{
			immediate_waste = 0;
		} else {
			immediate_waste = newbattery - battery_capacity;
			newbattery = battery_capacity;
		}
			
		#ifdef ACCUM_WASTE	
			waste_energy += immediate_waste;
		#else
			waste_energy = 0;
		#endif
		printf("t=%d---s=%d --> ",timeframe, state);
		printf("(%lld,%lld,%lld,%lld)\n",battery, netenergy, waste_energy, immediate_waste);
		
		if (newbattery <= 0)
		{
			dead = TRUE;
			printf("DEAD!\n");
		} else {
			dead = FALSE;
			printf("Not Dead\n");
		}
		
		if (!dead)
		{
			timeframe++;
		}
	}
	return !dead;
}

energy_evaluation_struct_t *reevaluate_energy_level(
		vector<event_t*>* time_line, 
		int current_index, 
		int64_t battery_state)
{
	energy_evaluation_struct_t * ret = new energy_evaluation_struct_t;
	
	#ifdef CONSERVE
		ret->state_grade = 0.0;
		ret->energy_state = STATE_BASE;
		ret->cost_of_reevaluation = 0;
		return ret;
	#endif
	
	#ifdef SPEND
		ret->state_grade = 1.0;
		ret->energy_state = 0;
		ret->cost_of_reevaluation = 0;
		return ret;
	#endif
	
	#ifdef STATIC_POLICY
		ret->energy_state = static_state;
		ret->state_grade = static_grade;
		ret->cost_of_reevaluation = 0;
		return ret;
	#endif
	
	uint8_t state = 0; //set to max state
	bool minalive = FALSE;
	bool maxalive;
	int64_t minenergy = 0;
	int64_t maxenergy = 0;
	
	while (state <= STATE_BASE && !minalive)
	{
		minalive = predict_state(time_line, battery_state, current_index, state, 0.0, &minenergy);
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
		maxalive = predict_state(time_line, battery_state, current_index, state, 1.0, &maxenergy);		
		if (maxalive)
		{
			ret->state_grade = 1.0;
		} else {
			
			#ifdef BROKENGRADE			
				int64_t rightenergy = (-1) * (battery_state);
				int64_t nume = (minenergy);
				int64_t den = (minenergy-maxenergy);
				double dn = (double)nume;
				double dd = (double)den;
			
			
				//since the energy is not linear, this will
				//significantly under-predict
				ret->state_grade = dn/dd;
				//printf("re=%lld,min=%lld,max=%lld,dn=%lf,dd=%lf\n",rightenergy,minenergy,maxenergy,dn,dd);
			#else
			
				double mingrade = 0.0;
				double maxgrade = 1.0;
				double midgrade;
			
				while ((maxgrade - mingrade) > .001)
				{

					midgrade = (mingrade + maxgrade)/2;
					if (predict_state(time_line, battery_state, current_index, state, midgrade,NULL))
					{
						mingrade = midgrade;
					} else {
						maxgrade = midgrade;
					}
				}
				ret->state_grade = midgrade;
			#endif //BROKENGRADE
		}
	}
	
	
	ret->energy_state = state;
	ret->cost_of_reevaluation = 0;
	
	printf("state = %d(%lf)\n",state, ret->state_grade);
	
	return ret; 
}


#endif
