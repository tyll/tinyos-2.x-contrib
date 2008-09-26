includes structs;

module ListenConnectionM
{
  provides
  {
    interface StdControl;
    interface IListenConnection;
  }
  uses
  {
  	interface ReceiveMsg;
  }
}
implementation
{
#include "fluxconst.h"
ListenConnection_out *node_out;


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

  command result_t IListenConnection.srcStart (ListenConnection_out * out)
  {
  	node_out = out;
    return SUCCESS;
  }
  
  event TOS_MsgPtr ReceiveMsg.receive (TOS_MsgPtr msg)
	{
		AcceptConnectionMsg_t *body = (AcceptConnectionMsg_t *) msg->data;

		node_out->addr = body->src_addr;
		signal IListenConnection.srcFired(node_out);

		return msg;
	}

}
