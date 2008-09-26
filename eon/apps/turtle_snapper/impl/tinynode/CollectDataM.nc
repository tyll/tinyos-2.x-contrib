includes structs;

module CollectDataM
{
	provides
	{
		interface StdControl;
		interface ICollectData;
	}
	uses
	{
		interface ReceiveMsg;
		interface ConnMgr;
	}
}
implementation
{
#include "fluxconst.h"

	
	CollectData_out *node_out;
	
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
	
	
	command result_t ICollectData.srcStart (CollectData_out * out)
	{
		node_out = out;
		return SUCCESS;
	}
	
	
	
	event TOS_MsgPtr ReceiveMsg.receive (TOS_MsgPtr msg)
	{
		result_t res;
		
		GetPageMsg_t *body = (GetPageMsg_t *) msg->data;
		
		
		if (g_in_gps == TRUE)
		{
			return msg;
		}
		
		res = call ConnMgr.startConnection(body->src_addr, FALSE);
		
		if (res == FAIL)
		{
			if (call ConnMgr.getConnectedAddr() == body->src_addr)
			{
				call ConnMgr.refreshConnection();
			} else {
				//hijack the connection
				call ConnMgr.endConnection();
				call ConnMgr.startConnection(body->src_addr, FALSE);
			}
		}

		node_out->page = body->page;
		node_out->src_addr = body->src_addr;
		
		signal ICollectData.srcFired (node_out);
		return msg;
	}

	
	event void ConnMgr.connectionEnded(uint16_t addr, uint16_t duration, uint8_t quality)
	{
	
	}
	
}
