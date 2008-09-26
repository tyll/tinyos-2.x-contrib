includes structs;

module FinishM
{
  provides
  {
    interface StdControl;
    interface IFinish;
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

  command bool IFinish.ready ()
  {
//PUT READY IMPLEMENTATION HERE

    return TRUE;
  }

  command result_t IFinish.nodeCall (Finish_in ** in, Finish_out ** out)
  {
//PUT NODE IMPLEMENTATION HERE

//Done signal can be moved if node makes split phase calls.
    signal IFinish.nodeDone (in, out, ERR_OK);
    return SUCCESS;
  }
}
