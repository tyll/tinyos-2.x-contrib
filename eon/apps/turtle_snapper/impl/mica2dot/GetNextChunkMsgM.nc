includes structs;

module GetNextChunkMsgM
{
	provides
	{
		interface StdControl;
		interface IGetNextChunkMsg;
	}
	uses
	{
		interface BundleIndex as MyIndex;
		interface SendMsg;
		interface SingleStream;
		interface Leds;
	}
  
}
implementation
{
#include "fluxconst.h"
#include "uservariables.h"

#define HEADER_OFFSET	4
//#define CALL_SIDE		0x11CA
//#define RETURN_SIDE		0xDEAD


char msg_data[TOSH_DATA_LENGTH];

	//TOS_Msg g_m_msg;
	bool sending;
	BundleIndexAck_t *body;

	GetNextChunkMsg_in **node_in;
	GetNextChunkMsg_out **node_out;

	datalen_t Slen;

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

	command bool IGetNextChunkMsg.ready ()
	{
//PUT READY IMPLEMENTATION HERE

		return TRUE;
	}

	command result_t IGetNextChunkMsg.nodeCall (GetNextChunkMsg_in ** in,
			GetNextChunkMsg_out ** out)
	{
		result_t res;
		
		Slen = 0xB4;
		
		node_in = in;
		node_out = out;
		
		body = (BundleIndexAck_t*)g_m_msg.data;
		
		body->success = FALSE;
		body->src_addr = TOS_LOCAL_ADDRESS;
		body->seq_num = ( (GoNextMsg_in*)(*in) )->seq_num;

		memset( body->data, 0, BUNDLE_ACK_DATA_LENGTH );
		memset (msg_data, 0, TOSH_DATA_LENGTH);
		
		/*
		memcpy(body->data, &g_the_stream, sizeof(stream_t));
		sending = TRUE;
		if( call SendMsg.send(((GoNextMsg_in*)(*node_in))->src_addr, sizeof(BundleIndexAck_t), &g_m_msg ) == FAIL )
		{
			sending = FALSE;
			signal IGetNextChunkMsg.nodeDone(node_in, node_out, ERR_USR);
		}
		*/
		
		
		//res = call SingleStream.next( &g_the_stream, body->data, &Slen );
		res = call SingleStream.next( &g_the_stream, msg_data, &Slen );
		if ( res == FAIL )
		{
			if (Slen == 1)
			{
				//no value
				// It means that we are at the end of the stream!
				// We return failiure because the client should know this
				// It should know this by traversing the 
				//streamlength = 0;
				body->success = 2; //HACK a good kind of failure
				sending = TRUE;
				if( call SendMsg.send(((GoNextMsg_in*)(*node_in))->src_addr, sizeof(BundleIndexAck_t), &g_m_msg ) == FAIL )
				{
					sending = FALSE;
					signal IGetNextChunkMsg.nodeDone(node_in, node_out, ERR_OK);
					return SUCCESS;
				}
			} 
			else 
			{
				body->success = FALSE;
				sending = TRUE;
				g_m_msg.data[12] = 0xCA;
				g_m_msg.data[13] = 0x11;
				if( call SendMsg.send(((GoNextMsg_in*)(*node_in))->src_addr, sizeof(BundleIndexAck_t), &g_m_msg ) == FAIL )
				{
					sending = FALSE;
					signal IGetNextChunkMsg.nodeDone(node_in, node_out, ERR_USR);
					return SUCCESS;
				}
			}
		}
		
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
		if(sending == FALSE)
			return SUCCESS;
		sending = FALSE;
		
		if (success != SUCCESS)
		{
			body->success = FALSE;
			signal IGetNextChunkMsg.nodeDone(node_in, node_out, ERR_USR);	
			return SUCCESS;
		}
		
		// As far as we can tell everything ended OK
		signal IGetNextChunkMsg.nodeDone(node_in, node_out, ERR_OK);
		return SUCCESS;
	}
  
	event void SingleStream.appendDone(stream_t *stream_ptr, result_t res)
	{
	
	}
	
	event void SingleStream.nextDone(stream_t *stream_ptr, result_t res)
	{
		if (res == SUCCESS)
		{
			//memcpy(body->data, msg_data, BUNDLE_ACK_DATA_LENGTH);
			memcpy(body->data, msg_data, Slen);
			
			//memcpy(body->data, stream_ptr, sizeof(stream_t));
			//body->seq_num = Slen;
			//body->src_addr = Slen;
			//memcpy(body->data, msg_data, Slen);
			body->success = TRUE;
			
			sending = TRUE;
			if( call SendMsg.send(((GoNextMsg_in*)(*node_in))->src_addr, Slen + (HEADER_OFFSET*sizeof(char)), &g_m_msg ) == FAIL )
			{
				sending = FALSE;
				signal IGetNextChunkMsg.nodeDone(node_in, node_out, ERR_USR);
			}
			return;	
		}
		else
		{
			g_m_msg.data[12] = 0xDE;
			g_m_msg.data[13] = 0xAD;
		}
		// now reply:
		sending = TRUE;
		if( call SendMsg.send(((GoNextMsg_in*)(*node_in))->src_addr, sizeof(BundleIndexAck_t), &g_m_msg ) == FAIL )
		{
			sending = FALSE;
			signal IGetNextChunkMsg.nodeDone(node_in, node_out, ERR_USR);
		}
	}
	
	event void MyIndex.loadDone(result_t res)
	{
	
	}
	
	event void MyIndex.saveDone(result_t res)
	{
	}

}
