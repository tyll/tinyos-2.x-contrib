includes structs;

module DoBlinkM
{
  provides
  {
    interface StdControl;
    interface IDoBlink;
  }
  uses
  {
  	interface Leds;
  }
}
implementation
{
#include "fluxconst.h"

  command result_t StdControl.init ()
  {
  	call Leds.init();
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

  command bool IDoBlink.ready ()
  {
//PUT READY IMPLEMENTATION HERE

    return TRUE;
  }

  command result_t IDoBlink.nodeCall (DoBlink_in * in, DoBlink_out * out)
  {
//PUT NODE IMPLEMENTATION HERE
	if (in->val)
	{
		call Leds.redToggle();
	} else {
		call Leds.greenToggle();
	}
//Done signal can be moved if node makes split phase calls.
    signal IDoBlink.nodeDone (in, out, ERR_OK);
    return SUCCESS;
  }
}
