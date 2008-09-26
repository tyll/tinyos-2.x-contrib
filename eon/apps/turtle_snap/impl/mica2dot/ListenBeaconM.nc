includes structs;

module ListenBeaconM
{
	provides
	{
		interface StdControl;
		interface IListenBeacon;
	}
	uses
	{
		interface ReceiveMsg;
		interface Timer;
	}
} 
implementation
{
#include "fluxconst.h"
//#include "uservariables.h"

	ListenBeacon_out **node_out;

	command result_t StdControl.init ()
	{
		g_connected = FALSE;
		
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

	command result_t IListenBeacon.srcStart (ListenBeacon_out ** out)
	{
		node_out = out;
		call Timer.start(TIMER_REPEAT, CONNECTION_EVENT_TIMEOUT * 1024);
	
		return SUCCESS;
	}
  
	event TOS_MsgPtr ReceiveMsg.receive (TOS_MsgPtr msg)
	{
		BeaconMsg_t *body = (BeaconMsg_t *) msg->data;

		(*node_out)->version = body->version_num;
		(*node_out)->addr = body->src_addr;

		signal IListenBeacon.srcFired (node_out);
		
		return msg;
	}
	
	event result_t Timer.fired()
	{
		atomic {
			//is connected
			if (g_connected && g_active == FALSE)
			{
				//cancel connection
				g_connected = FALSE;
			} else {
				//reset the active flag.  If it doesn't get set to true before this timer fires again, 
				//then the connection will be cancelled
				g_active = FALSE;
			}
		}
		return SUCCESS;
	}

}
