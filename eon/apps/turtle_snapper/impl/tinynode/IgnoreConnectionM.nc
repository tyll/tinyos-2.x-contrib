includes structs;

module IgnoreConnectionM
{
  provides
  {
    interface StdControl;
    interface IIgnoreConnection;
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


  command result_t IIgnoreConnection.nodeCall (IgnoreConnection_in * in,
					       IgnoreConnection_out * out)
  {
//PUT NODE IMPLEMENTATION HERE

//Done signal can be moved if node makes split phase calls.
    signal IIgnoreConnection.nodeDone (in, out, ERR_OK);
    return SUCCESS;
  }
}
