includes structs;

module CompressRTDataM
{
	provides
	{
		interface StdControl;
		interface ICompressRTData;
	}
	uses
	{
		interface BundleIndex as MyIndex;
		interface Stream as BundleNumStream;
		interface Leds;
	}
}
implementation
{
#include "fluxconst.h"

/*
enum
{
	E_B_NUM = 0xA,
	E_OTHERS = 0xB,
	E_OWN = 0xC
	
};
*/
CompressRTData_in ** node_in;
CompressRTData_out ** node_out;

uint32_t __bundlenum;
datalen_t __length;

Bundle_t rt_data_bundle;

bool committing;

	command result_t StdControl.init ()
	{
		__bundlenum = 0;
		call Leds.init();
		committing = FALSE;
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
	
	command bool ICompressRTData.ready ()
	{
	//PUT READY IMPLEMENTATION HERE
	
		return TRUE;
	}
	
	///////////////////////////////////////////////////////////////////////////////////////////////
	// TASK 'S 
	///////////////////////////////////////////////////////////////////////////////////////////////
	task void commitBNum()
	{
		result_t res;
		//last_sp_call = E_B_NUM;
		call BundleNumStream.init(FALSE);
		__bundlenum++;
		
		committing = TRUE;
		res = call BundleNumStream.append(&__bundlenum, sizeof(uint32_t), NULL);
		if (res == FAIL)
		{
			committing = FALSE;
			signal ICompressRTData.nodeDone(node_in, node_out, ERR_USR);
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
			//call Leds.redToggle();	
			signal ICompressRTData.nodeDone(node_in, node_out, ERR_USR);
			return;
		}
		//call InfoStore.versionIncrement();
		clearConnnectionInformation();
		
		//call Leds.redToggle();
		//last_sp_call = 0xF;
		signal ICompressRTData.nodeDone(node_in, node_out, ERR_OK);
	}

	task void commitOwn()
	{
		result_t res;
		//last_sp_call = E_OWN;
		memcpy(&(rt_data_bundle.stream), &g_rt_stream, sizeof(stream_t));
		rt_data_bundle.turtle_num = TOS_LOCAL_ADDRESS;
		rt_data_bundle.bundle_num = __bundlenum;
		
		
		committing = TRUE;
		//append_succ = FALSE;
		//append_done_succ = FALSE;
		res = call MyIndex.AppendBundle(&rt_data_bundle);
		if (res == FAIL)
		{
			committing = FALSE;
			//call Leds.redToggle();
			signal ICompressRTData.nodeDone(node_in, node_out, ERR_USR);
			return;
		}
		//append_succ = TRUE;
	}
  
	event void MyIndex.AppendDone(result_t res)
	{
		if (committing == FALSE)
			return;
		committing = FALSE;
		
		/*
		if (append_succ == TRUE && res == SUCCESS)
			append_done_succ = TRUE;
		
		else
			append_done_succ = 3;
		*/
		if (res == FAIL)
		{
			signal ICompressRTData.nodeDone(node_in, node_out, ERR_USR);
			return;
		}
		post commitBNum();
	}
	
	///////////////////////////////////////////////////////////////////////////////////////////////
	// ICompressRTData
	///////////////////////////////////////////////////////////////////////////////////////////////
	command result_t ICompressRTData.nodeCall (CompressRTData_in ** in,
							CompressRTData_out ** out)
	{
		//PUT NODE IMPLEMENTATION HERE
		result_t res;
		node_in = in;
		node_out = out;
		
		
		//last_sp_call = -1;
		//call Leds.redToggles();
		call BundleNumStream.start_traversal(NULL);
		committing = TRUE;
		res = call BundleNumStream.next(&__bundlenum, &__length); 
		if ( res  == FAIL )
		{
			committing = FALSE;
			if (__length == 0)
			{
			//a real error
				signal ICompressRTData.nodeDone (in, out, ERR_USR);
				return FAIL;
			}
			else 
			{
				//nothing there yet.
				//call Leds.redToggle();
				__bundlenum = 0;
				post commitOwn();
			}
		}
		
		//TODO: clearConnnectionInformation();
		//Done signal can be moved if node makes split phase calls.
		//signal ICompressRTData.nodeDone (in, out, ERR_OK);
		return SUCCESS;
	}
	
	
	///////////////////////////////////////////////////////////////////////////////////////////////
	// Some EVENTS
	///////////////////////////////////////////////////////////////////////////////////////////////
	event void BundleNumStream.nextDone(result_t res)
	{
		if ( committing == FALSE )
			return;
		
		committing = FALSE;
		if ( res == FAIL )
		{
			signal ICompressRTData.nodeDone(node_in, node_out, ERR_USR);
			return;
		}
		post commitOwn();
	}
	
	///////////////////////////////////////////////////////////////////////////////////////////////
	// Un-Used EVENTS
	///////////////////////////////////////////////////////////////////////////////////////////////
	event void MyIndex.GetBundleDone(result_t res, bool valid)
	{
  
	}
	
	event void MyIndex.DeleteBundleDone(result_t res)
	{
	
	}
	
	event void MyIndex.loadDone(result_t res)
	{
	
	}
	
	event void MyIndex.saveDone(result_t res)
	{
	}

}
