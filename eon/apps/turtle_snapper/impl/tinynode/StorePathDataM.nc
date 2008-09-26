includes structs;

module StorePathDataM
{
	provides
	{
		interface StdControl;
		interface IStorePathData;
	}
	uses 
	{
		interface BitVec;
		command uint16_t getNextSeq();
		interface IPathDone;
		
	}
}
implementation
{
#include "fluxconst.h"

StorePathData_in *node_in;
StorePathData_out *node_out;


typedef struct pathdata {
	bool valid;
	uint16_t pathid;
	uint16_t count;
	uint32_t cost;
	uint8_t prob;
	uint8_t srcprob;
} pathdata_t;

#define CACHE_SIZE 15
pathdata_t pathcache[CACHE_SIZE];
int cacheidx;
uint16_t pathidx;
uint8_t thepath;
pathdata_t pathbuf;

task void prepPath();


void clearCache()
{
	int i;
	
	pathidx = 0;
	for (i=0; i < CACHE_SIZE; i++)
	{
		pathcache[i].valid = FALSE;
	}
	
}


	command result_t StdControl.init ()
	{
		
		clearCache();
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
	
	task void processPathDone()
	{
		int i;
		int freeidx = -1;
		
		for (i=0; i < CACHE_SIZE; i++)
		{
			if (pathcache[i].valid == FALSE && freeidx == -1)
			{
				freeidx = i;
			}
			if (pathcache[i].valid == TRUE && pathcache[i].pathid == pathbuf.pathid)
			{
				pathcache[i].count++;
				pathcache[i].cost = pathbuf.cost;
				pathcache[i].prob = pathbuf.prob;
				pathcache[i].srcprob = pathbuf.srcprob;
				pathbuf.valid = 0;
				return;
			}
		}
		if (freeidx == -1)
		{
			//sorry, no room
			pathbuf.valid = 0;
			return;
		}
		pathcache[freeidx].valid = TRUE;
		pathcache[freeidx].pathid = pathbuf.pathid;
		pathcache[freeidx].count=1;
		pathcache[freeidx].cost = pathbuf.cost;
		pathcache[freeidx].prob = pathbuf.prob;
		pathcache[freeidx].srcprob = pathbuf.srcprob;
				
		
		pathbuf.valid = 0;
		return;
	}

	bool getNextPath()
	{
		int startidx = pathidx;
		
		while (TRUE)
		{
			if (pathidx <= 0)
			{
				pathidx = CACHE_SIZE;
			} else {
				pathidx--;
			}
			if (pathidx == startidx)
			{
				return FALSE;
			}
			
			if (pathcache[pathidx].valid == TRUE)
			{
				cacheidx = pathidx;
				return TRUE;
			}
		}
		return FALSE;
	}	
	
	
	event result_t IPathDone.done(uint16_t pathid, uint32_t cost, uint8_t prob, uint8_t srcprob)
	{
		if (pathbuf.valid == 1)
		{
			return SUCCESS;
		}
		
		
		
		pathbuf.valid = 1;
		
		
		pathbuf.pathid = pathid;
		pathbuf.cost = cost;
		pathbuf.prob = prob;
		pathbuf.srcprob = srcprob;
			
		post processPathDone();
		return SUCCESS;
	}	
	
	 /*
	IN:
		GpsData_t data - the gps reading that was taken
	OUT:
		nothing
	 */
	
	command result_t IStorePathData.nodeCall (StorePathData_in * in,
											   StorePathData_out * out)
	{
		
		
		node_in = in;
		node_out = out;

		
		if (!getNextPath())
		{
			signal IStorePathData.nodeDone(in, out, ERR_USR);
		} else {
		
			post prepPath();
		}
		
		return SUCCESS;
	}
  
	
	
	
	task void prepPath()
	{
		uint8_t *__writebuf;
		uint16_t seq;
		
		seq = call getNextSeq();
		__writebuf = node_out->chunkarr.chunks[0].data;
				
		 //pack data into __writebuf
		 //header first
		 __writebuf[0] = TOS_LOCAL_ADDRESS;
		 __writebuf[1] = ((booted ? 1 : 0) << 7) | BTYPE_RTPATH;
		 memcpy(__writebuf+2, &seq, sizeof(seq));
		 memcpy(__writebuf+4, &rt_clock, sizeof(rt_clock));
		 //call BitVec.set16((uint16_t*)(__writebuf+4), TOS_LOCAL_ADDRESS, TRUE);
		//data
		 
		memcpy(__writebuf+8, &pathcache[cacheidx].pathid, 2);
		memcpy(__writebuf+10, &pathcache[cacheidx].count, 2);
		memcpy(__writebuf+12, &pathcache[cacheidx].cost, 4);
		__writebuf[16] = pathcache[cacheidx].prob;
		__writebuf[17] = pathcache[cacheidx].srcprob;
		//16 bytes
		
		pathcache[cacheidx].valid = FALSE;
		node_out->chunkarr.chunks[0].length = 18; //better be less than 28
		node_out->chunkarr.num = 1;
		
		
		signal IStorePathData.nodeDone(node_in, node_out, ERR_OK);
		
		
	}
  
	
	
}
