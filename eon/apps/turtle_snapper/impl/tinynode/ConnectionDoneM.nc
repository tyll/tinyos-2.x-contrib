includes structs;

module ConnectionDoneM
{
  provides
  {
    interface StdControl;
    interface IConnectionDone;
  }
  uses {
  	interface ConnEnd;
  }
}
implementation
{
#include "fluxconst.h"

ConnectionDone_out *node_out;

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

  command result_t IConnectionDone.srcStart (ConnectionDone_out * out)
  {
  	node_out = out;
    return SUCCESS;
  }
  
  event void ConnEnd.connectionEnded(uint16_t addr, uint16_t duration, uint8_t quality, uint16_t rx, uint16_t tx)
	{
		node_out->addr = addr;
		node_out->duration = duration;
		node_out->quality = quality;
		signal IConnectionDone.srcFired(node_out);
	}

}
