includes structs;
#include "beacon.h"

module BeaconM
{
	provides
	{
		interface StdControl;
		interface IBeacon;
	}
	uses
	{
		
		interface Timer;
		interface Timer as LockTimer;
		interface SendMsg;
		interface ReceiveMsg;
		interface SendMsg as PreSendMsg;
		interface ConnMgr;
		interface Leds;
		interface Random;
	}
}
implementation
{
#include "fluxconst.h"

	#define MAX_OFFERS 5
	#define PRE_RETRIES	3
	#define LOCK_RETRIES	15
	#define LOCK_WAIT		500
	#define RESPONSE_WINDOW		4500
	
	Beacon_in* node_in;
	Beacon_out* node_out;

	TOS_Msg m_msg, m_presend_msg;
	
	uint16_t offers[MAX_OFFERS];
	uint16_t delays[MAX_OFFERS];
	uint16_t bws[MAX_OFFERS];
	int offercount;
	int retries;
	int lock_retries;
	
	
	
	void signalSuccess()
	{
		call Leds.greenToggle();
		call Timer.stop();
		signal IBeacon.nodeDone(node_in, node_out, ERR_OK);
	}
	
	void signalFailure()
	{
		call Leds.yellowToggle();
		call ConnMgr.unlock();
		call Timer.stop();
		signal IBeacon.nodeDone(node_in, node_out, ERR_USR);
	}

	command result_t StdControl.init ()
	{
//		call Console.init();
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

	task void BeaconStartTask()
	{
		result_t res;
		BeaconMsg_t* body = (BeaconMsg_t*)m_msg.data;
		
		body->src_addr = TOS_LOCAL_ADDRESS;
		if (TOS_LOCAL_ADDRESS == 0)
		{
			body->src_delay = 0;
		} else {	
			body->src_delay = call ConnMgr.getDelayToBase(FALSE);
		}
		body->bw = node_in->bw;
	
		offercount = 0;
		call Leds.redToggle();
		res = call SendMsg.send(TOS_BCAST_ADDR, sizeof(BeaconMsg_t), &m_msg );
		if (res == FAIL)
		{
			
			signalFailure();
		}
	}
	
	task void LockTask()
  	{
  		if (call ConnMgr.lock() == SUCCESS)
		{
			post BeaconStartTask();
		} else {
			/*lock_retries--;
			if (lock_retries <= 0)
			{
				signalFailure();
			} else {
				call LockTimer.start(TIMER_ONE_SHOT, LOCK_WAIT);
			}*/
			
			signalFailure();
		}
  	}
	
	event result_t LockTimer.fired()
	{
		post LockTask();
		return SUCCESS;	
	}
	
	

	command result_t IBeacon.nodeCall (Beacon_in * in, Beacon_out * out)
	{
//PUT NODE IMPLEMENTATION HERE
		
		

		
		node_in = in;
		node_out = out;
		
		if (!g_active)
		{
			return FAIL;
		}
		
		node_out->bw = node_in->bw;
		
		
		lock_retries = LOCK_RETRIES;
		post LockTask();
		return SUCCESS;
		
	}
	
	task void PreDataTask()
	{
		result_t res;
		
		res = call PreSendMsg.send(node_out->dest_addr, 1, &m_presend_msg);
		if (res == FAIL)
		{
			retries--;
			if (retries < 0)
			{
				signalFailure();
			} else {
				post PreDataTask();
			}
		}
	}
	
	
	task void ChooseTask()
	{
		int i;
		uint16_t curdelay, mindelay = 0xFFFF;
		uint16_t mydelay;
		int minidx = -1;
		
		if (TOS_LOCAL_ADDRESS == 0)
		{
			if (offercount > 0)
			{
				//randomly choose an offer
				minidx = ((call Random.rand() >> 8) % offercount);
			} 
		} else {
		
			for (i=0; i < offercount; i++)
			{
				//curdelay = call ConnMgr.getDelayToBaseThroughAddr(offers[i],TRUE);
				curdelay = delays[i];
				if (curdelay < mindelay)
				{
					mindelay = curdelay;
					minidx = i;
				}	
			}
			mydelay = call ConnMgr.getDelayToBase(TRUE);
			
			//only forward if mindelay is at least two days less
			//than mydelay or base station
			if (mindelay > 0 && ((mydelay-4) < mindelay))
			{
				minidx = -1;
			}
		}
		if (minidx == -1)
		{
			//either no choice or they all have higher delay than I do.
			//so don't forward.
			signalFailure();
		} else {
			
			node_out->dest_addr = offers[minidx];
			if (node_in->bw < bws[minidx])
			{
				node_out->bw = node_in->bw;
			} else {
				node_out->bw = bws[minidx];
			}
			/*signal IBeacon.nodeDone(node_in, node_out, ERR_OK);*/
			retries = PRE_RETRIES;
			post PreDataTask();
		}
	}
	
	
	event result_t Timer.fired()
	{
		post ChooseTask();	
		return SUCCESS;
	}

	event result_t SendMsg.sendDone(TOS_MsgPtr msg, result_t success)
	{
		
		call Timer.start(TIMER_ONE_SHOT, RESPONSE_WINDOW); //response window
		return SUCCESS;
	}
	
	event result_t PreSendMsg.sendDone(TOS_MsgPtr msg, result_t success)
	{
		if (msg->ack != 1 || success == FAIL)
		{
			retries--;
			if (retries < 0)
			{
				signalFailure();
			} else {
				post PreDataTask();
			}
			return SUCCESS;
		}	
	
		call ConnMgr.radioHi();
		signalSuccess();
		return SUCCESS;
	}
	
	event TOS_MsgPtr ReceiveMsg.receive (TOS_MsgPtr msg)
	{
		OfferMsg_t *body = (OfferMsg_t *) msg->data;
			
		
		if (offercount < MAX_OFFERS)
		{
			offers[offercount] = body->addr;
			delays[offercount] = body->delay;
			bws[offercount] = body->bw;
			offercount++;
		}
			
		call ConnMgr.beacon(body->addr, body->delay);

		return msg;
	}
	

}
