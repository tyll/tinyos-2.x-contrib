

#include "rt_handler.h"
#include "../mNodes.h"



//extern int curstate;
//extern float curgrade;
//extern int32_t timerVals[NUMSOURCES][NUMSTATES][2];

unsigned int get_timer_interval(int source)
{
	unsigned int minval, maxval;
	
	minval = timerVals[source][curstate][0];
	maxval = timerVals[source][curstate][1];
	
	double tdelta = (double)(maxval-minval);
	double dval = ((double)maxval) - (curgrade * tdelta);
	
	//convert to 1/100 seconds
	uint32_t newval = (uint32_t)rint(dval / 10.0);
	
	return newval;
}

int isFunctionalState(int8_t state)
{
	return (curstate >= state);	
}

void reportError(uint16_t nodeid, uint8_t error, rt_data _pdata)
{
	//printf("ERROR: %i:%i\n",nodeid, _pdata.weight);
	reportExit(_pdata);
}

void reportExit(rt_data _pdata)
{
	int result;
	//printf("Flow done: %i\n",_pdata.weight);

	end_path(_pdata.sessionID, _pdata.weight);
}



int getNextSession()
{
	static int session= 0;
		
	session++;
	return session;
}

