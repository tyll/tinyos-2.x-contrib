




module TestAccumM
{
  provides
  {
    interface StdControl;
  }

  uses
  {
    interface Timer;
    interface IEnergyMap;
    interface IAccum;
    interface SendMsg;
  }

}
implementation
{
	uint32_t previous_energy;
	TOS_Msg msg;

  command result_t StdControl.init ()
  {
	
    return SUCCESS;
  }

  command result_t StdControl.start ()
  {
  	
	
	call Timer.start(TIMER_REPEAT, 1024);
    return SUCCESS;
  }

  command result_t StdControl.stop ()
  {
    call Timer.stop ();
    
    return SUCCESS;
  }

  event result_t Timer.fired ()
  {
  	static int count = 0;
  	 uint32_t energy;
  	 uint32_t raw_energy;
  	 
  	 count++;
  	 
  	 if (count == 9)
  	 {
  	 	call IEnergyMap.startPath(0);
  	 	//call IEnergyMap.startPath(1);
  	 	return SUCCESS;
  	 }
  	 
  	 
  	 if (count == 10)
  	 {
  	 	call IEnergyMap.getPathEnergy(0, &energy);
  	 	*((uint32_t*)msg.data) = energy;
  	 	call SendMsg.send(TOS_BCAST_ADDR, sizeof(uint64_t), &msg);
  	 	return SUCCESS;
  	 }
  	 
  	 /*if (count == 11)
  	 {
  	 	call IEnergyMap.getPathEnergy(1, &energy);
  	 	*((uint32_t*)msg.data) = energy;
  	 	call SendMsg.send(TOS_BCAST_ADDR, sizeof(uint64_t), &msg);
  	 	return SUCCESS;
  	 }*/
  	 
  	 
	  raw_energy = call IAccum.getOutMilliJoules();
	  *((uint32_t*)msg.data) = raw_energy;
  	  call SendMsg.send(TOS_BCAST_ADDR, sizeof(uint32_t), &msg);
  	
  	
  	
  	return SUCCESS;
  
 }
 
 event result_t SendMsg.sendDone(TOS_MsgPtr pmsg, result_t success)
 {
 	return SUCCESS;
 }
 
 	

}
