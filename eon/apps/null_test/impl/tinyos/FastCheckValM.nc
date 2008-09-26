includes structs;

module FastCheckValM
{
  provides
  {
    interface StdControl;
    interface IFastCheckVal;
  }
}
implementation
{
#include "fluxconst.h"
uint16_t test_value;

  command result_t StdControl.init ()
  {
  	test_value = 0xbeef;
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

  command bool IFastCheckVal.ready ()
  {
//PUT READY IMPLEMENTATION HERE

    return TRUE;
  }

  
  
  command result_t IFastCheckVal.nodeCall (FastCheckVal_in ** in,
					   FastCheckVal_out ** out)
  {
//PUT NODE IMPLEMENTATION HERE

//Done signal can be moved if node makes split phase calls.
	(*out)->valid = (test_value == 0xbeef);

    signal IFastCheckVal.nodeDone (in, out, ERR_OK);
    return SUCCESS;
  }
}
