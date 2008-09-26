includes structs;


module ListenM
{
  provides {
    interface StdControl;
    interface IListen;
  }
  uses {
    interface Leds;
	interface ReceiveMsg;
	
  }
}
implementation
{
#include "fluxconst.h"

  Listen_out** outvar;
  TOS_MsgPtr recvPtr;
  TOS_Msg buffer;

  command result_t StdControl.init()
    {
    	
      return SUCCESS;
    }

  command result_t StdControl.start()
    {
      return SUCCESS;
    }

  command result_t StdControl.stop()
    {
      return SUCCESS;
    }

  

  command result_t IListen.srcStart(Listen_out **out)
    {
      	outvar = out;
		recvPtr = &buffer;
      return SUCCESS;
    }

  task void fireTask()
    {
    	
    	RequestMsg* mptr = (RequestMsgPtr)recvPtr->data;

      memcpy(&((*outvar)->request), mptr, sizeof(RequestMsg));
      signal IListen.srcFired(outvar);
    }


	

  event TOS_MsgPtr ReceiveMsg.receive (TOS_MsgPtr m)
  {
    TOS_MsgPtr tmp;
    tmp = recvPtr;
    recvPtr = m;
    post fireTask ();
    return tmp;
  }
}
