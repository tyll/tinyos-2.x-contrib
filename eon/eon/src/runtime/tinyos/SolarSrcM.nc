
#include "SolarSrc.h"


module SolarSrcM
{
  provides
  {
    interface StdControl;
    interface IEnergySrc;
	interface IDayNight;	
  }

  uses
  {
    interface Timer;
    interface IAccum;
	interface IDayNight as IDummyDayNight;
  }

}

implementation
{

	uint64_t pred[_NUMEPOCHS];
	uint8_t current_epoch;
	uint64_t cur_energy;
	uint16_t min_time;


  command result_t StdControl.init ()
  {
  	int i;
	
	for (i=0; i < _NUMEPOCHS; i++)
	{
		pred[i] = 0;
	}
	current_epoch = 0;
	cur_energy = 0;
	min_time = 0;
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
  

	event void IAccum.update(int32_t inuJ, int32_t outuJ)
	{
		if (inuJ < 0)
		{
			return;
		}
		cur_energy += inuJ;
	
	}

  event result_t Timer.fired ()
  {
	
	min_time++;
	
	if (min_time >= _EPOCHLENGTH)
	{
		pred[current_epoch] = ((pred[current_epoch]*70) + (cur_energy * 30))/100;
		min_time = 0;
		current_epoch = (current_epoch +1) % _NUMEPOCHS;
		signal IDayNight.update(cur_energy > _DAYNIGHT_THOLD);
		cur_energy = 0;
	}
    return SUCCESS;
  }

  event void IDummyDayNight.update(bool isDay)
  {
  
  }
	

  command int64_t IEnergySrc.getEnergyPrediction(uint16_t hours)
	{
		
		int64_t result;
		int64_t daysum;
		int i;
		int j;
		uint16_t eps, days, hrs;
		
		daysum = 0;
		for (j=0; j < _NUMEPOCHS; j++)
		{
			daysum += pred[j];
		}
		eps = hours / _HRS_PER_EP;
		days  = eps / _NUMEPOCHS;
		hrs = eps % _NUMEPOCHS;
		
		
		result = daysum;
		for (i=0; i < hrs; i++)
		{
			result += pred[((current_epoch+1+i) %_NUMEPOCHS)]; 
		}
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
