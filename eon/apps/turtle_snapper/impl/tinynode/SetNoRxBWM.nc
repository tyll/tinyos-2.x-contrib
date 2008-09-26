includes structs;

module SetNoRxBWM
{
  provides
  {
    interface StdControl;
    interface ISetNoRxBW;
  }
}
implementation
{
#include "fluxconst.h"

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

 
  command result_t ISetNoRxBW.nodeCall (SetNoRxBW_in * in,
					SetNoRxBW_out * out)
  {
//PUT NODE IMPLEMENTATION HERE
	out->addr = in->addr;
	out->delay = in->delay;
	out->bw = 0;
//Done signal can be moved if node makes split phase calls.
    signal ISetNoRxBW.nodeDone (in, out, ERR_OK);
    return SUCCESS;
  }
}
