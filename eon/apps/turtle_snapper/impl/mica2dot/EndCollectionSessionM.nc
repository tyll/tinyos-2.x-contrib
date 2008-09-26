includes structs;

module EndCollectionSessionM
{
	provides
	{
		interface StdControl;
		interface IEndCollectionSession;
	}
	uses
	{
		interface BundleIndex as MyIndex;
		interface SendMsg;
		interface Leds;	
		command result_t SetListeningMode(uint8_t power);
		command uint8_t GetListeningMode();
	}
}
implementation
{
#include "fluxconst.h"
#include "uservariables.h"
	
	BundleIndexAck_t *body;
	
	EndCollectionSession_in **node_in;
	EndCollectionSession_out **node_out;
	
	bool sending;
	
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
	
	command bool IEndCollectionSession.ready ()
	{
	//PUT READY IMPLEMENTATION HERE
	
		return TRUE;
	}
	
	command result_t IEndCollectionSession.nodeCall (EndCollectionSession_in **
							in,
							EndCollectionSession_out **
							out)
	{
		//result_t res;
		node_in = in;
		node_out = out;
		
		body = (BundleIndexAck_t*)g_m_msg.data;
		
		g_exp_seq_num = -1;
		
		body->success = TRUE;
		body->src_addr = TOS_LOCAL_ADDRESS;
		body->seq_num = ((DeleteBundleMsg_in*)(*in))->seq_num;
		
		sending = TRUE;
		if( call SendMsg.send(((EndCollectionSession_in*)(*in))->src_addr, sizeof(BundleIndexAck_t), &g_m_msg ) == FAIL )
		{
			sending = FALSE;
			signal IEndCollectionSession.nodeDone (in, out, ERR_USR);
			return SUCCESS;
		}
		
		//signal IEndCollectionSession.nodeDone (in, out, ERR_OK);
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
		sending = FALSE;
		
		if (success != SUCCESS)
		{
			signal IEndCollectionSession.nodeDone (node_in, node_out, ERR_USR);
			return SUCCESS;
		}
		
		call SetListeningMode(CC1K_LPL_STATES-1);
		call Leds.redOff();
		
		signal IEndCollectionSession.nodeDone (node_in, node_out, ERR_OK);
		return SUCCESS;
	}
	
	event void MyIndex.loadDone(result_t res)
	{
	
	}
	
	event void MyIndex.saveDone(result_t res)
	{
	}

}
