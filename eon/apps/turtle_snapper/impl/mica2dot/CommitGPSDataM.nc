includes structs;

module CommitGPSDataM
{
	provides
	{
		interface StdControl;
		interface ICommitGPSData;
	}
	uses
	{
		interface BundleIndex as MyIndex;
	//interface VersionStore;
	//interface InfoStore;
		interface Stream as BundleNumStream;
		interface Leds;
		interface Stream as GpsStream;
	}
}
implementation
{
#include "fluxconst.h"
CommitGPSData_in **node_in;
CommitGPSData_out **node_out;
Bundle_t thebundle;

uint32_t __bundlenum;
datalen_t __length;

bool committing;

	command result_t StdControl.init ()
	{
		committing = FALSE;
		call MyIndex.init();
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

	command bool ICommitGPSData.ready ()
	{
//PUT READY IMPLEMENTATION HERE

		return TRUE;
	}

	task void commitBNum()
	{
		result_t res;
		call BundleNumStream.init(FALSE);
		committing = TRUE;
		__bundlenum++;
		res = call BundleNumStream.append(&__bundlenum, sizeof(uint32_t), NULL);
		if (res == FAIL)
		{
			committing = FALSE;
			__bundlenum--;
			signal ICommitGPSData.nodeDone(node_in, node_out, ERR_USR);
			return;
		}
	}
  
	event void BundleNumStream.appendDone(result_t res)
	{
		if (committing == FALSE)
			return;
		
		committing = FALSE;
		if (res == FAIL)
		{
			signal ICommitGPSData.nodeDone(node_in, node_out, ERR_USR);
			return;
		}
		//call InfoStore.versionIncrement();
		
		//call Leds.redToggle();
		call GpsStream.init(FALSE);
		signal ICommitGPSData.nodeDone(node_in, node_out, ERR_OK);
	}
  
	task void commitOwn()
	{
		result_t res;
		memcpy(&(thebundle.stream), &((*node_in)->stream), sizeof(stream_t));
		thebundle.turtle_num = TOS_LOCAL_ADDRESS;
		thebundle.bundle_num = __bundlenum;
		
		committing = TRUE;
		res = call MyIndex.AppendBundle(&thebundle);
		if (res == FAIL)
		{
			committing = FALSE;
			signal ICommitGPSData.nodeDone(node_in, node_out, ERR_USR);
			return;
		}
	}
  
	event void MyIndex.AppendDone(result_t res)
	{
		if (committing == FALSE)
			return;
		committing = FALSE;
		
		if (res == FAIL)
		{
			signal ICommitGPSData.nodeDone(node_in, node_out, ERR_USR);
			return;
		}
		post commitBNum();
	}
  
	/*
	IN:
		stream_t stream
	OUT:
	
	*/
	command result_t ICommitGPSData.nodeCall (CommitGPSData_in ** in,
											  CommitGPSData_out ** out)
	{
		result_t res;
		node_in = in;
		node_out = out;
	
		//call BundleNumStream.init(FALSE);
	//get bundle num
		call BundleNumStream.start_traversal(NULL);
		committing = TRUE;
		res = call BundleNumStream.next(&__bundlenum, &__length);
		if (res == FAIL)
		{
			committing = FALSE;
			if (__length == 0)
			{
			//a real error
				signal ICommitGPSData.nodeDone (in, out, ERR_USR);
				return FAIL;
			} else {
			//nothing there yet.
				__bundlenum = 0;
				post commitOwn();
			}
		}
	
	
    //signal ICommitGPSData.nodeDone (in, out, ERR_OK);
		return SUCCESS;
	}
  
	event void BundleNumStream.nextDone(result_t res)
	{
		if (committing == FALSE)
			return;
		
		committing = FALSE;
		if (res == FAIL)
		{
			signal ICommitGPSData.nodeDone(node_in, node_out, ERR_USR);
			return;
		}
		post commitOwn();
	}
  
	event void MyIndex.GetBundleDone(result_t res, bool valid)
	{
  
	}
	
	event void MyIndex.DeleteBundleDone(result_t res)
	{
	
	}
	
	event void GpsStream.appendDone(result_t res)
	{
	
	}
  
	event void GpsStream.nextDone(result_t res)
	{
  
	}
	
	event void MyIndex.loadDone(result_t res)
	{
		
	}
	
	event void MyIndex.saveDone(result_t res)
	{
	}

}
