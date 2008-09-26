/* This is the same predictor used in the HelioMote project
 * It is a simple autoregressive filter of order 1.
 * 
 * 
 */

#ifndef ENERGYPREDICTOR_H
#define ENERGYPREDICTOR_H
#include "simulator.h"
#include "nodes.h"

using namespace std;

#ifndef EP_EPOCH_HRS
#define EP_EPOCH_HRS   24
#endif

#ifndef EP_FILTER_WT
#define EP_FILTER_WT   90
#endif


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
	int64_t diff = timestamp - ep_start_epoch;
	
	if (diff > (EP_EPOCH_HRS * 60 * 60 * 1000))
	{

		int64_t last_prediction = ep_cur_prediction;
		int64_t delta;
		ep_cur_prediction = ((ep_energy_counter * EP_FILTER_WT) + (last_prediction * (100-EP_FILTER_WT)))/100;
		ep_last_error = ::llabs((int64_t)(ep_cur_prediction - last_prediction));
		 
		ep_energy_counter = 0;
		ep_start_epoch = ep_start_epoch + (EP_EPOCH_HRS * 60 * 60 * 1000);
		printf("ep(%lld,%lld)\n",ep_cur_prediction, last_prediction);
	}
	
	ep_energy_counter += energy;
}

int64_t predict_energy(vector<event_t*>* timeline, 
						int64_t current_index,
						int64_t hours)
{
	int64_t result;
	double confidence;
	
	if (ep_last_error < ep_cur_prediction)
	{
		confidence =1.0 - ((double)ep_last_error / (double)ep_cur_prediction);	
	} else {
		confidence = 0;
	}
		
	//result = (int64_t)(confidence * (double)((ep_cur_prediction / 24) * hours));
	result = ((ep_cur_prediction / 24) * hours);
	return result;	
}


#endif
