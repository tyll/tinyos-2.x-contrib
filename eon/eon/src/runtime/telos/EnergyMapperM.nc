




module EnergyMapperM
{
  provides
  {
    interface StdControl;
    interface IEnergyMap;
  }

  uses
  {
    interface Timer;
    interface IAccum;
    interface LocalTime;
  }

}
implementation
{


typedef struct pathrecord_t
{
	uint16_t session;
	uint32_t energy;
	bool valid;
} pathrecord_t;

enum
{
	EM_NUMRECORDS = 10,
	EM_TIMER_VAL = 15000,  //in ms
	EM_IDLE_POWER = 0, //in mW change this later
	EM_TIMERRES = 32768
};

	pathrecord_t paths[EM_NUMRECORDS];
	

	uint32_t previous_energy;
	uint32_t previous_time;
	uint16_t to_counter;
	uint8_t load;
	bool timer_active;

  command result_t StdControl.init ()
  {
	previous_energy = 0;
	to_counter = 0;
	timer_active = FALSE;
	load = 0;
    return SUCCESS;
  }

  command result_t StdControl.start ()
  {
  	int i;
  	
  	previous_time = call LocalTime.read();
  	atomic {
	  	previous_energy = 0;
		to_counter = 0;
		timer_active = FALSE;
		load = 0;
		for (i=0; i < EM_NUMRECORDS; i++)
		{
			paths[i].valid = FALSE;
		}
	}
	call Timer.stop();
	previous_energy = call IAccum.getOutMilliJoules();
	
    return SUCCESS;
  }

  command result_t StdControl.stop ()
  {
  	int i;
  	
    call Timer.stop ();
    load = 0;
    atomic 
    {
    	for (i=0; i < EM_NUMRECORDS; i++)
		{
			paths[i].valid = FALSE;
		}
	}
    return SUCCESS;
  }

  event result_t Timer.fired ()
  {
  	//reset all paths
  	int i;
  	
  	for (i=0; i < EM_NUMRECORDS; i++)
  	{
  		paths[i].valid = FALSE;
  	}
  	return SUCCESS;
  
 }
 
 	result_t updateEnergy()
 	{
		int i;
		uint32_t next_time,elapsed;
		uint32_t next_energy;
		uint32_t net_energy;
		uint32_t resid_energy;
		bool active = FALSE;
	
		atomic {
			next_energy = call IAccum.getOutMilliJoules();
			next_time = call LocalTime.read();
			
			if (next_energy < previous_energy)
			{
				net_energy = (0xFFFFFFFF - previous_energy) + next_energy;
			} else {
				net_energy = next_energy - previous_energy;
			}
			
			if (next_time < previous_time)
			{
				elapsed = (0xFFFFFFFF - previous_time) + next_time;
			} else {
				elapsed = next_time - previous_time;
			}
			
			if (net_energy > EM_IDLE_POWER)
			{
				resid_energy = net_energy - ((EM_IDLE_POWER*elapsed)/EM_TIMERRES);
			} else {
				resid_energy = 0;
			}

	
		
			//attribute energy to paths
			if (load > 0)
			{
				for (i=0; i < EM_NUMRECORDS; i++)
				{
					if (paths[i].valid == TRUE)
					{
						paths[i].energy += (resid_energy / load);
						active = TRUE;
					}
				}		
			}
		}//atomic
		if (!active) 
		{
			call Timer.stop();
			load = 0;
		}
		previous_energy = next_energy;
    
    	return SUCCESS;
  	}

  	command result_t IEnergyMap.startPath(uint16_t sessionid)
  	{
  		result_t res;
  		uint16_t idx;
  		bool change;
  		
  		//update energy
  		updateEnergy();
  		
  		
  		idx = (sessionid % EM_NUMRECORDS); 

  		change = FALSE;
  		atomic {
  			if (paths[idx].valid == FALSE)
  			{
				change = TRUE;
				paths[idx].valid = TRUE;
			}
		}//atomic
		if (!change) return FAIL;
  		
  		atomic
  		{
  			paths[idx].session = sessionid;
  			paths[idx].energy = 0;
  			load++;
  			call Timer.start(TIMER_ONE_SHOT, EM_TIMER_VAL);
  		}
  		return SUCCESS;
  	}
  	
	command result_t IEnergyMap.getPathEnergy(uint16_t sessionid, uint32_t* energy)  //in 0.01mJ
	{
		int idx;
		
		updateEnergy();
		
		idx = sessionid % EM_NUMRECORDS;
		if (!paths[idx].valid ||
			paths[idx].session != sessionid)
			{
				return FAIL;
			}
		
		atomic {
			to_counter = 0;
			load--;
			if (load <= 0)
			{
				call Timer.stop();
			}
			*energy = paths[idx].energy;
			paths[idx].valid = FALSE;
		}
				
		return SUCCESS;
	
	}
  

}
