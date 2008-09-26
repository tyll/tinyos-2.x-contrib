includes structs;

module GPRSTimerM
{
  provides
  {
    interface StdControl;
    interface IGPRSTimer;
  }
  uses
  {
    interface Timer;
    interface Timer as BlinkTimer;
    interface Timer as OffTimer;
    interface Leds;
    interface IAccum;
  }
}

implementation
{
#include "fluxconst.h"

  uint32_t value_ms = 1024L * 60L * 2L;
  
  bool __started = FALSE;
  GPRSTimer_out *myout = NULL;
  
  

  command result_t StdControl.init ()
  {
    return SUCCESS;
  }

  command result_t StdControl.start ()
  {
  	call Leds.init();
	
    return SUCCESS;
  }

  command result_t StdControl.stop ()
  {
    return SUCCESS;
  }

  bool setNextTimer()
  {
  	int32_t v = call IAccum.getVoltage();
	int32_t ival;
	
	ival = (29200 - (7 * v)) / 100; 
	if (ival < 2) ival = 2;
	if (ival > 20) ival = 20;
	
	call Timer.start(TIMER_ONE_SHOT, 1024L * 60L * ival);
	return TRUE;
	
  }
  
  command result_t IGPRSTimer.srcStart (GPRSTimer_out * out)
  {
    myout = out;
    call Timer.start (TIMER_ONE_SHOT, 1024L * 60L * 2L); //2 minute
    call BlinkTimer.start(TIMER_REPEAT, 30L * 1024L);
    return SUCCESS;
  }

  /*command result_t IGPRSTimer.setInterval (uint32_t value)
  {
    value_ms = value;
    if (!__started)
      {
	__started = TRUE;
	call Timer.start (TIMER_ONE_SHOT, value_ms);
      }
    return SUCCESS;
  }*/
  
  event result_t Timer.fired ()
  {
    signal IGPRSTimer.srcFired (myout);
    setNextTimer();
    return SUCCESS;
  }
  
  event result_t BlinkTimer.fired ()
  {
    call Leds.redOn();
    call OffTimer.start(TIMER_ONE_SHOT, 1024);
    return SUCCESS;
  }
  
  event result_t OffTimer.fired ()
  {
    call Leds.redOff();
    return SUCCESS;
  }
  
  event void IAccum.update(int32_t inuJ, int32_t outuJ)
  {
  }
}
