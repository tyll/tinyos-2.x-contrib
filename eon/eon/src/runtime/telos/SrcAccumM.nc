

includes structs;
includes adcs;

module SrcAccumM
{
  provides
  {
    interface StdControl;
    interface IAccum;
  }
  uses
  {
    interface Timer;
    interface DS2770;
    interface ADC;
    interface ADCControl;
    interface LocalTime;
  }

}

implementation
{
	uint32_t timestamp;
	uint32_t inmJoules;
	uint32_t outmJoules;
	uint32_t mWin, mWout; //.01mW
	uint32_t reserve;
	uint16_t adcvalue;
	
  	uint8_t counter;
  	uint32_t tvolts;

  /*bool first_acr;
  int16_t last_acr;
  double avgin, avgout;*/


  uint32_t window;		//in seconds
  uint32_t tickinterval = 2;	//

  
  command result_t StdControl.init ()
  {
  	inmJoules = 0;
  	outmJoules = 0;
  	mWout = 0;
  	mWin = 0;
  	timestamp = call LocalTime.read();
  	
  	TOSH_MAKE_ADC0_INPUT ();
  	TOSH_SEL_ADC0_MODFUNC ();
    call ADCControl.init ();
    //call ADCControl.bindPort (TOS_ADC_A0_PORT, TOSH_ACTUAL_ADC_AO_PORT);
    return SUCCESS;
  }

  command result_t StdControl.start ()
  {
    call Timer.start (TIMER_REPEAT, 512);	//2s timer
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

  void doCalc ()
  {
	
	
    uint32_t netcharge;
    uint32_t charge;
    uint32_t discharge;
    uint32_t adc32;
    uint32_t newtime, elapsed;
    
    int16_t voltage;
    int32_t netcurrent;
    int16_t acr;
    int16_t temperature;


	atomic {
		newtime = call LocalTime.read();
		elapsed = getElapsed(timestamp, newtime);
		timestamp = newtime;
		//accumulate. in mJ
    	inmJoules += (elapsed / 100) * mWin / TIMERRES; 
		outmJoules += (elapsed / 100) * mWout / TIMERRES;
	}

    call DS2770.getData (&voltage, &netcurrent, &acr, &temperature);

	//convert to .01mW
	//p = (V * (ref-adc) * 3.2V) / (4096 * 2.5)
    //discharge = (100*voltage * (VREF - adcvalue) * 32)/(4096 * 25);
    //need to change order because it was overflowing the 32-bit int
    //discharge = (((100 * (VREF - adcvalue) * 32)/25) * voltage) / 4096;
    adc32 = adcvalue;
    tvolts = voltage;
    if (adc32 > VREF) adc32 = VREF;
    
    discharge = (((100 * (VREF - adc32) * 32)/25) * tvolts) / 4096;
    //discharge = (100 * (VREF - adc32) * 32);
	netcharge = (voltage * netcurrent) / 100;

	if (discharge > netcharge)
	{
		charge = 0;
		netcharge = discharge;
    }
    else
    {
		charge = netcharge - discharge;
    }
    
    
    
    atomic 
    {
	    mWin = charge;
	    mWout = discharge;
    	    	
	    
		
		//reserve = (acr * 37 * 360)/4;	//.25mAhr -> mJ	
		reserve = 26640000 - (acr * 3330); //simplified version of the above
	} //end atomic
    
  }


  	event result_t Timer.fired ()
  	{
   		call ADC.getData ();
	    return SUCCESS;
	}

  	async event result_t ADC.dataReady (uint16_t data)
  	{
    	adcvalue = data;
    	doCalc();
    	return SUCCESS;
  	}


	command uint32_t IAccum.getInMilliJoules()
  	{
  		uint32_t now_time;
  		uint32_t result;
  		uint32_t elapsed;
  		
  		now_time = call LocalTime.read();
  		
		atomic 
		{
			elapsed = getElapsed(timestamp, now_time);
			result = inmJoules + (elapsed / 100) * mWin / TIMERRES; 
		} //atomic
		
		return result;
  	}
  
  command uint32_t IAccum.getOutMilliJoules()
  {
  		uint32_t now_time;
  		uint32_t result;
  		uint32_t elapsed;
  		
  		now_time = call LocalTime.read();
  		
		atomic 
		{
			elapsed = getElapsed(timestamp, now_time);
			result = outmJoules + (elapsed / 100) * mWout / TIMERRES; 
			//result = mWout;
			//result = adcvalue;
		} //atomic
		
		return result;
  	}
  
  command uint32_t IAccum.getReserve()
  {
  	return reserve;
  }


}
