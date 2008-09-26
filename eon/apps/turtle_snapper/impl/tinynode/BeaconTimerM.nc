includes structs;

module BeaconTimerM
{
  provides
  {
    interface StdControl;
    interface IBeaconTimer;
  }
  uses
  {
    interface Timer;
	interface Timer as NBTimer;
	interface Random;
	interface BeaconSig;
  }
}

implementation
{
#include "fluxconst.h"

#define BEACON_TVAL		(60L * 10L)
#define BEACON_FUZZ		(60L)

#define NOBEACON_TIME	15L

  uint32_t value_ms;
  bool __started = FALSE;
  BeaconTimer_out *myout = NULL;
  bool nobeacon = FALSE;

  command result_t StdControl.init ()
  {
    return SUCCESS;
  }

  command result_t StdControl.start ()
  {
    return SUCCESS;
  }

  command result_t StdControl.stop ()
  {
    return SUCCESS;
  }

  command result_t IBeaconTimer.srcStart (BeaconTimer_out * out)
  {
    myout = out;
	call Timer.start (TIMER_ONE_SHOT, BEACON_TVAL * 1000L);
    return SUCCESS;
  }

  /*command result_t IBeaconTimer.setInterval (uint32_t value)
  {
    value_ms = value;
    if (!__started)
      {
	__started = TRUE;
	call Timer.start (TIMER_ONE_SHOT, value_ms);
      }
    return SUCCESS;
  }*/
  event result_t NBTimer.fired()
  {
  	nobeacon = FALSE;
  	return SUCCESS;
  }
  
  event result_t Timer.fired ()
  {
  	uint32_t ms_val;
	
	if (nobeacon == FALSE)
	{
    	signal IBeaconTimer.srcFired (myout);
		
	}
	
	ms_val = (BEACON_TVAL + ((call Random.rand() >> 8) % BEACON_FUZZ)) * 1000L;
	//ms_val = BEACON_TVAL * 1000;
	//ms_val = 30000L;
    call Timer.start (TIMER_ONE_SHOT, ms_val);
    return SUCCESS;
  }
  
  event void BeaconSig.beaconRecved(uint16_t addr)
  {
  	nobeacon = TRUE;
  	call NBTimer.start(TIMER_ONE_SHOT, NOBEACON_TIME * 1000L);
  }
}
