/**
 * Periodic Interval Timer
 * @author Rasmus Ulslev Pedersen
 */
#include "hardware.h"

module HplAT91PitM {
  provides {
    interface Init;
    interface HplAT91Pit;
  }
  uses {
    interface HplAT91Interrupt as SysIrq;
  }
}

implementation {

  uint32_t taskMiss;
  
  task void fireFromTask();

  command error_t Init.init()
  {
    // Testing
		//AT91F_AIC_ConfigureIt( AT91C_BASE_AIC, AT91C_ID_SYS, AT91C_AIC_PRIOR_HIGHEST, AT91C_AIC_SRCTYPE_INT_HIGH_LEVEL, cCommUpdateInt);
		//AT91F_AIC_ConfigureIt( AT91C_BASE_AIC, AT91C_ID_SYS, AT91C_AIC_PRIOR_HIGHEST, AT91C_AIC_SRCTYPE_INT_EDGE_TRIGGERED, cCommCtrl);
		//AT91F_AIC_EnableIt(AT91C_BASE_AIC, AT91C_ID_SYS);

    taskMiss = 0;

    call SysIrq.allocate();
    call SysIrq.enable();
    
    return SUCCESS;
  }

  async command uint32_t HplAT91Pit.getPITMR(){
    return AT91C_BASE_PITC->PITC_PIMR;
  }

  async command void HplAT91Pit.setPITMR(uint32_t val){
    AT91C_BASE_PITC->PITC_PIMR = val;
  }

  async command uint32_t HplAT91Pit.getPITSR(){
    return AT91C_BASE_PITC->PITC_PISR;
  }
  
  async command uint32_t HplAT91Pit.getPITPIVR(){
    return AT91C_BASE_PITC->PITC_PIVR;
  }
  
  async command uint32_t HplAT91Pit.getPITPIIR(){
    return AT91C_BASE_PITC->PITC_PIIR;
  }
  
  async event void SysIrq.fired() 
	{
		uint32_t pitregtmp;

    error_t taskRes;


		if(*AT91C_PITC_PISR & AT91C_PITC_PITS){
			pitregtmp = *AT91C_PITC_PIVR; /*acknowledge interrupt*/
			
			// Prepare the sync PIT task
			taskRes = post fireFromTask();
			if(taskRes != SUCCESS){
			  atomic {taskMiss++;}  
			}
			
			// Fire the async event
			signal HplAT91Pit.fired();
		}	  
	  
  }

  task void fireFromTask(){
    // Fire the sync event
    atomic {
      signal HplAT91Pit.firedTask(taskMiss);
      taskMiss = 0;
    }
  }
  
  default event void HplAT91Pit.firedTask(uint32_t tM){
  }
  
  default async event void HplAT91Pit.fired(){
  }
}

