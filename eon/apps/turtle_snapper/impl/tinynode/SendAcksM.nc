includes structs;

module SendAcksM
{
  provides
  {
    interface StdControl;
    interface ISendAcks;
  }
  uses
  {
  	interface AckStore;
	interface SendMsg;
	interface ConnMgr;
	interface Leds;
  }
}
implementation
{
#include "fluxconst.h"

#define ACK_RETRIES 5

SendAcks_in *node_in;
SendAcks_out *node_out;

uint8_t retries;
int ack_count;
TOS_Msg msg_buf;
uint16_t m_addr;
uint16_t m_minid;
uint16_t m_maxid;

  command result_t StdControl.init ()
  {
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
  	signal ISendAcks.nodeDone (node_in, node_out, ERR_OK);
  }
  
  void signalFailure()
  {
  	call ConnMgr.radioLo();
  	call ConnMgr.unlock();
  	signal ISendAcks.nodeDone (node_in, node_out, ERR_USR);
  }
  
  task void SendTask()
  {
  	result_t res;
  
	AckMsg_t *msgptr = (AckMsg_t*)msg_buf.data;
	//assemble the packet
	msgptr->idx = ack_count-1;
	msgptr->src = TOS_LOCAL_ADDRESS;
	msgptr->addr = m_addr;
	msgptr->min_id = m_minid;
	msgptr->max_id = m_maxid;
	
	//send it
	res = call SendMsg.send(node_in->dest_addr, sizeof(AckMsg_t), &msg_buf );
	if (res == FAIL)
	{
		retries--;
		if (retries <= 0)
		{
			signalFailure();
		} else {
			//try again
			post SendTask();
		}	
	} //if
  }
  
	bool getNextAck()
	{
		bool valid = FALSE;
		bool ret = FALSE;
		while (ret == FALSE || valid == FALSE)
		{
			ret = call AckStore.get_numbered_ack(ack_count, &valid, &m_addr, &m_minid, &m_maxid);
			if (ret == FALSE)
			{
				call Leds.redToggle();
				return FALSE;	
			}
			ack_count++;
			
		}
		call Leds.greenOn();
		return TRUE;
	}
  
  command result_t ISendAcks.nodeCall (SendAcks_in * in, SendAcks_out * out)
  {
//PUT NODE IMPLEMENTATION HERE
		node_in = in;
		node_out = out;
		retries = ACK_RETRIES;
		ack_count = 0;
		
		//copy values over for SendData
		out->bw = in->bw;
		out->dest_addr = in->dest_addr;

		//get the first ack;
		//but don't send acks to the base station.  
		if (in->dest_addr == 0 || getNextAck() == FALSE)
		{
			//no acks yet
			signalSuccess();
			return SUCCESS;
		}
		post SendTask();
//Done signal can be moved if node makes split phase calls.
    //signal ISendAcks.nodeDone (in, out, ERR_OK);
    return SUCCESS;
  }
  
	event result_t SendMsg.sendDone(TOS_MsgPtr msg, result_t success)
	{
		if (success == FAIL || msg->ack == FALSE)
		{
			retries--;
			if (retries <= 0)
			{
				signalFailure();
			} else {
				//try again
				post SendTask();
			}
			return SUCCESS;
		} else {
			retries = ACK_RETRIES;
		}
		
		//get the next ack;
		if (getNextAck() == FALSE)
		{
			//no more acks
			signalSuccess();
		} else {
			post SendTask();
		}
		return SUCCESS;
	}
}
