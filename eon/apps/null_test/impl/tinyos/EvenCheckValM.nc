includes structs;

module EvenCheckValM
{
  provides
  {
    interface StdControl;
    interface IEvenCheckVal;
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

  command bool IEvenCheckVal.ready ()
  {
//PUT READY IMPLEMENTATION HERE

    return TRUE;
  }

  command result_t IEvenCheckVal.nodeCall (EvenCheckVal_in ** in,
					   EvenCheckVal_out ** out)
  {
//PUT NODE IMPLEMENTATION HERE

//Done signal can be moved if node makes split phase calls.
    signal IEvenCheckVal.nodeDone (in, out, ERR_OK);
    return SUCCESS;
  }
}
