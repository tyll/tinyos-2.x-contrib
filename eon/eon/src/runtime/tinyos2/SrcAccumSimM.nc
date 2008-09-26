

includes structs;
//includes timerdefs;
#include "SrcAccum.h"


module SrcAccumSimM
{
  provides
  {
  	interface Init;
    	interface StdControl;
    	interface IAccum;
  }
  uses
  {
    interface Timer<TMilli> as Timer0;
	interface RuntimeState;
	interface Energy;
  }

}

implementation
{

//#include "rt_structs.h"

bool init = FALSE;
uint64_t lastin = 0;
uint64_t lastout = 0;
	
  
  
  command error_t Init.init ()
  {
  	return SUCCESS;
  }

  command error_t StdControl.start ()
  {
    call Timer0.startPeriodic(POLL_2770_INTERVAL);	
    return SUCCESS;
  }

  command error_t StdControl.stop ()
  {
    call Timer0.stop ();
    return SUCCESS;
  }

	uint32_t getElapsed(uint32_t tbegin, uint32_t tend)
	{
		uint32_t elapsed;
		
		if (tend < tbegin)
    	{
    		elapsed = (0xFFFFFFFF - tbegin) + tend;
    	} else {
    		elapsed = tend - tbegin;
    	}
    	return elapsed;
	}
	
	int16_t getACRChange(int16_t last, int16_t newacr)
	{
			
		return (newacr - last);
	}

  
  
  

	event void Timer0.fired()
  {
  		uint64_t diffin, diffout;
		uint64_t newin, newout;
		__runtime_state_t *rtstate = call RuntimeState.getState();
		
		newin = call Energy.get_energy_in();
		newout = call Energy.get_energy_out();
		
		//mJ to uJ
		newin *= 1000;
		newout *= 1000;
		
		diffin = newin - lastin;
		diffout = newout - lastout;
		if (diffin > 0 && diffout > 0)
		{
			//avoid wraparound issues	
			signal IAccum.update(diffin, diffout);
		}
		
		lastin = newin;
		lastout= newout;
		
		
  		rtstate->batt_reserve = call Energy.get_energy();
		rtstate->batt_reserve *= 1000;
	
  }
  	
  	


	command uint32_t IAccum.getInMicroJoules()
  	{
		//milli really
		uint32_t result = (call Energy.get_energy_in());
  		return result;
  	}
  
  command uint32_t IAccum.getOutMicroJoules()
  {
  		//milli really
		uint32_t result = (call Energy.get_energy_out());
  		return result;
  }
	
	
	
  
  command uint64_t IAccum.getReserve()
  {
  	__runtime_state_t *rtstate = call RuntimeState.getState();
  	return rtstate->batt_reserve;
  }
  
  command uint64_t IAccum.getCapacity()
  {
  	uint64_t tmp = call Energy.get_battery_size();
  	return (tmp * 1000);
  }

  
  command uint16_t IAccum.getVoltage()
  {
  	return 4.0;
  }
  
  command int16_t IAccum.getTemperature()
  {
  	return 36;
  }

}
