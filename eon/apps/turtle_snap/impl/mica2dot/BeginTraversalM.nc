includes structs; 

module BeginTraversalM
{
	provides
	{
		interface StdControl;
		interface IBeginTraversal;
	}
	uses
	{
		interface BundleIndex as MyIndex;
		interface Stream as BundleNumStream;
		interface SendMsg;
		interface Leds;
	}
}
implementation
{
#include "fluxconst.h"
#include "uservariables.h"
	
	bool sending;
	//TOS_Msg g_g_m_msg;
	BundleIndexAck_t *body;

	BeginTraversal_in **node_in;
	BeginTraversal_out **node_out;
	
	uint32_t __bundlenum;
	datalen_t __length;
	bool reading;
	
	command result_t StdControl.init ()
	{
		sending = FALSE;
		reading = FALSE;
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
	
	command bool IBeginTraversal.ready ()
	{
		return TRUE;
	}
	
	command result_t IBeginTraversal.nodeCall (BeginTraversal_in ** in,
							BeginTraversal_out ** out)
	{
		result_t res;
		
		node_in = in;
		node_out = out;
		
		body = (BundleIndexAck_t*)g_m_msg.data;
		body->success = FALSE;
		body->src_addr = TOS_LOCAL_ADDRESS;
		body->seq_num = ((BeginTraversal_in*)(*in))->seq_num;
		
		call BundleNumStream.start_traversal(NULL);
		
		reading = TRUE;
		res = call BundleNumStream.next(&__bundlenum, &__length);
		if (res == FAIL)
		{
			reading = FALSE;
			sending = TRUE;
			if ( call SendMsg.send(((BeginTraversal_in*)(*in))->src_addr, sizeof(BundleIndexAck_t), &g_m_msg ) == FAIL )
			{
				sending = FALSE;
				signal IBeginTraversal.nodeDone (in, out, ERR_USR);
				return SUCCESS;
			}
		}
		/*
		res = call MyIndex.BeginTraversal();
		if (res == SUCCESS)
		{
			body->success = TRUE;
		}
		sending = TRUE;
		if( call SendMsg.send(((BeginTraversal_in*)(*in))->src_addr, sizeof(BundleIndexAck_t), &g_m_msg ) == FAIL )
		{
			sending = FALSE;
			signal IBeginTraversal.nodeDone (in, out, ERR_USR);
			return SUCCESS;
		}
		*/
		//signal IBeginTraversal.nodeDone (in, out, ERR_OK);
		return SUCCESS;
	}
	
	///////////////////////////////////////////////////////////////////////////////////////////////
	// 
	///////////////////////////////////////////////////////////////////////////////////////////////
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
			signal IBeginTraversal.nodeDone (node_in, node_out, ERR_USR);
		}
		sending = FALSE;
		
		signal IBeginTraversal.nodeDone (node_in, node_out, ERR_OK);
		return SUCCESS;
	}
	
	event void BundleNumStream.nextDone(result_t res)
	{
		if (reading == FALSE)
			return;
		
		reading = FALSE;
		
		res = call MyIndex.BeginTraversal();
		if (res == SUCCESS)
		{
			//__bundlenum = 0xff;
			memcpy(&(body->data), &__bundlenum, sizeof(uint32_t));
			body->success = TRUE;
		}
		sending = TRUE;
		if( call SendMsg.send(((BeginTraversal_in*)(*node_in))->src_addr, sizeof(BundleIndexAck_t), &g_m_msg ) == FAIL )
		{
			sending = FALSE;
			signal IBeginTraversal.nodeDone (node_in, node_out, ERR_USR);
			return ;
		}
		
	}
	
	event void BundleNumStream.appendDone(result_t res)
	{
	
	}
	
	event void MyIndex.loadDone(result_t res)
	{
	
	}
	
	event void MyIndex.saveDone(result_t res)
	{
	}

}
