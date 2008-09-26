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
		//interface ReceiveMsg as ReceiveBeginTraversalMsg;	
		//interface ReceiveMsg as ReceiveGoNextMsg;	
		//interface ReceiveMsg as ReceiveGetNextChunkMsg;
		//interface ReceiveMsg as ReceiveEndCollectionSessionMsg;
		
		interface ReceiveMsg as ReceiveGetBundleMsg;
		//interface ReceiveMsg as ReceiveDeleteBundleMsg;
		interface ReceiveMsg as ReceiveDeleteAllBundlesMsg;
		
		
		interface ReceiveMsg as ReceiveRadioHiPowerMsg;
		interface ReceiveMsg as ReceiveRadioLoPowerMsg;
		
		interface SendMsg;
		
		interface Leds;
		interface Timer;
		
		command result_t SetListeningMode(uint8_t power);
		command uint8_t GetListeningMode();
	}
}
implementation
{
#include "fluxconst.h"

	
	CollectData_out **node_out;
	
	command result_t StdControl.init ()
	{
		call Leds.init();
		return SUCCESS;
	}
	
	command result_t StdControl.start ()
	{
		
		call Timer.start(TIMER_REPEAT, 30L*1024L);//1min
		/*if (call Timer.start(TIMER_REPEAT, 10L*1024L) == SUCCESS)
		{
			call Leds.redOn();
		}*/
		return SUCCESS;
	}
	
	command result_t StdControl.stop ()
	{
		return SUCCESS;
	} 
	
	task void ShutoffTask()
	{
		call Leds.redOff();
	}
	
	task void DelayTask()
	{
		post ShutoffTask();
	}
	
	event result_t Timer.fired()
	{
		//uint8_t l_mode =  call GetListeningMode();
		
		//if (l_mode != 0)
		//{
			call Leds.redOn();
			post DelayTask();
		//}
		return SUCCESS;
	}
	
	command result_t ICollectData.srcStart (CollectData_out ** out)
	{
		node_out = out;
		return SUCCESS;
	}
	
	/*
	OUT:
		int msg_type
		uint8_t seq_num
		uint16_t src_addr
	*/
	// NOTE: 
	/*event TOS_MsgPtr ReceiveBeginTraversalMsg.receive (TOS_MsgPtr msg)
	{
		BeginTraversalMsg_t *body = (BeginTraversalMsg_t *) msg->data;
		uint8_t l_mode =  call GetListeningMode();
		if (l_mode != 0)
			call SetListeningMode(0); // ZERO is the highest state
		
		(*node_out)->msg_type = AM_BEGIN_TRAVERSAL_MSG;
		(*node_out)->seq_num = body->seq_num;
		(*node_out)->src_addr = body->src_addr;
		
		// Set it to FALSE for now...
		//(*node_out)->success = FALSE;
		
		signal ICollectData.srcFired (node_out);
		return msg;
	}*/
	
	/*
	OUT:
	int msg_type
	uint8_t seq_num
	bool success
		*/
	// NOTE: 
	/*event TOS_MsgPtr ReceiveGoNextMsg.receive (TOS_MsgPtr msg)
	{
		GoNextMsg_t *body = (GoNextMsg_t *) msg->data;
		
		(*node_out)->seq_num = body->seq_num;
		(*node_out)->msg_type = AM_GO_NEXT_MSG;
		
		// Set it to FALSE for now...
		(*node_out)->src_addr = body->src_addr;
		signal ICollectData.srcFired (node_out);
		return msg;
	}*/

	/*
	OUT:
	int msg_type
	uint8_t seq_num
	bool success
	*/
	// NOTE: 
	/*event TOS_MsgPtr ReceiveGetNextChunkMsg.receive (TOS_MsgPtr msg)
	{
		GetNextChunk_t *body = (GetNextChunk_t *) msg->data;
		
		(*node_out)->seq_num = body->seq_num;
		(*node_out)->msg_type = AM_GET_NEXT_CHUNK;
		
		// Set it to FALSE for now...
		(*node_out)->src_addr = body->src_addr;
		signal ICollectData.srcFired (node_out);
		return msg;
	}*/
	
	/*
	OUT:
	int action 
	uint16_t bundle
	uint16_t src_addr
		*/
	// NOTE: 
	event TOS_MsgPtr ReceiveGetBundleMsg.receive (TOS_MsgPtr msg)
	{
		GetBundleMsg_t *body = (GetBundleMsg_t *) msg->data;
		
		(*node_out)->action = AM_GET_BUNDLE_MSG;
		(*node_out)->bundle = body->bundle;
		(*node_out)->src_addr = body->src_addr;
		
		//call Leds.redToggle();
		deadlocked_edge_id = 0xd1;
		signal ICollectData.srcFired (node_out);
		return msg;
	}

		/*
	OUT:
	int action 
	uint16_t bundle
	uint16_t src_addr
		*/
	// NOTE: 
	/*event TOS_MsgPtr ReceiveDeleteBundleMsg.receive (TOS_MsgPtr msg)
	{
		DeleteBundleMsg_t *body = (DeleteBundleMsg_t *) msg->data;
		
		(*node_out)->action = AM_DELETE_BUNDLE_MSG;
		(*node_out)->bundle = body->bundle;
		(*node_out)->src_addr = body->src_addr;
		
		signal ICollectData.srcFired (node_out);
		return msg;
	}*/
	
	
	event TOS_MsgPtr ReceiveDeleteAllBundlesMsg.receive (TOS_MsgPtr msg)
	{
		DeleteAllBundlesMsg_t *body = (DeleteAllBundlesMsg_t *) msg->data;
		
		(*node_out)->action = AM_DELETE_ALL_BUNDLES_MSG;
		(*node_out)->src_addr = body->src_addr;
		
		signal ICollectData.srcFired (node_out);
		return msg;
	}

	/*
	OUT:
	int msg_type
	uint8_t seq_num
	uint16_t src_addr
	*/
	// NOTE: 
	/*event TOS_MsgPtr ReceiveEndCollectionSessionMsg.receive (TOS_MsgPtr msg)
	{
		GetBundleMsg_t *body = (GetBundleMsg_t *) msg->data;
		
		(*node_out)->seq_num = body->seq_num;
		(*node_out)->msg_type = AM_END_DATA_COLLECTION_SESSION;
		
		// Set it to FALSE for now...
		//(*node_out)->success = FALSE;
		(*node_out)->src_addr = body->src_addr;
		signal ICollectData.srcFired (node_out);
		return msg;
	}*/
	
	#include "runtime/nodequeue.h"
	
	event TOS_MsgPtr ReceiveRadioHiPowerMsg.receive (TOS_MsgPtr msg)
	{
		int16_t heapsize;
		uint8_t l_mode =  call GetListeningMode();
		EdgeQueue* q = queue_ptr;
		
		memset (&g_deadlock_msg, 0, sizeof(TOS_Msg));
		memcpy(g_deadlock_msg.data, __node_locks, sizeof (__node_locks));
		memcpy(g_deadlock_msg.data+sizeof(__node_locks),g_lastmem, sizeof (uint16_t));
		memcpy(g_deadlock_msg.data+sizeof(__node_locks) + sizeof(alloc_size),&deadlocked_edge_id, sizeof (uint16_t));
		
		/*if (queue_ptr != NULL)
		{
			memcpy(g_deadlock_msg.data, queue_ptr, sizeof(EdgeQueue));
			
		}*/
		
		call SendMsg.send( TOS_BCAST_ADDR, 10*sizeof(char), &g_deadlock_msg );
		//call SendMsg.send( TOS_BCAST_ADDR, sizeof(EdgeQueue), &g_deadlock_msg );
		if (l_mode != 0)
		{
			call SetListeningMode(0); // ZERO is the highest state
			call Leds.redOn();
		}
		
		return msg;
	}
	
	event TOS_MsgPtr ReceiveRadioLoPowerMsg.receive (TOS_MsgPtr msg)
	{
		
		call SetListeningMode(CC1K_LPL_STATES-1);
		call Leds.redOff();
		return msg;
	}

	event result_t SendMsg.sendDone(TOS_MsgPtr msg, result_t success)
	{
		return SUCCESS;
	}
	
	
}
