includes structs;

module DeleteAllBundlesMsgM
{
  provides
  {
    interface StdControl;
    interface IDeleteAllBundlesMsg;
  }
  uses
	{
		interface BundleIndex as MyIndex;
		interface SendMsg;
	}
}
implementation
{
#include "fluxconst.h"

	TOS_Msg g_d_msg;


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

  command bool IDeleteAllBundlesMsg.ready ()
  {
//PUT READY IMPLEMENTATION HERE

    return TRUE;
  }

  command result_t IDeleteAllBundlesMsg.nodeCall (DeleteAllBundlesMsg_in **
						  in,
						  DeleteAllBundlesMsg_out **
						  out)
  {
	DeleteAllBundlesMsg_t * body;
  	call MyIndex.init();
	
	memset(&g_d_msg, 0, sizeof(g_d_msg));
	body = (DeleteAllBundlesMsg_t*)g_d_msg.data;
	body->src_addr = TOS_LOCAL_ADDRESS;
	call SendMsg.send((*in)->src_addr, sizeof(DeleteAllBundlesMsg_t), &g_d_msg);


    signal IDeleteAllBundlesMsg.nodeDone (in, out, ERR_OK);
    return SUCCESS;
  }
  
  event result_t SendMsg.sendDone( TOS_MsgPtr msg, result_t success )
	{
		
		return SUCCESS;
	}
	
	event void MyIndex.loadDone(result_t res)
	{
	
	}
	event void MyIndex.saveDone(result_t res)
	{
	}
	
	event void MyIndex.AppendDone(result_t res)
	{
	
	}
	
	event void MyIndex.GetBundleDone(result_t res, bool valid)
	{
	
	}
	event void MyIndex.DeleteBundleDone(result_t res)
	{
		
	}
}
