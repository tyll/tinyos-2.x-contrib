


#include "SrcAccum.h"

module EnergyMapperM
{
  provides
  {
    interface StdControl;
    interface IEnergyMap;
  }

  uses
  {
    //interface Timer;
    interface IAccum;
    //interface LocalTime;
	//interface SysTime;
	interface Leds;
  }

}
implementation
{

#include "timerdefs.h"

typedef struct pathrecord_t
{
	uint16_t session;
	uint16_t path;
	uint64_t energy;
	bool valid;
	bool done;
	uint16_t count;
	
} pathrecord_t;

enum
{
	EM_NUMRECORDS = 23L,
	EM_TIMER_VAL = 25L * 60L * 1024L,  //in ms
	EM_MAX_COUNT = 400, // 20 minute limit
};

	pathrecord_t paths[EM_NUMRECORDS];
	

	uint32_t in_energy;
	uint32_t out_energy;
	
	uint32_t idleenergy = 0;
	
	uint16_t to_counter;
	uint8_t load;
	bool timer_active;
	int idlecount = 0;
	
	task void partitionEnergy();

  command result_t StdControl.init ()
  {
	
	load = 0;
	call Leds.init();
    return SUCCESS;
  }

  command result_t StdControl.start ()
  {
  	int i;
  
  	//tomic 
	{
		load = 0;  	
		for (i=0; i < EM_NUMRECORDS; i++)
		{
			paths[i].valid = FALSE;
		}
	}
		
    return SUCCESS;
  }

  command result_t StdControl.stop ()
  {
  	int i;
  	
    atomic 
    {
		load = 0;
    	for (i=0; i < EM_NUMRECORDS; i++)
		{
			paths[i].valid = FALSE;
		}
	}
    return SUCCESS;
  }

  event void IAccum.update(int32_t inuJ, int32_t outuJ)
  {
  	//in_energy = inuJ;
	out_energy = outuJ;
	post partitionEnergy();
  	//partition the energy
  }
 
 	task void partitionEnergy()
 	{
		uint32_t residual;
		uint32_t thisidle;
		uint32_t em_result;
		uint32_t tmp32;
		
		int i;
		
		//get idle estimate for this time chunk.
		
		if (idleenergy == 0 && load == 0)
		{
			idleenergy = out_energy;
		}
		
		if (out_energy < idleenergy)
		{	
			thisidle = out_energy;
			residual = 0;
		} else {
			thisidle = idleenergy;
			residual = out_energy - idleenergy;
		}
	
		//attribute energy to paths
		if (load > 0)
		{
			idlecount = 0;
				for (i=0; i < EM_NUMRECORDS; i++)
				{
					if (paths[i].valid == TRUE)
					{
						tmp32 = residual;
						tmp32 = tmp32 / load;
						tmp32++;
						//paths[i].energy = idleenergy;
						paths[i].energy += tmp32;
						//paths[i].energy += residual;
						paths[i].count++;
						 
						if (paths[i].done)
						{
							
							em_result = (paths[i].energy / 100)+1;
							signal IEnergyMap.pathEnergy(paths[i].path, em_result, FALSE);
							
							paths[i].valid = FALSE;
							atomic load--;
						} else {
							if (paths[i].count > EM_MAX_COUNT)
							{
								atomic load--;
								paths[i].valid = FALSE;
							}
						}
					}
				}		
		}
		else
		{
			idlecount++;
			thisidle = out_energy;
		}
		 
		if (thisidle != idleenergy && idlecount > 1)
		{
			idleenergy = ((idleenergy * 90) + (thisidle * 10)) / 100;
		}
		
    
    	return;
  	}

  	command result_t IEnergyMap.startPath(uint16_t sessionid)
  	{
  		
  		uint16_t idx;
  		
  		atomic {
  			idx = (sessionid % EM_NUMRECORDS); 

  			if (paths[idx].valid == FALSE)
  			{
				paths[idx].valid = TRUE;
			} else {
				return FAIL;
			}		
		
  			paths[idx].session = sessionid;
  			paths[idx].energy = 0;
			paths[idx].count = 0;
			paths[idx].path = 0;
			paths[idx].done = FALSE;
  			load++;
  		} //atomic
  		return SUCCESS;
  	}
	
	command result_t IEnergyMap.endPath(uint16_t sessionid, uint16_t path)
  	{
  		
  		uint16_t idx;
  		
  		atomic {
  			idx = (sessionid % EM_NUMRECORDS); 

  			if (paths[idx].valid == FALSE || paths[idx].session != sessionid)
  			{
				return FAIL;
			}
		
  			paths[idx].path = path;
  			paths[idx].done = TRUE;
  		} //atomic
  		return SUCCESS;
  	}
	
  	
	command uint32_t IEnergyMap.idlePower() 
	{
		return (idleenergy / (POLL_2770_INTERVAL * POLL_CYCLES / BIN_MS));
	
	}
  

}
