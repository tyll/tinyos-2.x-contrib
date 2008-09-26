

#ifndef ENERGYPREDICTOR_H
#define ENERGYPREDICTOR_H
#include "simulator.h"
#include "nodes.h"

using namespace std;

#ifndef EP_WINDOW
#define EP_WINDOW 24
#endif

#ifndef EP_SCALE
#define EP_SCALE 60
#endif


#ifndef EP_FILTER_WT
#define EP_FILTER_WT   25
#endif


int64_t start_energy;
int64_t min_time;
int64_t ep_last_prediction;
int64_t ep_cur_prediction;
int64_t ep_last_error;

int64_t last_day[EP_WINDOW];
int64_t ep_prediction[EP_WINDOW];

int64_t ep_start_epoch;
int64_t ep_energy_counter;
int ep_cur_idx;

void init_energy_predictor()
{
	int i;
	ep_start_epoch = 0;
	ep_energy_counter = 0;	
	ep_cur_prediction = 0;
	ep_cur_idx = 0;
	
	for (i=0; i < EP_WINDOW; i++)
	{
		last_day[i] = 0;
		ep_prediction[i] = 0;
	}
}

void ep_more_energy(int64_t energy, int64_t timestamp)
{
	int64_t diff = timestamp - ep_start_epoch;
	
	if (diff > (EP_SCALE * 60 * 1000))
	{

		
		ep_prediction[ep_cur_idx] = ((ep_energy_counter * EP_FILTER_WT) + (ep_prediction[ep_cur_idx] * (100-EP_FILTER_WT)))/100;
		
		ep_energy_counter = 0;
		ep_start_epoch = ep_start_epoch + (EP_SCALE * 60 * 1000);
		ep_cur_idx = (ep_cur_idx + 1) % EP_WINDOW;
		printf("ep(%lld)\n",ep_prediction[ep_cur_idx]);
	}
	
	ep_energy_counter += energy;
}

int64_t predict_energy(vector<event_t*>* timeline, 
						int64_t current_index,
						int64_t hours)
{
	int64_t result;
	double confidence;
	int16_t i;
	int idx = ep_cur_idx;
	
	/*if (ep_last_error < ep_cur_prediction)
	{
		confidence =1.0 - ((double)ep_last_error / (double)ep_cur_prediction);	
	} else {
		confidence = 0;
	}*/
		
	result = 0;
	for (i=0; i < hours; i++)
	{
		result += ep_prediction[idx];
		idx = (idx + 1) %  EP_WINDOW;
	}
	
	//result = (int64_t)(confidence * (double)((ep_cur_prediction / 24) * hours));
	return result;	
}


#endif
