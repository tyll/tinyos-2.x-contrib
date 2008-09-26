includes structs;

module WantItM
{
  provides
  {
    interface StdControl;
    interface IWantIt;
  }
  uses
  {
  	interface ConnMgr;
	
  }
}
implementation
{
#include "fluxconst.h"

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


  command result_t IWantIt.nodeCall (WantIt_in * in, WantIt_out * out)
  {
//PUT NODE IMPLEMENTATION HERE
	uint16_t mydelay;
	uint16_t yourdelay;
	
	//do I want this connection
	/*if (in->bw <= 0)
	{
		return FAIL;
	}*/
	out->bw = in->bw;
	
	out->addr = in->addr;
	
	mydelay = call ConnMgr.getDelayToBase(TRUE);
	yourdelay = call ConnMgr.getDelayToBaseThroughAddr(in->addr, TRUE);
	
	out->delay = mydelay;
	if (mydelay > yourdelay)
	{
		//I will only receive acks from you
		out->bw = 0;
	}
	
	out->accept = TRUE;
	signal IWantIt.nodeDone (in, out, ERR_OK);	
//Done signal can be moved if node makes split phase calls.
    
    return SUCCESS;
  }
}
