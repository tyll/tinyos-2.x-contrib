#include "rt_structs.h"
#include "eonconst.h"

module RuntimeM
{
	provides
	{
		interface Init;
		interface RuntimeState;
	}
	uses
	{
		interface Boot;
		interface StdControl as SubControl;
		
		
		interface Timer<TMilli> as SaveTimer;
		//interface Timer<TMilli> as RecoverTimer;
		interface Timer<TMilli> as EvalTimer;
		interface Timer<TMilli> as RTClockTimer;
		interface IEval;
		interface IScheduler;
		interface Mount;
		interface ConfigStorage;
	}
}

implementation
{
	
	uint32_t rt_clock;
	//uint8_t curstate = STATE_BASE;
	//double curgrade = 0.0;
	
	task void RTStateInitTask();
	task void RecoverTask();
	task void MountTask();
	task void SaveConfigTask();
	
	__runtime_state_t __rtstate;
	
	command __runtime_state_t *RuntimeState.getState()
	{
		return &__rtstate;
	}
	
	
	command error_t Init.init()
	{
    	__rtstate.curstate = STATE_BASE;
		__rtstate.curgrade = 0.0;
		return SUCCESS;
	}
	
	
	event void Boot.booted()
	{
		call SubControl.start();
		//call RecoverTimer.startOneShot(RT_RECOVER_TIME);
    	call SaveTimer.startOneShot (RT_SAVE_TIME);
		call RTClockTimer.startPeriodic(RTCLOCKINTERVAL);
    	call EvalTimer.startPeriodic(EVALINTERVAL);

		post RTStateInitTask();
    	//call PowerEnable ();
		post MountTask();
	}

	event void RTClockTimer.fired()
	{
		rt_clock++;
	}
	
	event void EvalTimer.fired()
	{
		call IEval.reeval_energy_level();
	}
	
	event void IEval.reeval_done(uint8_t state, double grade)
	{
		__rtstate.curstate = state;
		__rtstate.curgrade = grade;
		call IScheduler.adjust_intervals(state, grade);
	}
	
	/**/
	
	task void MountTask()
	{
		error_t res;
		
		res = call Mount.mount();
		
		if (res != SUCCESS)
		{
			post MountTask();
		}
	}
	
	task void RTStateInitTask()
	{
		
		int i;
		int j=0;
		int numpaths = 0;
		
		
		//initial capacity assumption.
		//if recovering from a dead spell, this will be
		//detected and corrected in SrcAccumM.nc
		__rtstate.batt_reserve = BATTERY_CAPACITY/2;
		
		
		__rtstate.load_avg = 0.0;
		
		//initialize sources and paths
		for (j=0; j < NUMSOURCES; j++)
		{
			numpaths = 0;
			for (i=0; i < NUMPATHS; i++)
			{
				if (pathSrc[i] == j) numpaths++;
			}
			for (i=0; i < NUMPATHS; i++)
			{
				if (pathSrc[i] == j)
				{
					__rtstate.prob[i] = (100 / numpaths);
					__rtstate.pc[i] = 0;
				}
			}
			__rtstate.srcprob[j] = 0;
			__rtstate.spc[j] = 0;
		}
		//initialize path energy	
		for (i=0; i < NUMPATHS; i++)
		{
			__rtstate.pathenergy[i] = -1;
		}

	}
	
	task void RecoverTask()
	{
		error_t res;
		
		res = call ConfigStorage.read(0, &__rtstate, sizeof(__rtstate));
		
		if (res == EBUSY)
		{
			post RecoverTask();
		}
	}	
	
	task void SaveConfigTask()
	{
		error_t res;
		
		res = call ConfigStorage.write(0, &__rtstate, sizeof(__rtstate));
		
		if (res == EBUSY)
		{
			post SaveConfigTask();
		}
	}
	
	task void CommitTask()
	{
		error_t res;
		
		res = call ConfigStorage.commit();
		
		if (res == EBUSY)
		{
			post CommitTask();
		}
	}
	
	/*event void RecoverTimer.fired()
	{
		post MountTask();
	}*/
	
	event void SaveTimer.fired()
	{
		post SaveConfigTask();
	}
	

	
	event void IScheduler.flow_energy (uint16_t flow, uint32_t energy)
	{
		call IEval.reportPathDone(flow, __rtstate.curstate, energy);	
	
		//signal IPathDone.done(flow, energy, __rtstate.prob[flow], __rtstate.srcprob[pathSrc[flow]]);	
	}
	
	event void Mount.mountDone(error_t error)
	{
		if (call ConfigStorage.valid())
		{
			post RecoverTask();
		}
	}
	
	event void ConfigStorage.writeDone(storage_addr_t addr, void* buf, storage_len_t len, error_t error)
	{
		if (error == SUCCESS)
		{
			post CommitTask();
		}
	}
	
	event void ConfigStorage.readDone(storage_addr_t addr, void* buf, storage_len_t len, error_t error)
	{
		if (error == EBUSY)
		{
			post RecoverTask();
		}
	}
	
	event void ConfigStorage.commitDone(error_t error)
	{
		if (error == EBUSY)
		{
			post CommitTask();
		}
	}
	
}
