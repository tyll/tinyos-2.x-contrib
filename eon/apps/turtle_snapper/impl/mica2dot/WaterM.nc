

includes sensorboard;
module WaterM {
  provides {
		interface StdControl;
		command bool getLevel(uint16_t *data);
	}

  uses {
    interface ADCControl;
		interface ADC;
		interface Timer;
  }
}
implementation {
	norace uint16_t level;
	norace bool pending;
	int count = 0;
	norace bool valid;

#define WATER_POLL_INTERVAL (60L * 1024L * 5L)
	

  command result_t StdControl.init() {
    call ADCControl.bindPort(TOS_ADC_WATER_PORT, TOSH_ACTUAL_WATER_PORT);
	TOSH_MAKE_WATER_CTL_OUTPUT();
    TOSH_CLR_WATER_CTL_PIN();
    dbg(DBG_BOOT, "Water sensor initialized.\n");
    return call ADCControl.init();
  }

  command result_t StdControl.start() 
  { 
  	
	/*bool first = FALSE;
	atomic 
	{
		if (count == 0)
		{
			TOSH_MAKE_WATER_CTL_OUTPUT();
    		TOSH_SET_WATER_CTL_PIN();
			first = TRUE;
		}	
		count++;
		
	}	
	if (first)
	{
		valid = FALSE;
		pending = FALSE;
		call Timer.start(TIMER_REPEAT, 300);
	}*/
	
    return call Timer.start(TIMER_REPEAT, WATER_POLL_INTERVAL);
  }
  command result_t StdControl.stop() {
  	atomic
	{
		count--;
		if (count == 0)	
		{
			call Timer.stop();
    		TOSH_CLR_WATER_CTL_PIN();
		}
	}
    return SUCCESS;
  }

  task void getDataTask()
  {
  	if (call ADC.getData() != SUCCESS)
	{
		TOSH_CLR_WATER_CTL_PIN();
	}
  }
  
	event result_t Timer.fired()
	{
		TOSH_MAKE_WATER_CTL_OUTPUT();
    	TOSH_SET_WATER_CTL_PIN();	
		
		if (!post getDataTask())
		{
			TOSH_CLR_WATER_CTL_PIN();
		}
		return SUCCESS;
  	}

 
	async event result_t ADC.dataReady(uint16_t data)
	{
		
		level = data;
		
		TOSH_CLR_WATER_CTL_PIN();	
		return SUCCESS;
	}
	
	command bool getLevel(uint16_t *data)
	{
#ifdef WITH_WATER_SENSOR
		*data = level;
#else
		*data = 0;
#endif
		return TRUE;
	}

	
}

