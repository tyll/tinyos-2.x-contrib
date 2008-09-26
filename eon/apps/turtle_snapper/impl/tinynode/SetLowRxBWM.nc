includes structs;

module SetLowRxBWM
{
  provides
  {
    interface StdControl;
    interface ISetLowRxBW;
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


  command result_t ISetLowRxBW.nodeCall (SetLowRxBW_in * in,
					 SetLowRxBW_out * out)
  {
//PUT NODE IMPLEMENTATION HERE
	out->addr = in->addr;
	out->delay = in->delay;
	out->bw = RX_LO_BW;
//Done signal can be moved if node makes split phase calls.
    signal ISetLowRxBW.nodeDone (in, out, ERR_OK);
    return SUCCESS;
  }
}
