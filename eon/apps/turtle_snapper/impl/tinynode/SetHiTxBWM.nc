includes structs;

module SetHiTxBWM
{
  provides
  {
    interface StdControl;
    interface ISetHiTxBW;
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

  
  command result_t ISetHiTxBW.nodeCall (SetHiTxBW_in * in,
					SetHiTxBW_out * out)
  {
//PUT NODE IMPLEMENTATION HERE

	out->bw = TX_HI_BW;
//Done signal can be moved if node makes split phase calls.
    signal ISetHiTxBW.nodeDone (in, out, ERR_OK);
    return SUCCESS;
  }
}
