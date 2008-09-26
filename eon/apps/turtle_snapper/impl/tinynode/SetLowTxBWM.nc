includes structs;

module SetLowTxBWM
{
  provides
  {
    interface StdControl;
    interface ISetLowTxBW;
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

  

  command result_t ISetLowTxBW.nodeCall (SetLowTxBW_in * in,
					 SetLowTxBW_out * out)
  {
//PUT NODE IMPLEMENTATION HERE
	out->bw = TX_LO_BW;
//Done signal can be moved if node makes split phase calls.
    signal ISetLowTxBW.nodeDone (in, out, ERR_OK);
    return SUCCESS;
  }
}
