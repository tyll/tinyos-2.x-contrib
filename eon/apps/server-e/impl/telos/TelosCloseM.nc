includes structs;

module TelosCloseM
{
  provides
  {
    interface StdControl;
    interface ITelosClose;
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

  command bool ITelosClose.ready ()
  {
//PUT READY IMPLEMENTATION HERE

    return TRUE;
  }

  command result_t ITelosClose.nodeCall (TelosClose_in ** in,
					 TelosClose_out ** out)
  {
//PUT NODE IMPLEMENTATION HERE

//Done signal can be moved if node makes split phase calls.
    signal ITelosClose.nodeDone (in, out, ERR_OK);
    return SUCCESS;
  }
}
