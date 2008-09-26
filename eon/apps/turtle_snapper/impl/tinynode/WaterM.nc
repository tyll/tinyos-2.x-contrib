

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
    
	TOSH_MAKE_WATER_CTL_OUTPUT();
    TOSH_CLR_WATER_CTL_PIN();
	valid = FALSE;
    dbg(DBG_BOOT, "Water sensor initialized.\n");
    return SUCCESS;
  }

  command result_t StdControl.start() 
  { 
  	result_t ok1,ok2,ok3;
	ok1 = call ADCControl.init();
	ok2 = call ADCControl.bindPort(TOSH_ADC_WATER_PORT, TOSH_ACTUAL_ADC_WATER_PORT);
	ok3 = call Timer.start(TIMER_REPEAT, WATER_POLL_INTERVAL);
    return rcombine3(ok1,ok2,ok3);
  }
  command result_t StdControl.stop() 
  {
  		call Timer.stop();
    	TOSH_CLR_WATER_CTL_PIN();
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
		valid = TRUE;
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

