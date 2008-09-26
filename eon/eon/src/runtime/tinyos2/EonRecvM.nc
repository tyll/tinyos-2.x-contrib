includes structs;

module EonRecvM
{
  provides
  {
    interface Init;
    interface StdControl;
    interface IEonRecv;
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


  command error_t IEonRecv.nodeCall (EonRecv_in * in, EonRecv_out * out)
  {
//PUT NODE IMPLEMENTATION HERE

//Done signal can be moved if node makes split phase calls.
    signal IEonRecv.nodeDone (in, out, ERR_OK);
    return SUCCESS;
  }
}
