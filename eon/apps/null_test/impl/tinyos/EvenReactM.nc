includes structs;

module EvenReactM
{
  provides
  {
    interface StdControl;
    interface IEvenReact;
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

  command bool IEvenReact.ready ()
  {
//PUT READY IMPLEMENTATION HERE

    return TRUE;
  }

  command result_t IEvenReact.nodeCall (EvenReact_in ** in,
					EvenReact_out ** out)
  {
//PUT NODE IMPLEMENTATION HERE

//Done signal can be moved if node makes split phase calls.
    signal IEvenReact.nodeDone (in, out, ERR_OK);
    return SUCCESS;
  }
}
