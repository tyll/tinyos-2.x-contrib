includes structs;

module ReadRequestM
{
	provides
	{
		interface StdControl;
		interface IReadRequest;
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
#include "uservariables.h"

	BundleIndexAck_t *body;

	ReadRequest_in **node_in;
	ReadRequest_out **node_out;

	bool sending;
	
	command result_t StdControl.init ()
	{
		sending = FALSE;
		g_exp_seq_num = 0xFF;
		call Leds.init();
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
		
	
	command bool IReadRequest.ready ()
	{
		//PUT READY IMPLEMENTATION HERE
		
		return TRUE;
	}
	
	/*
	IN:
	int msg_type, uint8_t seq_num, uint16_t src_addr
	OUT:
	int msg_type, uint8_t seq_num, uint16_t src_addr
	*/
	command result_t IReadRequest.nodeCall (ReadRequest_in ** in,
											ReadRequest_out ** out)
	{
	//PUT NODE IMPLEMENTATION HERE
	
	//Done signal can be moved if node makes split phase calls.
		
		//call Leds.redToggle();
		
		body = (BundleIndexAck_t*)g_m_msg.data;
		node_in = in;
		node_out = out;
		
		((ReadRequest_in*)(*node_out))->msg_type = ((ReadRequest_in*)(*node_in))->msg_type;
		((ReadRequest_in*)(*node_out))->seq_num = ((ReadRequest_in*)(*node_in))->seq_num;
		((ReadRequest_in*)(*node_out))->src_addr = ((ReadRequest_in*)(*node_in))->src_addr;
		
		if ( ((ReadRequest_in*)(*node_out))->msg_type == AM_END_DATA_COLLECTION_SESSION)
		{
			if ( g_exp_seq_num == 0xFF ) // We are getting the AM_END_DATA_COLLECTION_SESSION for a second time...
			{
				sending = TRUE;
				if( call SendMsg.send( ((ReadRequest_in*)(*node_in))->src_addr, sizeof(BundleIndexAck_t), &g_m_msg ) == FAIL )
				{
					sending = FALSE;
					signal IReadRequest.nodeDone (in, out, ERR_USR);
				}
				return SUCCESS;
			}
		}
		
		if (g_exp_seq_num == ((ReadRequest_out*)(*out))->seq_num)
		{
			((ReadRequest_out*)(*node_out))->msg_type = 0xFF;
			sending = TRUE;
			if( call SendMsg.send( ((ReadRequest_in*)(*node_in))->src_addr, sizeof(BundleIndexAck_t), &g_m_msg ) == FAIL )
			{
				sending = FALSE;
				signal IReadRequest.nodeDone (in, out, ERR_USR);
			}
		}
		else
		{
			g_exp_seq_num = ((ReadRequest_in*)(*in))->seq_num;
			signal IReadRequest.nodeDone (in, out, ERR_OK);
		}
		return SUCCESS;
	}
	
	event result_t SendMsg.sendDone( TOS_MsgPtr msg, result_t success )
	{
		if (sending == FALSE)
			return SUCCESS;
		sending = FALSE;
		
		if (success != SUCCESS)
		{
			signal IReadRequest.nodeDone (node_in, node_out, ERR_USR);
			return SUCCESS;
		}
		
		
		signal IReadRequest.nodeDone (node_in, node_out, ERR_OK);
		return SUCCESS;
	}
}
