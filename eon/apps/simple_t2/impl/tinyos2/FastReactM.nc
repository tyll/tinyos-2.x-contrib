includes structs;

module FastReactM
{
  provides
  {
    interface Init;
    interface StdControl;
    interface IFastReact;
	
  }
  uses
  {
  	interface Leds;
  }
}
implementation
{
#include "eonconst.h"

  command error_t Init.init ()
  {
    return SUCCESS;
  }

  command error_t StdControl.start ()
  {
    return SUCCESS;
  }

  command error_t StdControl.stop ()
  {
    return SUCCESS;
  }


  command error_t IFastReact.nodeCall (FastReact_in * in, FastReact_out * out)
  {
//PUT NODE IMPLEMENTATION HERE
	call Leds.led0Toggle();
	call Leds.led1Toggle();
	call Leds.led2Toggle();
	
//Done signal can be moved if node makes split phase calls.
    signal IFastReact.nodeDone (in, out, ERR_OK);
    return SUCCESS;
  }
}
