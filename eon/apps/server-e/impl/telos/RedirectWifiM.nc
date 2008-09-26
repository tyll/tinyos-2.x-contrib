includes structs;
includes ServerE;

module RedirectWifiM
{
  provides
  {
    interface StdControl;
    interface IRedirectWifi;
  }
  uses
  {
  	interface SendMsg;
  	interface Leds;
  }
}
implementation
{
#include "fluxconst.h"

TOS_Msg buffer;
RedirectWifi_in **invar;
RedirectWifi_out **outvar;

bool busy = FALSE;
uint16_t port = 7000;

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

  command bool IRedirectWifi.ready ()
  {

    return !busy;
  }
  
  task void sendTask()
	{
		result_t res;
		static int postcount = 0;
		
		res = call SendMsg.send((*invar)->request.src, sizeof(RedirectMsg), &buffer);
		if (res == FAIL)
		{
			if (postcount < 4)
			{
				postcount++;
				if (post sendTask() == FAIL)
				{
					busy = FALSE;
					signal IRedirectWifi.nodeDone (invar, outvar, ERR_USR);
				}
				return;
			}
			busy = FALSE;
			signal IRedirectWifi.nodeDone (invar, outvar, ERR_USR);
			return;
		}
			
	}
	
	event result_t SendMsg.sendDone(TOS_MsgPtr msg, result_t success)
	{
		if (msg == &buffer)
		{
			busy = FALSE;
			if (success == SUCCESS)
			{
				
				signal IRedirectWifi.nodeDone (invar, outvar, ERR_OK);
			} else {
				signal IRedirectWifi.nodeDone (invar, outvar, ERR_USR);
			}
		}
		return SUCCESS;
	}

  command result_t IRedirectWifi.nodeCall (RedirectWifi_in ** in,
					   RedirectWifi_out ** out)
  {
	RedirectMsgPtr mptr;

  	//busy = TRUE;  	
  	
  	invar = in;
  	outvar = out;
  	
	
  	memcpy(&((*outvar)->request), &((*invar)->request), sizeof(RequestMsg));
  	(*outvar)->type = (*invar)->type;
  	(*outvar)->port_num = port;
  	
  	
  	
		
  	atomic {
  	
	  	mptr = (RedirectMsg*)(buffer.data);
	  	mptr->src = TOS_LOCAL_ADDRESS;
	  	mptr->suid = (*invar)->request.suid;
	  	mptr->port = port;
	  	mptr->delay_ms = 3000;
	  	
	}
	
	port++;
  	if (port >= 8000) port = 7000;
  	
  	
  	if (post sendTask() == FAIL)
  	{
  		return FAIL;
	}
    
    
    return SUCCESS;
  }
}
