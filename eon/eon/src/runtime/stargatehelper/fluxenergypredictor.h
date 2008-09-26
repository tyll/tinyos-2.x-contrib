#ifndef FLUXENERGYPREDICTOR_H_INCLUDED
#define FLUXENERGYPREDICTOR_H_INCLUDED

#include "../nodes.h"


#define NUMTIMEFRAMES 8

const uint8_t ENERGY_TIMESCALES[NUMTIMEFRAMES] = {1,2,4,8,16,32,64,128};


int32_t predict_energy (uint8_t timeframe, uint8_t state)
{
	int32_t src_energy;
	int32_t consumption;
	
	src_energy = predict_source(ENERGY_TIMESCALES[timeframe]);//predict source
	consumption = predict_consumption(ENERGY_TIMESCALES[timeframe], state);
	
	return src_energy - consumption;
}


#endif
