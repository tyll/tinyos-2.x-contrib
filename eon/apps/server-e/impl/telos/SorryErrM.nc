includes structs;

module SorryErrM
{
  provides
  {
    interface StdControl;
    interface ISorryErr;
    interface IEnergyCost;
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

  command uint16_t IEnergyCost.getMinCost ()
  {
    return 1;
  }

  command uint16_t IEnergyCost.getMaxCost ()
  {
    return 1;
  }

  command result_t ISorryErr.errCall (SrvText_in ** in, uint8_t error)
  {
//PUT ERROR HANDLER IMPLEMENTATION HERE

//Done signal can be moved if node makes split phase calls.
    signal ISorryErr.errDone (in);
    return SUCCESS;
  }
}
