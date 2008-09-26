includes structs;

includes XE1205Const;

module SerialSendM
{
  provides
  {
    interface StdControl;
    interface ISerialSend;
  }
  uses
  {
  	interface SendMsg;
	//interface ReceiveMsg;
  	interface ICache;
	interface Console;
	interface Leds;
	interface Timer;
	interface XE1205LPL;
	interface XE1205Control;
	interface CSMAControl;
  }
}
implementation
{
#include "fluxconst.h"

	TOS_Msg msgbuf;
	
	SerialSend_in *node_in;
	SerialSend_out *node_out;
	uint16_t scan_addr;

	
	void __radioLo()
  {
  	
	call XE1205LPL.SetListeningMode(XE1205_LPL_STATES-1);
	call XE1205LPL.SetTransmitMode(XE1205_LPL_STATES-1);
	
  }
  
  void __radioHi()
  {
	call XE1205LPL.SetListeningMode(0);
	call XE1205LPL.SetTransmitMode(0);
  }
  
  void setRF()
  {
	call XE1205Control.SetBitrate(40000L);
	call XE1205Control.SetRFPower(3);//15 dBm Tx power
	call CSMAControl.enableCCA();
	call CSMAControl.enableAck();
	__radioLo();
  }
  
  task void SetRF()
  {
  	setRF();
	
  }
	
  command result_t StdControl.init ()
  {
  	call Leds.init();
	scan_addr = 0xFFFF;
    return SUCCESS;
  }

  command result_t StdControl.start ()
  {
  	call Console.init();
	call ICache.setStatus(ACT_IDLE);
	post SetRF();
    return SUCCESS;
  }

  command result_t StdControl.stop ()
  {
    return SUCCESS;
  }

  task void finishTask()
  {
  	signal ISerialSend.nodeDone (node_in, node_out, ERR_OK);
  }
  
  
  
  task void scanTask()
  {
  	result_t res;
  	msgbuf.data[0] = call ICache.getStatus();
	
	if (call ICache.getStatus() == ACT_IDLE)
	{
		post finishTask();
		return;
	}
	
	if (call ICache.getStatus() == ACT_INIT)
	{
		//only send init once.
		call ICache.setStatus(ACT_IDLE);
	}
	
	res = call SendMsg.send(scan_addr, 2, &msgbuf);
	if (res == FAIL)
	{
		call Console.string("Scan failed! (call)\n");
		post finishTask();
	}
	
	
  }
  
  task void printResultsTask()
  {
  	StatusMsg_t msg;
	
	if (call ICache.get(&msg) == FAIL) 
	{
		post scanTask();
		return;
	}
	
	call Console.string("FOUND,#");
	call Console.decimal(msg.src_addr);
	call Console.string(",B=");
	call Console.decimal(msg.volts);
	call Console.string(",A=");
	call Console.decimal(msg.act);
	call Console.string(",S=");
	call Console.decimal(msg.state);
	call Console.string(",G=");
	call Console.decimal(msg.grade);
	call Console.string(",C=");
	call Console.decimal(msg.rt_clock);
	call Console.string(".\n");
	
	call Timer.start(TIMER_ONE_SHOT, 100);
  }
  
  event result_t Timer.fired()
  {	
  	post printResultsTask();
	return SUCCESS;
  }
  
  event result_t SendMsg.sendDone(TOS_MsgPtr msg, result_t success)
	{
		if (success == FAIL)
		{
			call Console.string("Scan failed!\n");
			return SUCCESS;
		}
		post finishTask();
		return SUCCESS;
	}
  
	#include "mktime.c"
	
  task void sendStatusTask()
  {
  	int stat;
	uint32_t myt;
	
	//test mktime
	/*myt = tl_mktime(2008, 6, 26, 10, 29, 34);
	call Console.string ("time-");
	call Console.decimal(myt);
	call Console.string ("\n");
	
	//myt = my_mktime(108, 5, 26, 10, 29, 34);
	myt = 1214491308UL;
	call Console.string ("time-");
	call Console.decimal(myt);
	call Console.string ("\n");*/
	
	
	stat = call ICache.getStatus();
  	switch (stat)
	{
		case ACT_QUERY:
		{
			call Console.string("Scanning:");
			break;
		}
		case ACT_OFF:
		{
			call Console.string("DeActivating:");
			break;
		}
		case ACT_ON:
		{
			call Console.string("Activating:");
			break;
		}
		case ACT_INIT:
		{
			call Console.string("Init Synch:");
			break;
		}
		case ACT_IDLE:
		{
			call Console.string("Idle:");
			break;
		}
	}
	call Console.decimal(scan_addr);
	call Console.string("\n");
	call Leds.redToggle();
	post printResultsTask();
	
  }

  command result_t ISerialSend.nodeCall (SerialSend_in * in,
					 SerialSend_out * out)
  {
//PUT NODE IMPLEMENTATION HERE

	node_in = in;
	node_out = out;
	
	call Leds.greenToggle();
	post sendStatusTask();

//Done signal can be moved if node makes split phase calls.
    //signal ISerialSend.nodeDone (in, out, ERR_OK);
    return SUCCESS;
  }
  
  event void Console.input(char *str)
  {
  	int i;
  	if (strlen(str) < 2 && str[0] != 'w') return;
	
  	if (str[0] == 'a')
	{
		call ICache.setStatus(ACT_ON);
	} else if (str[0] == 'd')
	{
		call ICache.setStatus(ACT_OFF);
	} else if (str[0] == 's')
	{
		call ICache.setStatus(ACT_QUERY);
	} else if (str[0] == 'i')
	{
		call ICache.setStatus(ACT_INIT);
	} else if (str[0] == 'w')
	{
		call ICache.setStatus(ACT_IDLE);
	} else {
		call Console.string("Error(CMD=");
		call Console.decimal(str[0]);
		call Console.string(")\n");
		return;
	}
	
	if (str[1] == 'b')
	{
		scan_addr = 0xFFFF;
	} else {
		scan_addr = 0;
		i = 1;
		while (str[i] >= '0' && str[i] <= '9')
		{
			scan_addr *= 10;
			scan_addr += str[i] - '0';
			i++;
		}
	}
	call Console.string("Ok\n");
  }
}
