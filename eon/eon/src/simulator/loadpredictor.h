#ifndef LOADPREDICTOR_H
#define LOADPREDICTOR_H
#include "simulator.h"
#include "nodes.h"

using namespace std;


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

int64_t lp_getMaxValue(int64_t limit, bool dolimit)
{
	int64_t max = 0;
	int i;
	
	for (i=0; i < LOAD_HISTORY; i++)
	{
		if (history[i] > max && (history[i] < limit || !dolimit))
		{
			max = history[i];
		}
	}
	return max;
}

void PredictTask()
{
	int i= 0;
	int samples = LOAD_HISTORY / LOAD_DOUBT;
	bool limit = FALSE;
	int64_t last_sample, next_sample;
	
	for (i=0; i < samples; i++)
	{
		last_sample = lp_getMaxValue(last_sample, limit);
		limit = TRUE;
	}
	prediction = last_sample;
}

void hour_past()
{

	history[history_index] = event_count;
	event_count = 0;
	history_index = (history_index +1) % LOAD_HISTORY;
	
	PredictTask();
	start_epoch = start_epoch + (EPOCH_HRS * 60 * 60 * 1000);
}


void lp_path_done(int pathNum, int64_t timestamp)
{
	int64_t diff = timestamp - start_epoch;
	if (diff > (EPOCH_HRS * 60 * 60 * 1000))
	{
		hour_past();
	}
	
	//check that path is not timed.
  	if (isPathTimed[pathNum]) return;
  	
  	//else
  	event_count++;
	return;
}

int64_t lp_predict_load(
		vector<event_t*>* timeline, 
		int current_index,
		int64_t hours)
{
	//give the current prediction in terms of hours.
	int64_t result;
	
		
	result = prediction * hours;
	return result;
}


#endif
