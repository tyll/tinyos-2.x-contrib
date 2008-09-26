includes structs;

module TxOpM
{
  provides
  {
    interface StdControl;
    interface ITxOp;
  }
  uses 
  {
  	interface TxTime;
  }
}
implementation
{
#include "fluxconst.h"

TxOp_out *node_out;

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

  command result_t ITxOp.srcStart (TxOp_out * out)
  {
  	node_out = out;
    return SUCCESS;
  }
  
  event void TxTime.txtime()
  {
  	signal ITxOp.srcFired(node_out);
  }

}
