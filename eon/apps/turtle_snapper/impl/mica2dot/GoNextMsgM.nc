includes structs;

module GoNextMsgM
{
	provides
	{
		interface StdControl;
		interface IGoNextMsg;
	}	
	uses
	{
		interface BundleIndex as MyIndex;
		interface SendMsg;
		interface SingleStream;
	}
}
implementation
{
#include "fluxconst.h"
#include "uservariables.h"

	bool sending;
	//TOS_Msg g_m_msg;
	BundleIndexAck_t *body;

	GoNextMsg_in **node_in;
	GoNextMsg_out **node_out;

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
	
	command bool IGoNextMsg.ready ()
	{
	//PUT READY IMPLEMENTATION HERE
	
		return TRUE;
	}
	
	command result_t IGoNextMsg.nodeCall (GoNextMsg_in ** in,
						GoNextMsg_out ** out)
	{
	//PUT NODE IMPLEMENTATION HERE
		result_t res;
		
		node_in = in;
		node_out = out;
		
		body = (BundleIndexAck_t*)g_m_msg.data;
		
		body->success = FALSE;
		body->src_addr = TOS_LOCAL_ADDRESS;
		body->seq_num = ((GoNextMsg_in*)(*in))->seq_num;
		
		res = call MyIndex.GoNext();
		if (res == SUCCESS)
		{
			body->success = TRUE;
		}
		sending = TRUE;
		if( call SendMsg.send(((GoNextMsg_in*)(*in))->src_addr, sizeof(BundleIndexAck_t), &g_m_msg ) == FAIL )
		{
			sending = FALSE;
			signal IGoNextMsg.nodeDone (in, out, ERR_USR);
			return SUCCESS;
		}
		
		//Done signal can be moved if node makes split phase calls.
		//signal IGoNextMsg.nodeDone (in, out, ERR_OK);
		return SUCCESS;
	}
	
	event void MyIndex.GetBundleDone(result_t res, bool valid)
	{
		
	}
	event void MyIndex.DeleteBundleDone(result_t res)
	{
		
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
			signal IGoNextMsg.nodeDone (node_in, node_out, ERR_USR);
		}
		
		sending = FALSE;
		signal IGoNextMsg.nodeDone (node_in, node_out, ERR_OK);
		return SUCCESS;
	}
	
	event void SingleStream.appendDone(stream_t *stream_ptr, result_t res)
	{
	
	}
	
	event void SingleStream.nextDone(stream_t *stream_ptr, result_t res)
	{
		
	}
	
	event void MyIndex.loadDone(result_t res)
	{
	
	}
	event void MyIndex.saveDone(result_t res)
	{
	}

}
