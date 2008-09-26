includes structs;

module OddReactM
{
  provides
  {
    interface StdControl;
    interface IOddReact;
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

  command bool IOddReact.ready ()
  {
//PUT READY IMPLEMENTATION HERE

    return TRUE;
  }

  command result_t IOddReact.nodeCall (OddReact_in ** in, OddReact_out ** out)
  {
//PUT NODE IMPLEMENTATION HERE

//Done signal can be moved if node makes split phase calls.
    signal IOddReact.nodeDone (in, out, ERR_OK);
    return SUCCESS;
  }
}
