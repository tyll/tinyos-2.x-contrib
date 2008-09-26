includes structs;
#include "uservariables.h"

module LogConnectionEventM
{
	provides
	{
		interface StdControl;
		interface ILogConnectionEvent;
	}
	uses
	{
		interface BitVec;
		command uint16_t getNextSeq();	
	}
}
implementation
{
#include "fluxconst.h"

LogConnectionEvent_in * node_in;
LogConnectionEvent_out * node_out;

	
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
	
	
	
	
	task void PrepTask()
	{
		uint16_t seq;
		char *__writebuf;
		//make 
		seq = call getNextSeq();
		
		__writebuf = node_out->chunkarr.chunks[0].data;
		__writebuf[0] = TOS_LOCAL_ADDRESS;
		__writebuf[1] = ((booted ? 1 : 0) << 7) | BTYPE_CONN;
		memcpy(__writebuf+2, &seq, 2);
		//__writebuf[4] = 0;
		//__writebuf[5] = 0;
		memcpy(__writebuf+4, &rt_clock, sizeof(rt_clock));
		//call BitVec.set16((uint16_t*)(__writebuf+4), TOS_LOCAL_ADDRESS, TRUE);
		
		memcpy(__writebuf+8, &node_in->addr, 2);
		memcpy(__writebuf+10, &node_in->duration, 2);
		__writebuf[12] = node_in->quality;
		
		node_out->chunkarr.chunks[0].length = 13; //better be less than 28
		node_out->chunkarr.num = 1;
		signal ILogConnectionEvent.nodeDone (node_in, node_out, ERR_OK);

	}
	
	/*
	IN: 
		uint16_t addr - addr of sending turtle
		uint16_t duration - how long was the event
		uint8_t  quality - how good was the connection
	*/
	command result_t ILogConnectionEvent.nodeCall (LogConnectionEvent_in * in,
							LogConnectionEvent_out *
							out)
	{
		node_in = in;
		node_out = out;
		
		post PrepTask();
		
		//Done signal can be moved if node makes split phase calls.
		//signal ILogConnectionEvent.nodeDone (in, out, ERR_OK);
		return SUCCESS;
	}
	
	
}
