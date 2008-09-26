includes structs;

module DeleteBundleMsgM
{
	provides
	{
		interface StdControl;
		interface IDeleteBundleMsg;
	}
	uses
	{
		interface BundleIndex as MyIndex;
		interface SendMsg;
	}
}
implementation
{
#include "fluxconst.h"
#include "uservariables.h"

	bool sending;
	BundleIndexAck_t *body;

	DeleteBundleMsg_in **node_in;
	DeleteBundleMsg_out **node_out;

	
	command result_t StdControl.init ()
	{
		sending = FALSE;
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
	
	command bool IDeleteBundleMsg.ready ()
	{
	//PUT READY IMPLEMENTATION HERE
	
		return TRUE;
	}
	
	/*
	IN:
		int msg_type
		uint8_t seq_num
		bool success
	*/
	command result_t IDeleteBundleMsg.nodeCall (DeleteBundleMsg_in ** in,
							DeleteBundleMsg_out ** out)
	{
	//PUT NODE IMPLEMENTATION HERE
		result_t res;
		
		node_in = in;
		node_out = out;
		
		body = (BundleIndexAck_t*)g_m_msg.data;
		
		// set success to false by default
		body->success = FALSE;
		body->src_addr = TOS_LOCAL_ADDRESS;
		body->seq_num = ((DeleteBundleMsg_in*)(*in))->seq_num;
		
		//signal IDeleteBundleMsg.nodeDone (in, out, ERR_OK);
		res = call MyIndex.DeleteBundle();
		if (res != SUCCESS)
		{
			sending = TRUE;
			if( call SendMsg.send(((DeleteBundleMsg_in*)(*in))->src_addr, sizeof(BundleIndexAck_t), &g_m_msg ) == FAIL )
			{
				sending  = FALSE;
				signal IDeleteBundleMsg.nodeDone (in, out, ERR_USR);
				return SUCCESS;
			}
		}
		return SUCCESS;
	}
	
	
	event void MyIndex.GetBundleDone(result_t res, bool valid)
	{
	
	}
	event void MyIndex.DeleteBundleDone(result_t res)
	{
		if (res != SUCCESS)
		{
			sending = TRUE;
			if( call SendMsg.send(((DeleteBundleMsg_in*)(*node_in))->src_addr, sizeof(BundleIndexAck_t), &g_m_msg ) == FAIL )
			{
				sending = FALSE;
				signal IDeleteBundleMsg.nodeDone (node_in, node_out, ERR_USR);
				return;
			}
		}
		
		body->success = TRUE;
		sending = TRUE;
		if( call SendMsg.send(((DeleteBundleMsg_in*)(*node_in))->src_addr, sizeof(BundleIndexAck_t), &g_m_msg ) == FAIL )
		{
			sending = FALSE;
			signal IDeleteBundleMsg.nodeDone (node_in, node_out, ERR_USR);
			return;
		}
		
	}
	event void MyIndex.AppendDone(result_t res)
	{
	
	}

	event result_t SendMsg.sendDone( TOS_MsgPtr msg, result_t success )
	{
		if (sending == FALSE)
			return SUCCESS;
		
		if (success != SUCCESS)
		{
			signal IDeleteBundleMsg.nodeDone (node_in, node_out, ERR_USR);
		}
		sending = FALSE;
		signal IDeleteBundleMsg.nodeDone (node_in, node_out, ERR_OK);
		return SUCCESS;
	}
	
	event void MyIndex.loadDone(result_t res)
	{
	
	}
	event void MyIndex.saveDone(result_t res)
	{
	}
}
