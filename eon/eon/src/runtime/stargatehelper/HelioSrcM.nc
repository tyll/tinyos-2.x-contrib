



module HelioSrcM
{
  provides
  {
    interface StdControl;
    interface IEnergySrc;
  }

  uses
  {
    interface Timer;
    interface IAccum;
  }

}

implementation
{

#include "SolarSrc.h"
	
	uint32_t start_energy;
	uint16_t min_time;
	uint32_t last_prediction;
	uint32_t cur_prediction;
	uint32_t e_mm;


  command result_t StdControl.init ()
  {
	
	min_time = 0;
	start_energy = 0;
	e_mm = 0;
	cur_prediction = 0;
	last_prediction = 0;
     return SUCCESS;
  }

  command result_t StdControl.start ()
  {
    call Timer.start (TIMER_REPEAT, 60L * 1024L);	//1min timer
    return SUCCESS;
  }

  command result_t StdControl.stop ()
  {
    call Timer.stop ();
    return SUCCESS;
  }



  event result_t Timer.fired ()
  {
	
	uint32_t net_energy;
	uint32_t end_energy;

	min_time = (min_time + 1) % _DAYLENGTH;
	
	if (min_time == 0)
	{
		//new period
		end_energy = (call IAccum.getInMicroJoules() / 1000);
		if (end_energy < start_energy)
		{
			net_energy = (0xFFFFFFFF - start_energy) + end_energy;
		} else {
			net_energy = end_energy - start_energy;
		}
		atomic 
		{
			e_mm = net_energy; //in mJ
			last_prediction = cur_prediction;
			cur_prediction = (e_mm * 9)/10 + (last_prediction)/10;
		
			start_energy = end_energy;
		}
	}
    
    return SUCCESS;
  }

  
	command int64_t IEnergySrc.getEnergyPrediction(uint16_t hours)
	{
		//give the current prediction in terms of minutes.
		int64_t result;
		result = (cur_prediction * 1000);
		result = (result * hours) / 24;
		return result;
	}

	
	command uint32_t IEnergySrc.getBattery()
	{
		return call IAccum.getReserve();
	}
	
	command uint32_t IEnergySrc.getBatteryCapacity()
	{
		return call IAccum.getCapacity();
	}
  

}
