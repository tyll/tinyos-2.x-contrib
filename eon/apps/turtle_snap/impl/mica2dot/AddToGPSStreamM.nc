includes structs;

module AddToGPSStreamM
{
	provides
	{
		interface StdControl;
		interface IAddToGPSStream;
	}
	uses 
	{
		interface Stream as GpsStream;
		interface Stream as GpsLengthStream;
		interface SendMsg;
	}
}
implementation
{
#include "fluxconst.h"

AddToGPSStream_in **node_in;
AddToGPSStream_out **node_out;

uint32_t streamlength;
datalen_t Slen;
int state;

enum {STATE_LENGTH, STATE_STAMP, STATE_FIX, STATE_DONE};

task void readStreamLen();
task void streamAddStamp();
task void streamAddFix();
task void writeLength();

TOS_Msg m_msg;

	command result_t StdControl.init ()
	{
		state = STATE_DONE;
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
	
	command bool IAddToGPSStream.ready ()
	{
	//PUT READY IMPLEMENTATION HERE
	
		return TRUE;
	}

	 /*
	IN:
		GpsData_t data - the gps reading that was taken
	OUT:
		uint32_t num - size of the stream
	 */
	
	command result_t IAddToGPSStream.nodeCall (AddToGPSStream_in ** in,
											   AddToGPSStream_out ** out)
	{

		node_in = in;
		node_out = out;

		state = STATE_LENGTH;
		post readStreamLen();
		
//Done signal can be moved if node makes split phase calls.
    //signal IAddToGPSStream.nodeDone (in, out, ERR_OK);
		return SUCCESS;
	}
  
	task void readStreamLen()
	{
		result_t res;
		
		res = call GpsLengthStream.start_traversal(NULL); 
		//actually, res can only be SUCCESS, so no check
		
		res = call GpsLengthStream.next(&streamlength, &Slen);
		if (res == FAIL)
		{
			if (Slen)
			{
				//no value
				streamlength = 0;
				state = STATE_STAMP;
				post streamAddStamp();
			} else {
				//error;
				//not sure what to do here...
				state = STATE_DONE;
				signal IAddToGPSStream.nodeDone(node_in, node_out, ERR_USR);
			}
				
		} 
	}
  
	task void streamAddStamp()
	{
		result_t res;
	
		//res = call GpsStream.append(&((*node_in)->data), sizeof(GpsData_t)-sizeof(GpsFixData), NULL);
		res = call GpsStream.append(&((*node_in)->data), (NMEA_CHARS_PER_FIELD*2), NULL);
		//res = call GpsStream.append(&((*node_in)->data), 10, NULL);
		if (res == FAIL)
		{
			state = STATE_DONE;
			signal IAddToGPSStream.nodeDone(node_in, node_out, ERR_USR);
			return;
		}
	}
  
	task void streamAddFix()
	{
		result_t res;
		//int offset;
		int size;
	
		//offset = sizeof(GpsData_t)-sizeof(GpsFixData);
		//offset = (NMEA_CHARS_PER_FIELD*2*sizeof(char)) + sizeof(uint16_t);
		
		//memset(&((*node_in)->data)+offset, )
		
		size = sizeof(GpsFixData);
		//memcpy(m_msg.data, (&((*node_in)->data))+offset, size);
		/*
		memcpy( m_msg.data, &((*node_in)->data.fix), sizeof(GpsData_t) );
		if( call SendMsg.send(TOS_BCAST_ADDR, sizeof(GpsData_t)-sizeof(GpsFixData), &m_msg ) == FAIL )
		{
		
		}
		*/
	
		res = call GpsStream.append(&((*node_in)->data.fix), sizeof(GpsFixData), NULL);
		if (res == FAIL)
		{
			state = STATE_DONE;
			signal IAddToGPSStream.nodeDone(node_in, node_out, ERR_USR);
			return;
		}
    
	}
  
  
	task void writeLength()
	{
		result_t res;
		call GpsLengthStream.init(TRUE);
		streamlength += sizeof(GpsData_t);
		res = call GpsLengthStream.append(&streamlength, sizeof(streamlength), NULL);
		if (res == FAIL)
		{
			signal IAddToGPSStream.nodeDone(node_in, node_out, ERR_USR);
			return;
		}
	}
  
	event void GpsStream.appendDone(result_t res)
	{
		if (res == FAIL)
		{
			signal IAddToGPSStream.nodeDone(node_in, node_out, ERR_USR);
			return;
		}
		if (state == STATE_STAMP)
		{
			state = STATE_FIX;
			post streamAddFix();
		} else {
			post writeLength();	
		}
	}
  
	event void GpsStream.nextDone(result_t res)
	{
  
	}
  
	event void GpsLengthStream.appendDone(result_t res)
	{
		if (res == FAIL)
		{
			signal IAddToGPSStream.nodeDone(node_in, node_out, ERR_USR);
			return;
		}
		(*node_out)->num = streamlength;
		signal IAddToGPSStream.nodeDone(node_in, node_out, ERR_OK);
	}
  
	event void GpsLengthStream.nextDone(result_t res)
	{
		if (res == FAIL)
		{
		//hmmm...could be bad
			signal IAddToGPSStream.nodeDone(node_in, node_out, ERR_USR);
			return;
		}
		if (state == STATE_LENGTH)
		{
			state = STATE_STAMP;
			post streamAddStamp();
		} 
	}
	
	event result_t SendMsg.sendDone( TOS_MsgPtr msg, result_t success )
	{
		return SUCCESS;
	}
}
