includes structs;

module MedCheckValM
{
  provides
  {
    interface StdControl;
    interface IMedCheckVal;
  }
}
implementation
{
#include "fluxconst.h"
uint16_t test_value;
MedCheckVal_in **node_in;
MedCheckVal_out **node_out;

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

  command bool IMedCheckVal.ready ()
  {
//PUT READY IMPLEMENTATION HERE

    return TRUE;
  }

  task void returnTask()
  {
  	signal IMedCheckVal.nodeDone (node_in, node_out, ERR_OK);
  }
  
  command result_t IMedCheckVal.nodeCall (MedCheckVal_in ** in,
					  MedCheckVal_out ** out)
  {
//PUT NODE IMPLEMENTATION HERE
	(*out)->valid = (test_value == 0xbeef);

	node_in = in;
	node_out = out;
	
//Done signal can be moved if node makes split phase calls.
    //signal IMedCheckVal.nodeDone (in, out, ERR_OK);
    return post returnTask();
  }
}
