includes structs;
includes ServerE;

module SorryM
{
  provides
  {
    interface StdControl;
    interface ISorry;
  }
  uses
  {
  	interface Leds;
  	interface SendMsg;
  }
}
implementation
{
#include "fluxconst.h"

TOS_Msg buffer;
Sorry_in **invar;
Sorry_out **outvar;

bool busy = FALSE;

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

  command bool ISorry.ready ()
  {

    return !busy;
  }

	task void sendTask()
	{
		result_t res;
		
		res = call SendMsg.send((*invar)->request.src, sizeof(MetaMsg), &buffer);
		if (res == FAIL)
		{
			busy = FALSE;
			signal ISorry.nodeDone (invar, outvar, ERR_OK);
		}
			
	}
	
	event result_t SendMsg.sendDone(TOS_MsgPtr msg, result_t success)
	{
		if (msg == &buffer)
		{
			busy = FALSE;
			signal ISorry.nodeDone (invar, outvar, ERR_OK);
		}
		return SUCCESS;
	}

  command result_t ISorry.nodeCall (Sorry_in ** in, Sorry_out ** out)
  {
  	MetaMsgPtr mptr;
  	
  	busy = TRUE;
  	invar = in;
  	outvar = out;
  	
  	atomic {
	  	mptr = (MetaMsgPtr)buffer.data;
	  	mptr->src = (*invar)->request.src;
	  	mptr->suid = (*invar)->request.suid;
	  	mptr->size = 0;
	  	mptr->error = 1;
	}
  	
  	post sendTask();
	
    
    return SUCCESS;
  }
}
