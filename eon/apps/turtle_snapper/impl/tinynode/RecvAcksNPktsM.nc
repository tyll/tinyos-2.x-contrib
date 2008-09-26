includes structs;


module RecvAcksNPktsM
{
  provides
  {
    interface StdControl;
    interface IRecvAcksNPkts;
  }
  uses
  {
  	interface ReceiveMsg as PreReceive;
  	interface ReceiveMsg as AckReceive;
	interface ReceiveMsg as DataReceive;
	interface ReceiveMsg as ArchiveReceive;
	interface ObjLog;
	interface AckStore;
	interface ConnMgr;
	interface Timer;
	interface Leds;
  }
}
implementation
{
//#include "fluxconst.h"

#define NUM_BUFS	3
#define CONN_TIMEOUT_FIRST	6000
#define CONN_TIMEOUT	2000
#define MAX_RETRIES		3

RecvAcksNPkts_in *node_in;
RecvAcksNPkts_out *node_out;

bool inNode;
TOS_Msg bufs[NUM_BUFS];
TOS_Msg m_last;
bool valid[NUM_BUFS];
int curbuf;
int retries;
bool writing;



  command result_t StdControl.init ()
  {
  	int i;
  	inNode= FALSE;
	writing = FALSE;
	for (i=0; i < NUM_BUFS; i++)
	{
		valid[i] = FALSE;
	}
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

  void cleanup()
  {
  	call Timer.stop();
  	call ConnMgr.radioLo();
  	call ConnMgr.unlock();
	inNode = FALSE;
  }

  void signalSuccess()
  {
  	cleanup();
	call ObjLog.tryCommit();
  	signal IRecvAcksNPkts.nodeDone (node_in, node_out, ERR_OK);
	
  }
  
  void signalFailure()
  {
  	cleanup();
	call ObjLog.tryCommit();
  	signal IRecvAcksNPkts.nodeDone (node_in, node_out, ERR_USR);
	
  }
  
  result_t refreshTimer(bool first)
  {

  
  	if (!inNode)
	{
		return FAIL;
	}
	if (first)
	{
  		return call Timer.start(TIMER_ONE_SHOT, CONN_TIMEOUT_FIRST);
	} else {
		return call Timer.start(TIMER_ONE_SHOT, CONN_TIMEOUT);
	}
  }
  
  task void appendTask()
  {
  	result_t res;
  	res = call ObjLog.append(1, bufs[curbuf].data, bufs[curbuf].length);
	if (res == FAIL)
	{
		retries--;
		if (retries <= 0)
		{
			signalFailure();
		}
	}
  }
  
  task void chooseTask()
  {
  	int i,idx;
	static int last=0;
	
	
	
	if (writing)
	{
		//only one at a time
		return;
	}

	writing = TRUE;
		
	if (node_in->bw <= 0)
	{
		signalSuccess();
	}
  	
	
	for (i=0; i < NUM_BUFS; i++)
	{
		idx = (last + i) % NUM_BUFS;
		if (valid[idx] == TRUE)
		{
			curbuf = idx;
			retries = MAX_RETRIES;
			post appendTask();
			last = idx;
			return;
		}
	}
	
	
	
	//post chooseTask();
	writing = FALSE;
  }
  
  command result_t IRecvAcksNPkts.nodeCall (RecvAcksNPkts_in * in,
					    RecvAcksNPkts_out * out)
  {
//PUT NODE IMPLEMENTATION HERE
	
	node_in = in;
	node_out = out;
	inNode = TRUE;
	
	writing = FALSE;
	
	
	
	refreshTimer(TRUE);
	
	
//Done signal can be moved if node makes split phase calls.
    //signal IRecvAcksNPkts.nodeDone (in, out, ERR_OK);
    return SUCCESS;
  }
  
  event TOS_MsgPtr AckReceive.receive (TOS_MsgPtr msg)
	{
		AckMsg_t *body = (AckMsg_t *) msg->data;
				
		call AckStore.report_ack(body->addr, body->min_id, body->max_id);
		refreshTimer(FALSE);
		return msg;
	}
	
	result_t handleDataPacket(TOS_MsgPtr msg)
	{
		int i;
				
		node_in->bw--;
		call ConnMgr.recvedPacket(node_in->addr);
		
		//check to see if it's a duplicate
		if (memcmp(m_last.data, msg->data+1, 10) == 0)
		{
			return SUCCESS;
		}
			
		for (i = 0; i < NUM_BUFS; i++)
		{
			if (valid[i] == FALSE)
			{
				memcpy(m_last.data, msg->data+1, 10);
				memcpy(bufs[i].data, msg->data+1, TOSH_DATA_LENGTH-1);
				bufs[i].length = msg->length-1;
				valid[i] = TRUE;
				refreshTimer(FALSE);
		
				return SUCCESS;
			}
		}
		
		return FAIL;
		
	}
	
	event TOS_MsgPtr PreReceive.receive (TOS_MsgPtr msg)
	{
		if (inNode == TRUE)
		{
			call ConnMgr.radioHi();
		}
		refreshTimer(TRUE);
		return msg;	
	}
	
	event TOS_MsgPtr DataReceive.receive (TOS_MsgPtr msg)
	{
		int src;
		
		src = msg->data[0];
		
		if (!inNode)
		{
			call Leds.yellowOn();
			return msg;
		}
		
		if (src != node_in->addr) 
		{
			call Leds.redOn();
			return msg;
		}
				
		handleDataPacket(msg);
		post chooseTask();
		
		
		return msg;
	}

	event TOS_MsgPtr ArchiveReceive.receive (TOS_MsgPtr msg)
	{
		int src;
		src = msg->data[0];
		
		if (src != node_in->addr || !inNode) return msg;
				
		handleDataPacket(msg);
		post chooseTask();
		return msg;
	}  
	
	event result_t ObjLog.appendDone(int logid, result_t success)
	{
		//result_t res;
		//uint8_t src;
		//uint16_t seq;
		
		if (logid != 1)
		{
			//ignore it. Probably a bug.
			return SUCCESS;
		}
		
		if (success == FAIL)
		{
			retries--;
			if (retries <= 0)
			{
				post appendTask();
			} else {
				writing = FALSE;
				valid[curbuf] = FALSE;
				signalFailure();
			}
		} else {
			valid[curbuf] = FALSE;
			writing = FALSE;
			/*if (TOS_LOCAL_ADDRESS == 0)
			{
				//if this is the base station, create the ack
				src = bufs[curbuf].data[0];
				seq = bufs[curbuf].data[1] & 0x00FF; 
				seq += (bufs[curbuf].data[2] << 8);
				
				//create the ack;
				res = call AckStore.report_ack(src,seq,seq);
			}*/
			post chooseTask();
		}
		return SUCCESS;
	}
	
	event result_t Timer.fired()
	{
		//too long without a receive.
		signalFailure();
		return SUCCESS;
	}
		
	event result_t ObjLog.readDone(int logid, uint8_t *buffer, uint16_t numbytes, result_t success)
	{
		return SUCCESS;
	}
  
}
