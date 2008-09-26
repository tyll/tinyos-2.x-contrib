includes structs;

module LogConnectionEventM
{
	provides
	{
		interface StdControl;
		interface ILogConnectionEvent;
	}
}
implementation
{
#include "fluxconst.h"
#include "uservariables.h"
	
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
	
	command bool ILogConnectionEvent.ready ()
	{
	//PUT READY IMPLEMENTATION HERE
	
		return TRUE;
	}
	/*
	IN: 
		uint16_t addr - addr of sending turtle
		uint8_t version - version of the turtle's data
	*/
	command result_t ILogConnectionEvent.nodeCall (LogConnectionEvent_in ** in,
							LogConnectionEvent_out **
							out)
	{
		int offset;
		//PUT NODE IMPLEMENTATION HERE
		LogConnectionEvent_in *node_in = (LogConnectionEvent_in*)(*in);
		offset = getTurtleVersionIdx(node_in->addr);
		
		connARR[offset]++;
		
		//Done signal can be moved if node makes split phase calls.
		signal ILogConnectionEvent.nodeDone (in, out, ERR_OK);
		return SUCCESS;
	}
}
