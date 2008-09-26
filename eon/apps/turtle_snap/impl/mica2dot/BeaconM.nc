includes structs;

module BeaconM
{
	provides
	{
		interface StdControl;
		interface IBeacon;
	}
	uses
	{
		//interface VersionStore;
		//interface InfoStore;
		interface Timer;
		interface SendMsg;
		interface Leds;
		command result_t SetListeningMode(uint8_t power);
    	command uint8_t GetListeningMode();
		
	}
}
implementation
{
#include "fluxconst.h"
#include "beacon.h"
	
	Beacon_in** node_in;
	Beacon_out** node_out;
	uint8_t num_sent;
	TOS_Msg m_msg;
	bool _ready = TRUE;

	command result_t StdControl.init ()
	{
		call Leds.init();
		return SUCCESS;
	}

	command result_t StdControl.start ()
	{
		
		call SetListeningMode(CC1K_LPL_STATES-1);
		return SUCCESS;
	}

	command result_t StdControl.stop ()
	{
		return SUCCESS;
	}

	command bool IBeacon.ready ()
	{
//PUT READY IMPLEMENTATION HERE

		return _ready;
	}

	command result_t IBeacon.nodeCall (Beacon_in ** in, Beacon_out ** out)
	{
//PUT NODE IMPLEMENTATION HERE

		BeaconMsg_t* body = (BeaconMsg_t*)m_msg.data;
		uint8_t turtle_version_number = 0;
		_ready = FALSE;
		node_in = in;
		node_out = out;
    
		num_sent = 0;

    
		
     

	body->version_num = turtle_version_number;
    body->src_addr = TOS_LOCAL_ADDRESS;

	return call Timer.start(TIMER_ONE_SHOT, BEACON_IVAL);

//Done signal can be moved if node makes split phase calls.
//    signal IBeacon.nodeDone (in, out, ERR_OK);
//    return SUCCESS;
	}

	event result_t Timer.fired()
	{
		result_t res;
		num_sent++;
		
		
		
		

	  // Send the Beacon here...
		res = call SendMsg.send( TOS_BCAST_ADDR, sizeof(BeaconMsg_t), &m_msg );
	  
		if (num_sent > (BEACON_COUNT))
		{
			signal IBeacon.nodeDone (node_in, node_out, ERR_OK);
			return SUCCESS;
		}	
		
		call Timer.start(TIMER_ONE_SHOT, BEACON_IVAL);
		return SUCCESS;
	}

	event result_t SendMsg.sendDone(TOS_MsgPtr msg, result_t success)
	{
		return SUCCESS;
	}
  
}
