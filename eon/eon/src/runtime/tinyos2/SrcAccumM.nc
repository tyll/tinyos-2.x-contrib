

includes structs;
//includes timerdefs;
#include "SrcAccum.h"

module SrcAccumM
{
  provides
  {
  	interface Init;
    interface StdControl;
    interface IAccum;
  }
  uses
  {
    interface Timer<TMilli> as Timer0;
    interface DS2770;
    interface DS2751;
	interface RuntimeState;
  }

}

implementation
{

#include "rt_structs.h"

	uint32_t timestamp;
	uint64_t inuJoules;
	uint64_t outuJoules;
	
	int32_t disuJoules;
	int32_t netuJoules;
	
	//int32_t inmLong;
	//int32_t outmLong;
	int32_t uWin, uWout; //uW
	int32_t netmW;
    int32_t dismW;
	
	int16_t last_acr;
	int16_t g_temp;
	int16_t g_volts;
	
	
	
	
	bool init;
  	uint8_t counter;

	
  

  uint32_t window;		//in seconds
  uint32_t tickinterval = 2;	//

  
  command error_t Init.init ()
  {
  	inuJoules = 0;
  	outuJoules = 0;
	
	disuJoules = 0;
  	netuJoules = 0;
	
  	uWout = 0;
  	uWin = 0;
  	
  	
	init = FALSE;
	counter = 0;
  	return SUCCESS;
  }

  command error_t StdControl.start ()
  {
  	call DS2770.init();
	call DS2751.init();
	
    call Timer0.startPeriodic(POLL_2751_INTERVAL);	
    return SUCCESS;
  }

  command error_t StdControl.stop ()
  {
    call Timer0.stop ();
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

  void doCalc2751 ()
  {
	
	
    int32_t discharge;
        
	int16_t voltage_c;
    int32_t current_c;
    int16_t acr_c;
    int16_t temperature_c;
	

	call DS2751.getData (&voltage_c, &current_c, &acr_c, &temperature_c);
     
	
	if (current_c <= 100)
	{
		//shouldn't ever happen, but just in case.
		//this probably means that you have a miscalibrated DS2751
		current_c = 100; //uA
	}
	
    //convert to uW
    discharge = (voltage_c * current_c) / 1000;
	
	disuJoules += (discharge * POLL_2751_INTERVAL) / BIN_MS;
	
	
  }
  
  
  void doCalc2770 ()
  {
    int32_t netcharge;
        
	int16_t voltage;
    int32_t current;
    int16_t acr;
    int16_t temperature;
	int64_t intermed;

	__runtime_state_t * rtstate;
	
	rtstate = call RuntimeState.getState();
	
	call DS2770.getData (&voltage, &current, &acr, &temperature);
     
    //convert to uW
	netcharge = (voltage * current) / 1000;
	
	netuJoules += (netcharge * POLL_2770_INTERVAL) / BIN_MS;
	
	g_temp = temperature;
	g_volts = voltage;
	
	if (init)
	{
		//reserve = (acr * 37 * 360 * 1000)/4;	//.25mAhr -> uJ	
		intermed = getACRChange(last_acr,acr) * 3330;
		intermed = rtstate->batt_reserve + (intermed * 1000); //simplified version of the above
			
		if (intermed < 0)
		{
			intermed = 0;
		}
		if (intermed > BATTERY_CAPACITY)
		{
			intermed = BATTERY_CAPACITY;
		}
		//voltage-based sanity check
		//just in case we don't realize we're close to empty
		if (voltage < 3700 && voltage > 2800)
		{
			intermed = 0;
		}
		rtstate->batt_reserve = intermed;
		last_acr = acr;
			
	} else {
		last_acr = acr;
		init = TRUE;
	}
	
  }
  
  task void doEnergySum()
  {
  	int32_t in_delta;
	int32_t out_delta;
  
	atomic {
		out_delta = disuJoules;
		in_delta = disuJoules + netuJoules;
	
		disuJoules = 0;
		netuJoules = 0;
	}
	
	if (in_delta < 0)
	{
		//assume that source is always positive
		//any negatives get factored into the idle consumption later.
		out_delta = out_delta - in_delta;
		in_delta = 0;
	}
	
  	outuJoules += out_delta;
	inuJoules += in_delta;
	
	signal IAccum.update(in_delta, out_delta);
	
	
  }
  


  	event void Timer0.fired ()
  	{
		
		doCalc2751();
		if ((counter % POLL_DIFF_FACTOR) == 0)
		{
			doCalc2770();
		}
		if (counter >= POLL_CYCLES * POLL_DIFF_FACTOR)
		{
			post doEnergySum();
			counter = 0;
		} else {
			counter++;
		}
	}

  	


	command uint32_t IAccum.getInMicroJoules()
  	{
		//milli really
		uint32_t result = (inuJoules / 1000);
  		return result;
  	}
  
  command uint32_t IAccum.getOutMicroJoules()
  {
  		//milli really
		uint32_t result = (outuJoules / 1000);
  		return result;
  }
	
	
	
  
  command uint64_t IAccum.getReserve()
  {
  	__runtime_state_t *rtstate = call RuntimeState.getState();
  	return rtstate->batt_reserve;
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
