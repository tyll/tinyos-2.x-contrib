includes structs;

module RecvStatusM
{
  provides
  {
    interface StdControl;
    interface IRecvStatus;
  }
  uses
  {
  	interface ReceiveMsg;
	interface ICache;
	interface Leds;
  }
}
implementation
{
#include "fluxconst.h"

	RecvStatus_out * node_out;

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

  command result_t IRecvStatus.srcStart (RecvStatus_out * out)
  {
  	node_out = out;
    return SUCCESS;
  }
  
  event TOS_MsgPtr ReceiveMsg.receive (TOS_MsgPtr msg)
	{
		StatusMsg_t *body = (StatusMsg_t *) msg->data;
			
		call Leds.yellowToggle();
		call ICache.put(body);			
		

		return msg;
	}

}
