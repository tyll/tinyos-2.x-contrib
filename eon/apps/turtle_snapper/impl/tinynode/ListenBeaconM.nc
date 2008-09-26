includes structs;

module ListenBeaconM
{
	provides
	{
		interface StdControl;
		interface IListenBeacon;
	}
	uses
	{
		interface ReceiveMsg;
		interface ReceiveMsg as ReceiveActivateMsg;
		interface SendMsg;
		interface ConnMgr;
		interface Leds;
		interface Timer as ActivateTimer;
		interface Calib;
		interface Random;
	}
} 
implementation
{
#include "fluxconst.h"
TOS_Msg msgbuf;

	ListenBeacon_out *node_out;
	
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

	
	
	command result_t IListenBeacon.srcStart (ListenBeacon_out * out)
	{
		node_out = out;
		return SUCCESS;
	}
  
	
	task void sendStatusTask()
	{
		
		StatusMsg_t * body = (StatusMsg_t *)msgbuf.data;
		
		body->src_addr = TOS_LOCAL_ADDRESS;
		body->volts = last_volts;
		body->act = g_active;
		body->state = curstate;
		body->grade = (uint8_t)(curgrade * 100.0);
		body->rt_clock = rt_clock;
		
		/*body->src_addr = g_yr;
		body->volts = g_mo;
		body->act = g_dy;
		body->state = g_hr;
		body->grade = g_min;
		body->rt_clock = g_sec;*/
		
		call SendMsg.send(TOS_BCAST_ADDR, sizeof(StatusMsg_t), &msgbuf );
		
	}
	
	event result_t SendMsg.sendDone(TOS_MsgPtr msg, result_t success)
	{
		return SUCCESS;
	}
	
	event TOS_MsgPtr ReceiveActivateMsg.receive (TOS_MsgPtr msg)
	{
		uint16_t delay_ms;
		
		if (msg->data[0] == ACT_ON)
		{
			g_active = TRUE;
		}
		if (msg->data[0] == ACT_OFF)
		{
			g_active = FALSE;
		}
		if (msg->data[0] == ACT_INIT)
		{
			g_active = TRUE;
			call Calib.init();
		}
		
		//randomize this
		delay_ms = (((call Random.rand() >> 8) * 100) % 1000L) + 1000L;
		call ActivateTimer.start(TIMER_ONE_SHOT, delay_ms);
		//post sendStatusTask();
		return msg;
	}
	
	event result_t ActivateTimer.fired()
	{
		post sendStatusTask();
		return SUCCESS;
	}
	
	event TOS_MsgPtr ReceiveMsg.receive (TOS_MsgPtr msg)
	{
		BeaconMsg_t *body = (BeaconMsg_t *) msg->data;
			
		
		if (g_in_gps == TRUE || !g_active)
		{
			
			return msg;
		}
		
		node_out->addr = body->src_addr;
		node_out->delay = body->src_delay;
			
		call ConnMgr.beacon(node_out->addr, node_out->delay);
			
		if (g_active)
		{
			signal IListenBeacon.srcFired(node_out);
		}
		
		return msg;
	}
	
}
