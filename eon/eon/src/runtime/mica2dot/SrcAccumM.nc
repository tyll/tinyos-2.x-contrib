

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
    interface DS2751;
    interface SysTime;
	interface Leds;
  }

}

implementation
{

#include "rt_structs.h"

	uint32_t timestamp;
	uint32_t inuJoules;
	uint32_t outuJoules;
	//int32_t inmLong;
	//int32_t outmLong;
	int32_t uWin, uWout; //uW
	int32_t netmW;
    int32_t dismW;
	
	int16_t last_acr;
	int16_t g_temp;
	int16_t g_volts;
	
	
	#define POLL_INTERVAL	(1 * 1024)
	bool init;
  	uint8_t counter;

	
 

  uint32_t window;		//in seconds
  uint32_t tickinterval = 2;	//

  
  command result_t StdControl.init ()
  {
  	inuJoules = 0;
  	outuJoules = 0;
	
	//inmLong = 0;
  	//outmLong = 0;
	call Leds.init();
	*g_lastmem = 0xbeef;
	
  	uWout = 0;
  	uWin = 0;
  	
  	//battery_reserve = 0;  //assume empty to start with
	init = FALSE;
  	return SUCCESS;
  }

  command result_t StdControl.start ()
  {
  	call DS2770.init();
	call DS2751.init();
	timestamp = call SysTime.getTime32();
    call Timer.start (TIMER_REPEAT, POLL_INTERVAL);	
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
	
	int16_t getACRChange(int16_t last, int16_t newacr)
	{
			
		return (newacr - last);
	}

  void doCalc ()
  {
	
	
    int32_t netcharge;
    int32_t discharge;
    uint32_t newtime, elapsed;
    
    int16_t voltage;
    int32_t netcurrent;
    int16_t acr;
    int16_t temperature;
	
	int16_t voltage_c;
    int32_t current_c;
    int16_t acr_c;
    int16_t temperature_c;
	
	int64_t intermed;


	atomic {
		newtime = call SysTime.getTime32();
		elapsed = getElapsed(timestamp, newtime);
		timestamp = newtime;
		//accumulate. in mJ
		if (elapsed < 0 || uWin < 0 || uWout < 0)
		{
			//this would be very bad
			inuJoules = 0;
			outuJoules = 0;
		} else {
			intermed = elapsed;
			intermed = (intermed * uWin) / TIMERRES;
    		//inuJoules += intermed; 
			inuJoules += uWin;
			intermed = elapsed;
			intermed = (intermed * uWout) / TIMERRES;
			//outuJoules += intermed;
			outuJoules += uWout;
		}
	}

    call DS2770.getData (&voltage, &netcurrent, &acr, &temperature);
	call DS2751.getData (&voltage_c, &current_c, &acr_c, &temperature_c);

	//convert to .01mW
	//p = (V * (ref-adc) * 3.2V) / (4096 * 2.5)
    //discharge = (100*voltage * (VREF - adcvalue) * 32)/(4096 * 25);
    //need to change order because it was overflowing the 32-bit int
    //discharge = (((100 * (VREF - adcvalue) * 32)/25) * voltage) / 4096;
    
    g_temp = temperature;
	g_volts = voltage;
    
	
	if (current_c <= 300)
	{
		//shouldn't ever happen, but just in case.
		//this probably means that you have a miscalibrated DS2751
		current_c = 300; //uA
	}
	
    //convert to uW
    discharge = (voltage_c * current_c) / 1000;
	netcharge = (voltage * netcurrent) / 1000;
	dismW = current_c;
	netmW = netcurrent;

	
    atomic 
    {
	    
		
		//convert to mW
		uWin = (discharge + netcharge);
	    uWout = discharge;
		
		dismW = uWout;
		netmW = uWin;
		
		if (uWin < 0)
		{
			//uWout  = uWout - uWin;
			uWin = 0;
		}
    	    		
		
		if (init)
		{
			//reserve = (acr * 37 * 360 * 1000)/4;	//.25mAhr -> uJ	
			intermed = getACRChange(last_acr,acr) * 3330;
			intermed = __rtstate.batt_reserve + (intermed * 1000); //simplified version of the above
			
			if (intermed < 0)
			{
				intermed = 0;
			}
			if (intermed > BATTERY_CAPACITY)
			{
				intermed = BATTERY_CAPACITY;
			}
			__rtstate.batt_reserve = intermed;
			last_acr = acr;
			
		} else {
			last_acr = acr;
			init = TRUE;
		}
		
	} //end atomic
    
  }

  void BlinkLikeCrazy()
  {
  	while (1)
	{
		TOSH_uwait(10000L);
		TOSH_uwait(10000L);
		TOSH_uwait(10000L);
		TOSH_uwait(10000L);
		TOSH_uwait(10000L);
		TOSH_uwait(10000L);
		TOSH_uwait(10000L);
		TOSH_SET_RED_LED_PIN();
		TOSH_uwait(10000L);
		TOSH_uwait(10000L);
		TOSH_uwait(10000L);
		TOSH_uwait(10000L);
		TOSH_uwait(10000L);
		TOSH_uwait(10000L);
		TOSH_CLR_RED_LED_PIN();
	}
  }
  

  	event result_t Timer.fired ()
  	{
		if (*g_lastmem != 0xbeef)
		{
			BlinkLikeCrazy();
		} else {
			doCalc();
		}
	    return SUCCESS;
	}

  	


	command uint32_t IAccum.getInMicroJoules()
  	{
  		uint32_t now_time;
  		uint32_t result;
  		uint32_t elapsed;
  		int64_t intermed;
  		
  		
		atomic 
		{
			now_time = call SysTime.getTime32();
			elapsed = getElapsed(timestamp, now_time);
			intermed = elapsed;
			intermed = (intermed * uWin) / TIMERRES;
			result = inuJoules + intermed; 
		} //atomic
		
		//result = uWin;//TEST
		//result = inuJoules;
		//result = (elapsed / (TIMERRES / 100));
		//result = netmW;
		return result;
  	}
  
  command uint32_t IAccum.getOutMicroJoules()
  {
  		uint32_t now_time;
  		uint32_t result;
  		uint32_t elapsed;
  		int64_t intermed;
  		
  		
		atomic 
		{
			now_time = call SysTime.getTime32();
			elapsed = getElapsed(timestamp, now_time);
			intermed = elapsed;
			intermed = (intermed * uWout) / TIMERRES;
			result = outuJoules + intermed; 
			//result = outuJoules + elapsed; 
		} //atomic
		
		//result = uWout;//TEST
		//result = outuJoules;
		//result = dismW;
		return result;
  	}
	
	
	command int32_t IAccum.getInMilliLong()
  	{
  		uint32_t now_time;
  		uint32_t result;
  		uint32_t elapsed;
  		
  		now_time = call SysTime.getTime32();
  		
		atomic 
		{
			elapsed = getElapsed(timestamp, now_time);
			result = inuJoules + (elapsed / 100) * uWin / TIMERRES; 
		} //atomic
		
		return result;
  	}
  
  command int32_t IAccum.getOutMilliLong()
  {
  		uint32_t now_time;
  		uint32_t result;
  		uint32_t elapsed;
  		
  		now_time = call SysTime.getTime32();
  		
		atomic 
		{
			elapsed = getElapsed(timestamp, now_time);
			result = outuJoules + (elapsed / 100) * uWout / TIMERRES; 
			//result = uWout;
			//result = adcvalue;
		} //atomic
		
		return result;
  	}
  
  command uint64_t IAccum.getReserve()
  {
  	return __rtstate.batt_reserve;
  }
  
  command uint64_t IAccum.getCapacity()
  {
  	return BATTERY_CAPACITY;
  }

  
  command uint16_t IAccum.getVoltage()
  {
  	return g_volts;;
  }
  
  command int16_t IAccum.getTemperature()
  {
  	return g_temp;
  }

}
