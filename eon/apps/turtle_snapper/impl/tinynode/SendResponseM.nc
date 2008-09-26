includes structs;

module SendResponseM
{
  provides
  {
    interface StdControl;
    interface ISendResponse;
  }
  uses
  {
  	interface ConnMgr;
	interface SendMsg;
	interface Timer;
	interface Leds;
  }
}
implementation
{
#include "fluxconst.h"

#define RESPOND_RETRIES 3

SendResponse_in *node_in;
SendResponse_out *node_out;

int retries;
TOS_Msg msgbuf;


  command result_t StdControl.init ()
  {
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
  
  void signalSuccess()
  {
  	
  	signal ISendResponse.nodeDone (node_in, node_out, ERR_OK);
  }
  
  void signalFailure()
  {
  	
  	call ConnMgr.unlock();
  	signal ISendResponse.nodeDone (node_in, node_out, ERR_USR);
  }

  task void SendTask()
  {
  	result_t res;
  
	
	res = call SendMsg.send(node_in->addr, sizeof(OfferMsg_t), &msgbuf );
	if (res == FAIL)
	{
		retries--;
		if (retries <= 0)
		{
			//signalFailure();
			//due to contention the acks might get clobbered
			//so, we'll try to listen anyway.
			signalSuccess();
		} else {
			//try again
			post SendTask();
		}	
	} //if
  }

  command result_t ISendResponse.nodeCall (SendResponse_in * in,
					   SendResponse_out * out)
  {
	OfferMsg_t *offer;
	node_in = in;
	node_out = out;
	retries = RESPOND_RETRIES;
	
	offer = (OfferMsg_t*)msgbuf.data;
  
	out->addr= in->addr;
	out->delay = in->delay;
	out->bw = in->bw;
	
	//try to get the lock
	if (call ConnMgr.lock() == FAIL)
	{
		
		return FAIL;
	}
		
	offer->addr = TOS_LOCAL_ADDRESS;
	offer->delay = call ConnMgr.getDelayToBase(FALSE);
	offer->bw = node_in->bw;	
	
	post SendTask();
//Done signal can be moved if node makes split phase calls.
    //signal ISendResponse.nodeDone (in, out, ERR_OK);
    return SUCCESS;
  }
  
  event result_t Timer.fired()
  {
	post SendTask();
	return SUCCESS;
  }
  
  event result_t SendMsg.sendDone(TOS_MsgPtr msg, result_t success)
	{
		
		if (success == FAIL || msg->ack != 1)
		{
			retries--;
			if (retries <= 0)
			{
				
				//signalFailure();
				//due to contention the acks might get clobbered
				//so, we'll try to listen anyway.
				signalSuccess();
			} else {
				//try again
				post SendTask();
			}
			return SUCCESS;
		}
		 
		signalSuccess();
		return SUCCESS;
	}
}
