includes structs;

module SlowReactM
{
  provides
  {
    interface StdControl;
    interface ISlowReact;
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

  command bool ISlowReact.ready ()
  {
//PUT READY IMPLEMENTATION HERE

    return TRUE;
  }

  command result_t ISlowReact.nodeCall (SlowReact_in ** in,
					SlowReact_out ** out)
  {
//PUT NODE IMPLEMENTATION HERE

//Done signal can be moved if node makes split phase calls.
    signal ISlowReact.nodeDone (in, out, ERR_OK);
    return SUCCESS;
  }
}
