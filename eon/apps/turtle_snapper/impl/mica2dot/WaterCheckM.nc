includes structs;

module WaterCheckM
{
  provides
  {
    interface StdControl;
    interface IWaterCheck;
  }
  uses
  {
  	
	interface StdControl as WaterControl;
	interface Timer;
	interface Leds;
	command bool getLevel(uint16_t *data);
  }
}
implementation
{
#include "fluxconst.h"

WaterCheck_in** node_in;
WaterCheck_out** node_out;

  command result_t StdControl.init ()
  {
  	call Leds.init();
  	return call WaterControl.init();
  }

  command result_t StdControl.start ()
  {
    return SUCCESS;
  }

  command result_t StdControl.stop ()
  {
    return SUCCESS;
  }

  command bool IWaterCheck.ready ()
  {
//PUT READY IMPLEMENTATION HERE

    return TRUE;
  }

  command result_t IWaterCheck.nodeCall (WaterCheck_in ** in,
					 WaterCheck_out ** out)
  {
//PUT NODE IMPLEMENTATION HERE
	node_in = in;
	node_out = out;

	
	
	call WaterControl.start();
	call Leds.redOn();
	return call Timer.start(TIMER_REPEAT, 400);

  }
  
  event result_t Timer.fired()
  {
  	uint16_t level;
	
  	call Timer.stop();
	call getLevel(&level); 
	
  	call WaterControl.stop();
	(*node_out)->howwet = level;
	call Leds.redOff();
	signal IWaterCheck.nodeDone(node_in, node_out, ERR_OK);
	
  	return SUCCESS;
  }
  

  
}
