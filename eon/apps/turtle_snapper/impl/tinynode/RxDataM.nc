includes structs;

module RxDataM
{
  provides
  {
    interface StdControl;
    interface IRxData;
  }
  uses
  {
  	interface ReceiveMsg;
  }
}
implementation
{
#include "fluxconst.h"
RxData_out *node_out;
//uint8_t last_src = 0xFF;
//uint16_t last_num = 0xFFFF;

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

  command result_t IRxData.srcStart (RxData_out * out)
  {
  	node_out = out;
    return SUCCESS;
  }
  
  event TOS_MsgPtr ReceiveMsg.receive (TOS_MsgPtr msg)
	{
		if (g_in_gps == TRUE)
		{
			return msg;
		}	
	
		node_out->src = msg->data[0];
		
		
		node_out->pkt.length = msg->length - 1;
		if (node_out->pkt.length > CHUNK_DATA_LENGTH)
		{
			return msg;
		}
		
		//get the packet src and idx
		memcpy(node_out->pkt.data, msg->data+1, node_out->pkt.length);
		
		
		signal IRxData.srcFired(node_out);
		
		return msg;
	}

}
