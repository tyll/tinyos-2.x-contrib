#ifndef OMNILOADPREDICTOR_H
#define OMNILOADPREDICTOR_H
#include "simulator.h"
#include "nodes.h"

using namespace std;

extern int64_t current_time;
int get_tl_type(string &str);
int64_t get_tl_time(string& str);

#define LOAD_HISTORY  24
#define LOAD_DOUBT  8
#define EPOCH_HRS   1

int64_t last_time;
int64_t start_epoch;
int64_t event_count;
int64_t prediction;
int64_t history[LOAD_HISTORY];
uint8_t history_index;

void init_load_predictor()
{
	start_epoch = 0;
	event_count = 0;
	prediction = 0;
	memset(history, 0, sizeof(history));	
}




void lp_path_done(int pathNum, int64_t timestamp)
{
	
	return;
}

int64_t lp_predict_load(
		vector<event_t*>* timeline, 
		int current_index,
		int64_t hours)
{
	
	int64_t result = 0;
	int64_t index = current_index;
	int64_t deadline;
	int64_t ctime;
	
	ctime = current_time;
	deadline = current_time + (hours * 60 * 60 * 1000);
	
	while (ctime < deadline && index < timeline->size())
	{
		
		event_t* evt = timeline->at(index);
		
		int event_type = evt->type;
		int64_t event_time = evt->time;
		
		if (event_type == SERVICE_REQUEST)
		{	  		
	  		result++;	
		}
		ctime = event_time;
		index++;	
	}		
	
	return result;
}


#endif
