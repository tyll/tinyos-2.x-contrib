includes structs;

module GetBundleMsgM
{
	provides
	{
		interface StdControl;
		interface IGetBundleMsg;
	}
	uses
	{
		interface BundleIndex as MyIndex;
		interface SendMsg;
		interface SingleStream;
		interface Timer;
		interface Leds;
	}
}
implementation
{
#include "fluxconst.h"
#include "uservariables.h"

#define HDR_CHUNK	0xFF
#define PACKET_DELAY 200

	TOS_Msg g_msg;
	
	BundleIndexAck_t *body;
	
	GetBundleMsg_in **node_in;
	GetBundleMsg_out **node_out;

	bool sending;
	uint16_t bundle_offset;
	bool isvalid;
	
	Bundle_t g_single_stream_bundle;
	stream_t g_the_stream;
	int chunkidx;
	datalen_t chunklength;
	
	
	command result_t StdControl.init ()
	{
		call Leds.init();
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
	
	command bool IGetBundleMsg.ready ()
	{
	//PUT READY IMPLEMENTATION HERE
	
		return TRUE;
	}
	
	/*
	IN:
		int msg_type
		uint8_t seq_num
		uint16_t src_addr
	OUT:
		
	*/
	command result_t IGetBundleMsg.nodeCall (GetBundleMsg_in ** in,
						GetBundleMsg_out ** out)
	{
		result_t res;
		
		
		node_in = in;
		node_out = out;
		
		body = (BundleIndexAck_t*)(g_msg.data);
		
		deadlocked_edge_id = 0xd2;
		body->src_addr = TOS_LOCAL_ADDRESS;
		bundle_offset = (*in)->bundle;
		//call Leds.redToggle();
		
		res = call MyIndex.GetBundleByOffset(bundle_offset, &g_single_stream_bundle, &isvalid);
		if (res != SUCCESS)
		{
			
			if (isvalid)
			{
				body->flags = 0x00; //!success and !end
				body->data[2] = 0xCA;
				body->data[3] = 0x11;
			} else {
				body->flags = 0x01; //!success and end
			}
			body->chunk = HDR_CHUNK;
			body->bundle = bundle_offset;
			call SendMsg.send((*in)->src_addr, sizeof(BundleIndexAck_t), &g_msg );
			deadlocked_edge_id = 0xd3;
			return FAIL;
		}
		
		return SUCCESS;
	}
	
	
	event result_t Timer.fired()
	{
		
		//deadlocked_edge_id = 0xc0;
		if (call SingleStream.next(&g_the_stream, body->data, &chunklength) == FAIL)
		{
			//deadlocked_edge_id = 0xc1;		
			if (chunklength == 1)
			{
				//end of stream
				body->chunk = chunkidx;
				body->flags = 0x03;
				call SendMsg.send((*node_in)->src_addr, DATA_MSG_HDR_LEN, &g_msg );
				signal IGetBundleMsg.nodeDone(node_in, node_out, ERR_OK);
			} else {
				signal IGetBundleMsg.nodeDone (node_in, node_out, ERR_USR);
			}
			return SUCCESS;
		}
		//deadlocked_edge_id = 0xc2;
		return SUCCESS;
	}
	
	
	/*
	typedef struct Bundle 
	{
	stream_t stream;
	uint16_t turtle_num;
	uint16_t bundle_num;
	} Bundle_t;

	*/
	event void MyIndex.GetBundleDone(result_t res, bool valid)
	{
		deadlocked_edge_id = 0xd4;
		// for now we don't worry about it being valid.. we'll find that out when we try to traverse it
		if (res != SUCCESS /*&& valid == TRUE*/) 
		{
			body->flags = 0x00;
			body->data[2] = 0xDE;
			body->data[3] = 0xAD;
		}
		else if (valid == TRUE)
		{
			//memcpy(&g_single_stream_bundle.stream, &g_the_stream, sizeof(stream_t));
			memcpy(&g_the_stream, &g_single_stream_bundle.stream, sizeof(stream_t));
			call SingleStream.start_traversal(&g_the_stream, NULL);
			body->flags = 0x02;
			chunkidx = 0;
			call Timer.start(TIMER_ONE_SHOT, PACKET_DELAY);
			body->chunk = HDR_CHUNK; 
			body->bundle = bundle_offset;
			memcpy(body->data, &(g_single_stream_bundle.turtle_num), 2*sizeof(uint16_t));
			call SendMsg.send((*node_in)->src_addr, sizeof(BundleIndexAck_t), &g_msg );
			//signal IGetBundleMsg.nodeDone(node_in, node_out, ERR_USR);
			deadlocked_edge_id = 0xd6;
			return;
		} 
		else // valid == FALSE
		{
			body->flags = 0x03;
		}
		
		//memcpy(body->data, &g_the_stream, sizeof(stream_t));
		
		// copy over the turtle num and the bundle_num:
		body->chunk = HDR_CHUNK; 
		body->bundle = bundle_offset;
		//memcpy(body->data, &(g_single_stream_bundle.turtle_num), 2*sizeof(uint16_t));
		call SendMsg.send((*node_in)->src_addr, sizeof(BundleIndexAck_t), &g_msg );
		deadlocked_edge_id = 0xd5;
		signal IGetBundleMsg.nodeDone(node_in, node_out, ERR_USR);
		
	}
	
	
	
	event void MyIndex.DeleteBundleDone(result_t res)
	{
		
	}
	event void MyIndex.AppendDone(result_t res)
	{
		
	}
	
	event result_t SendMsg.sendDone( TOS_MsgPtr msg, result_t success )
	{
		
		return SUCCESS;
	}
	
	event void SingleStream.appendDone(stream_t *stream_ptr, result_t res)
	{
	
	}
	
	event void SingleStream.nextDone(stream_t *stream_ptr, result_t res)
	{
		result_t result;
		
		if (stream_ptr != &g_the_stream)
		{
			//not my stream
			return;
		}
		//deadlocked_edge_id = 0xc3;
		body->chunk = chunkidx;
		chunkidx++;
		body->flags |= ((res == SUCCESS) << 1);
		call SendMsg.send((*node_in)->src_addr, DATA_MSG_HDR_LEN + chunklength, &g_msg );
		
		
		result = call Timer.start(TIMER_ONE_SHOT, PACKET_DELAY);
		if (result == FAIL)
		{
			//deadlocked_edge_id = 0xc4;
			signal IGetBundleMsg.nodeDone(node_in, node_out, ERR_USR);
			return;
		}
		//deadlocked_edge_id = 0xc5;
	}

	event void MyIndex.loadDone(result_t res)
	{
	
	}
	
	event void MyIndex.saveDone(result_t res)
	{
	}

}
