
#include "sfaccess/tinystream.h"
#include "rt_intercomm.h"
#include "../mMarsh.h"


pthread_t icommthread;
bool icomm_abort = FALSE;
int icomm_cid = 0;

void *icomm_routine(void *arg)
{
	
	icomm_cid = tinystream_connect();
	
	if (icomm_cid == RELY_IDX_INVALID)
	{
		//error reporting
		return;	
	}
	
	while (!icomm_abort)
	{
		uint16_t nodeid;
		int err;
		err = unmarshall_start(icomm_cid, &nodeid);
		if (icomm_abort)
		{
			dbg(APP,"Abort\n");
			break;
		}
		if (err)
		{
			dbg(APP,"Marshalling error! Abort!\n");
			icomm_abort = TRUE;
			break;
		}
		//good nodeid --call appropriate unmarshaller
		err = UnmarshallByID(icomm_cid, nodeid);
		if (err)
		{
			dbg(APP,"Unmarshalling error on node(%i)! Abort!\n",nodeid);
			icomm_abort = TRUE;
		}
		
	}
	
	//tinystream_close();
	return;	
}


int intercomm_start(short port)
{
	int result;
	icomm_abort = FALSE;
	result = tinystream_init("localhost", port);
 	if (result < 0)
 	{
 		dbg(APP,"Could not open tinystream on port:%i\n",port);
 		return -1;	
 	}
	//spawn recv thread.
  	if(pthread_create(&icommthread, NULL, icomm_routine, NULL))
    	return -1;
    
    return 0;
}

int intercomm_stop()
{
	icomm_abort = TRUE;
	tinystream_close();
	pthread_join(icommthread, NULL);
	dbg(APP,"intercomm stopped...");
	return 0;
}
