includes structs;

module SlowCheckValM
{
  provides
  {
    interface StdControl;
    interface ISlowCheckVal;
  }
}
implementation
{
#include "fluxconst.h"
uint16_t test_value;
SlowCheckVal_in **node_in;
SlowCheckVal_out **node_out;
int postcount;

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

  command bool ISlowCheckVal.ready ()
  {
//PUT READY IMPLEMENTATION HERE

    return TRUE;
  }

  command result_t ISlowCheckVal.nodeCall (SlowCheckVal_in ** in,
					   SlowCheckVal_out ** out)
  {
//PUT NODE IMPLEMENTATION HERE

//Done signal can be moved if node makes split phase calls.
    signal ISlowCheckVal.nodeDone (in, out, ERR_OK);
    return SUCCESS;
  }
}
