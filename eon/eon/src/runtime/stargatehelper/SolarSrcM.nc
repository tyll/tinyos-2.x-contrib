
includes SolarSrc;


module SolarSrcM
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

	uint16_t history[_NUMEPOCHS][_HISTORYLENGTH];
	uint8_t history_count;
	uint8_t history_index;
	uint8_t current_epoch;
	uint32_t start_energy;
	uint16_t min_time;


  command result_t StdControl.init ()
  {
	history_count = 0;
	history_index = 0;
	current_epoch = 0;
	start_energy = 0;
	min_time = 0;
     return SUCCESS;
  }

  command result_t StdControl.start ()
  {
    call Timer.start (TIMER_REPEAT, 60 * 1024);	//1min timer
    return SUCCESS;
  }

  command result_t StdControl.stop ()
  {
    call Timer.stop ();
    return SUCCESS;
  }


	uint8_t getEpoch(uint16_t minutes)
	{
		return ((minutes * _NUMEPOCHS) / _DAYLENGTH);
	}
  


  event result_t Timer.fired ()
  {
	uint8_t new_epoch;
	uint32_t net_energy;
	uint32_t end_energy;

	min_time = (min_time + 1) % _DAYLENGTH;
	new_epoch = getEpoch(min_time);
	if (new_epoch != current_epoch)
	{
		end_energy = call IAccum.getInMilliJoules();
		if (end_energy < start_energy)
		{
			net_energy = (0xFFFFFFFF - start_energy) + end_energy;
		} else {
			net_energy = end_energy - start_energy;
		}
		history[current_epoch][history_index] = net_energy;
		
		//update counters;
		if (current_epoch == _NUMEPOCHS-1)
		{
			history_index = (history_index + 1) % _HISTORYLENGTH;
			if (history_count < _HISTORYLENGTH) history_count++;
		}
		current_epoch = new_epoch;
		start_energy = end_energy;
	}
    
    return SUCCESS;
  }

  
	command int32_t IEnergySrc.getEnergyPrediction(uint16_t minutes)
	{
		
	}

  

}
