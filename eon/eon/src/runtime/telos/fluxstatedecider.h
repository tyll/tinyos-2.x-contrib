#ifndef FLUXSTATEDECIDER_H_INCLUDED
#define FLUXSTATEDECIDER_H_INCLUDED

#include "../nodes.h"
#include "fluxenergypredictor.h"



uint8_t decide_state (uint16_t connid, bool data)
{
	uint8_t state = 0; //set to max state
	uint8_t timeframe = 0;
	int32_t netenergy;
	int32_t battery;
	
	while (timeframe < NUMTIMEFRAMES && state < STATE_BASE)
	{
		
		netenergy = predict_energy(timeframe, state);
		battery = get_battery_reserve();
		if (battery + netenergy <= 0)
		{
			state++;
		} else {
			timeframe++;
		}
	}
	return state;
}


#endif
