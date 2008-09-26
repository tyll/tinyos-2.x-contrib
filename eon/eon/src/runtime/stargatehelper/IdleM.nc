

module IdleM
{
  provides
  {
    interface StdControl;
    interface IIdle;
  }
  uses
  {
    interface IAccum;
    interface SysTime;
	interface Timer;
  }

}

implementation
{
	int64_t last_out;
	int32_t idle;
	
	#define IDLE_SECONDS	(5L)
	#define IDLE_INTERVAL	(IDLE_SECONDS * 1024L)
	#define IDLE_FACTOR    7

  command result_t StdControl.init ()
  {
  	idle = 20000;
  	return SUCCESS;
  }

  command result_t StdControl.start ()
  {
    
    return SUCCESS;
  }

  command result_t StdControl.stop ()
  {
    call Timer.stop ();
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
	
	command int32_t IIdle.getIdle()
	{
		return (idle / IDLE_SECONDS);
	}
	
  	command result_t IIdle.setLoad(int numpaths)
	{
		if (numpaths > 0)
		{
			return SUCCESS;
		}	
		
		last_out = call IAccum.getOutMicroJoules();
		call Timer.start(TIMER_REPEAT, IDLE_INTERVAL);
		return SUCCESS;
	}
	
	event result_t Timer.fired()
	{
		int64_t newout = call IAccum.getOutMicroJoules();
		
		
		if ((newout - last_out) > 0)
		{
			idle = idle + ((newout-last_out)/IDLE_FACTOR);
		}
		return SUCCESS;
	}

}
