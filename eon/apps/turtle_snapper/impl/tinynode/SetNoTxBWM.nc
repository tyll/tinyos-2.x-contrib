includes structs;

module SetNoTxBWM
{
  provides
  {
    interface StdControl;
    interface ISetNoTxBW;
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


  command result_t ISetNoTxBW.nodeCall (SetNoTxBW_in * in,
					SetNoTxBW_out * out)
  {
//PUT NODE IMPLEMENTATION HERE

	out->bw = 0;
//Done signal can be moved if node makes split phase calls.
    signal ISetNoTxBW.nodeDone (in, out, ERR_OK);
    return SUCCESS;
  }
}
