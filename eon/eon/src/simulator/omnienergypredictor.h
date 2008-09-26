/* This is the same predictor used in the HelioMote project
 * It is a simple autoregressive filter of order 1.
 * 
 * 
 */

#ifndef OMNIENERGYPREDICTOR_H
#define OMNIENERGYPREDICTOR_H
#include "simulator.h"
#include "nodes.h"

using namespace std;




extern int64_t current_time;




int64_t start_energy;
int64_t min_time;
int64_t ep_last_prediction;
int64_t ep_cur_prediction;
int64_t ep_last_error;


int64_t ep_start_epoch;
int64_t ep_energy_counter;

void init_energy_predictor()
{
	ep_start_epoch = 0;
	ep_energy_counter = 0;	
	ep_cur_prediction = 0;
}

void ep_more_energy(int64_t energy, int64_t timestamp)
{
	
}

/*int64_t ep_get_power_level(string str){
	string::size_type loc = str.find(":", 0);
	if(loc != string::npos){
		string power_time_string = str.substr(0, loc);
		
		string energy_source_power_str = str.substr(loc+1);
		int64_t energy_source_power = atoll(energy_source_power_str.c_str());
		return energy_source_power;
	}
	return 0;
}*/

int64_t predict_energy(vector<event_t*> *timeline, 
						int64_t current_index,
						int64_t hours)
{
	int64_t result = 0;
	int64_t index = current_index;
	int64_t deadline;
	int64_t ctime;
	
	ctime = current_time;
	deadline = current_time + (hours * 60 * 60 * 1000);
	
	while (ctime < deadline)
	{
		if (index >= timeline->size())
		{
			break;
		}
		
		event_t* evt = timeline->at(index);
		int event_type = evt->type;
		
		if (event_type == UPDATE_BATTERY)
		{
	  		int64_t event_time = evt->time;
	  		int64_t energyadd = evt->energy;
	  		result += energyadd;
			ctime = event_time;
		}
		index++;
	}		
	
	return result;	
}


#endif
