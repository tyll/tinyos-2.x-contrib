includes structs;

module MedReactM
{
  provides
  {
    interface StdControl;
    interface IMedReact;
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

  command bool IMedReact.ready ()
  {
//PUT READY IMPLEMENTATION HERE

    return TRUE;
  }

  command result_t IMedReact.nodeCall (MedReact_in ** in, MedReact_out ** out)
  {
//PUT NODE IMPLEMENTATION HERE

//Done signal can be moved if node makes split phase calls.
    signal IMedReact.nodeDone (in, out, ERR_OK);
    return SUCCESS;
  }
}
