includes structs;

module FastReactM
{
  provides
  {
    interface StdControl;
    interface IFastReact;
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

  command bool IFastReact.ready ()
  {
//PUT READY IMPLEMENTATION HERE

    return TRUE;
  }

  command result_t IFastReact.nodeCall (FastReact_in ** in,
					FastReact_out ** out)
  {
//PUT NODE IMPLEMENTATION HERE

//Done signal can be moved if node makes split phase calls.
    signal IFastReact.nodeDone (in, out, ERR_OK);
    return SUCCESS;
  }
}
