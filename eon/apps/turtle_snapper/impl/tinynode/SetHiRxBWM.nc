includes structs;

module SetHiRxBWM
{
  provides
  {
    interface StdControl;
    interface ISetHiRxBW;
	
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


  command result_t ISetHiRxBW.nodeCall (SetHiRxBW_in * in,
					SetHiRxBW_out * out)
  {
//PUT NODE IMPLEMENTATION HERE
	out->addr = in->addr;
	out->delay = in->delay;
	out->bw = RX_HI_BW;
//Done signal can be moved if node makes split phase calls.
    signal ISetHiRxBW.nodeDone (in, out, ERR_OK);
    return SUCCESS;
  }
  
  
}
