includes structs;

module SendDataM
{
  provides
  {
    interface StdControl;
    interface ISendData;
  }
  uses
  {
  	interface ObjLog;
	interface SendMsg;
	interface ConnMgr;
	interface AckStore;
  }
}
implementation
{
#include "fluxconst.h"

#define DATA_RETRIES 10

SendData_in *node_in;
SendData_out *node_out;

uint16_t beforepage;
TOS_Msg msgbuf;
uint16_t msglength;
uint8_t original[TOSH_DATA_LENGTH];
int retries;
int packet_count;


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
  	node_out->bw = node_in->bw;
  	signal ISendData.nodeDone (node_in, node_out, ERR_OK);
  }
  
  void signalFailure()
  {
  	call ConnMgr.radioLo();
  	call ConnMgr.unlock();
  	signal ISendData.nodeDone (node_in, node_out, ERR_USR);
  }

  task void getNextPacketTask()
  {
  	result_t res;
	bool eol;
	
	if (node_in->bw <= 0)
	{
		signalSuccess();
		return;
	}
	
  	beforepage = call ObjLog.getReadPage(1);
	res = call ObjLog.read(1,&eol);
	if (res == FAIL)
	{
		if (eol)
		{
			//no more packets in log 1
			signalSuccess();
			return;
		}
		retries--;
		if (retries <= 0)
		{
			signalFailure();
		} else {
			post getNextPacketTask();
		}
		return;
	}
  }
  
  task void appendToQ1Task()
  {
  	//put the packet back on the queue
	result_t res;
	
	if (retries <= 0)
	{
		signalFailure();
		return;
	}
	
	res = call ObjLog.append(1,original, msglength);
	if (res == FAIL)
	{
		retries--;
		post appendToQ1Task();
		return;
	}
  }
  
  task void appendToQ2Task()
  {
  	//put the packet back on the queue
	result_t res;
	
	if (retries <= 0)
	{
		signalFailure();
	}
	
	res = call ObjLog.append(2,original, msglength);
	if (res == FAIL)
	{
		retries--;
		post appendToQ2Task();
		return;
	}
  }
  
  task void SendTask()
  {
  	result_t res;
  
	
	res = call SendMsg.send(node_in->dest_addr, msglength+1, &msgbuf );
	if (res == FAIL)
	{
		retries--;
		if (retries <= 0)
		{
			//signalFailure();
			retries = DATA_RETRIES;
			post appendToQ1Task();
		} else {
			//try again
			post SendTask();
		}	
	} //if
  }
  
  task void checkAcksTask()
  {
  	uint8_t src_addr;
  	uint16_t src_id;

	
	
	
	//get packet src and id
 	src_addr = original[0];
	memcpy(&src_id, original+2, 2);
	//memcpy(&vec, node_out->pkt.data+4, 2);
	
	if (call AckStore.check_packet(src_addr,src_id) == TRUE)
	{
		//this packet has been acked.
		//drop it
		post getNextPacketTask();
		return;
	}
	post SendTask();
  }
  
  command result_t ISendData.nodeCall (SendData_in * in, SendData_out * out)
  {
//PUT NODE IMPLEMENTATION HERE
		node_in = in;
		node_out = out;
		retries = DATA_RETRIES;
		
		node_out->bw = node_in->bw;
		node_out->dest_addr = node_in->dest_addr;
		
		post getNextPacketTask();
//Done signal can be moved if node makes split phase calls.
    //signal ISendData.nodeDone (in, out, ERR_OK);
    return SUCCESS;
  }
  
  event result_t ObjLog.readDone(int logid, uint8_t *buffer, uint16_t numbytes, result_t success)
  {
	uint16_t afterpage;
  	
  	if (success == FAIL )
	{
		retries--;
		if (retries <= 0)
		{
			signalFailure();
		} else {
			post getNextPacketTask();
		}
		return SUCCESS;
	}
	
	retries = DATA_RETRIES;

	//copy the data into the message buffer
	msgbuf.data[0] = TOS_LOCAL_ADDRESS;
  	memcpy(msgbuf.data+1, buffer, numbytes);
	memcpy(original, buffer, numbytes);
	msglength = numbytes; 
	afterpage = call ObjLog.getReadPage(1);
	
	if (afterpage != beforepage)
	{
		call ObjLog.deletePage(1);
	}
	
	post checkAcksTask();
	
  	return SUCCESS;
  }
  
  event result_t ObjLog.appendDone(int logid, result_t success)
  {
  	if (success == FAIL)
	{
		
  		if (logid == 1)
		{
			post appendToQ1Task();
		} else {
			post appendToQ2Task();
		}
	}
	if (logid == 1)
	{
		signalFailure();
	} else {
		post getNextPacketTask();
	}
	
	return SUCCESS;
  }
  
  event result_t SendMsg.sendDone(TOS_MsgPtr msg, result_t success)
	{
		if (success == FAIL || msg->ack == FALSE)
		{
			retries--;
			if (retries <= 0)
			{
				retries = DATA_RETRIES;
				post appendToQ1Task();
			} else {
				//try again
				post SendTask();
			}
			return SUCCESS;
		} else {
			node_in->bw--;
			call ConnMgr.sentPacket(node_out->dest_addr);
			retries = DATA_RETRIES;
		}
		
		
		if (node_in->dest_addr == 0)
		{
			//sent to the base station.  No need to archive it.
			post getNextPacketTask();	
		} else {
			//get the next packet;
			post appendToQ2Task();
		}
		return SUCCESS;
	}
}
