includes structs;

module EonSendM
{
  provides
  {
    interface Init;
    interface StdControl;
    interface IEonSend;
  }
  uses
  {
  	interface INetwork;
  }
}
implementation
{
#include "eonconst.h"

  command error_t Init.init ()
  {
    return SUCCESS;
  }

  command error_t StdControl.start ()
  {
    return SUCCESS;
  }

  command error_t StdControl.stop ()
  {
    return SUCCESS;
  }


  command error_t IEonSend.nodeCall (EonSend_in * in, EonSend_out * out)
  {
  	error_t result = call INetwork.send_message(in->msg, in->addr);
	//TODO:  add error checking code here
    
    	signal IEonSend.nodeDone (in, out, ERR_OK);
    	return SUCCESS;
  }
  
  event void INetwork.receive(eon_message_t *msg)
  {
  
  }
  
  
}
