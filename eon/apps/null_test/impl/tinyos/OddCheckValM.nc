includes structs;

module OddCheckValM
{
  provides
  {
    interface StdControl;
    interface IOddCheckVal;
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

  command bool IOddCheckVal.ready ()
  {
//PUT READY IMPLEMENTATION HERE

    return TRUE;
  }

  command result_t IOddCheckVal.nodeCall (OddCheckVal_in ** in,
					  OddCheckVal_out ** out)
  {
//PUT NODE IMPLEMENTATION HERE

//Done signal can be moved if node makes split phase calls.
    signal IOddCheckVal.nodeDone (in, out, ERR_OK);
    return SUCCESS;
  }
}
