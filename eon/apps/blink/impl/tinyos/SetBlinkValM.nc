includes structs;

module SetBlinkValM
{
  provides
  {
    interface StdControl;
    interface ISetBlinkVal;
  }
}
implementation
{
#include "fluxconst.h"
int blinkval;

  command result_t StdControl.init ()
  {
  	blinkval = 0;
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

  command bool ISetBlinkVal.ready ()
  {
//PUT READY IMPLEMENTATION HERE

    return TRUE;
  }

  command result_t ISetBlinkVal.nodeCall (SetBlinkVal_in * in,
					  SetBlinkVal_out * out)
  {
//PUT NODE IMPLEMENTATION HERE
	out->val = blinkval;
	blinkval = !blinkval;

//Done signal can be moved if node makes split phase calls.
    signal ISetBlinkVal.nodeDone (in, out, ERR_OK);
    return SUCCESS;
  }
}
