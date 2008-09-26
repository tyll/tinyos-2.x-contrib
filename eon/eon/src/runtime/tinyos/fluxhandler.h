#ifndef FLUXHANDLER_H_INCLUDED
#define FLUXHANDLER_H_INCLUDED


#include "rt_structs.h"
//#include "MemAlloc.h"



result_t callEdge (uint16_t dest, void *invar, void *outvar);
result_t adjustIntervals();
task void FinishRecoverTask();
int16_t getOutSize (uint16_t nodeid);
result_t handle_error (uint16_t nodeid, uint8_t error);
uint16_t translateIDAll (EdgeIn * e, uint16_t * wt);
void *getInVar(uint16_t nodeid);
void *getOutVar(uint16_t nodeid);
bool *getOutValid(uint16_t nodeid);
void *getOutQueue(uint16_t nodeid, uint8_t slot);
rt_data *getRTData(uint16_t nodeid);
int16_t getSrcWeight(uint16_t srcid);
bool dolocalenqueue (EdgeQueue * q, EdgeIn edge);
uint16_t getNextSession ();

result_t callError (uint16_t nodeid,uint8_t error);
uint16_t getErrorWeight (uint16_t nodeid);
//void factorSGDC (uint8_t state, bool awake);
bool islocal (uint16_t nodeid);
//bool doremoteenqueue (EdgeQueue * q, EdgeIn edge);
//task void RemoteConsumerTask ();
//task void SleepTask();

//global variables

/*enum {
	ASLEEP =0, 
	SLEEPY =1, 
	AWAKE  =3,
	WAKING =4,
};
int remoteCstate = ASLEEP;
	*/

bool __get_bit_lock_value(uint16_t node_id)
{
	int byte_idx, bit_idx;
	byte_idx = node_id / 8;
	bit_idx = node_id % 8;
	
	return ((__node_locks[byte_idx] >> bit_idx) & 0x01);
}


bool __set_bit_lock_value(uint16_t node_id, bool value)
{
	int byte_idx, bit_idx;
	uint8_t mask;
	
	byte_idx = node_id / 8;
	bit_idx = node_id % 8;
	
	
	mask = (0x01 << bit_idx);
	
	if (value)
	{
		__node_locks[byte_idx] = (__node_locks[byte_idx] | mask);
	} else {
		__node_locks[byte_idx] = (__node_locks[byte_idx] & (~mask));
	}
	return value;
}

bool __try_node_lock(uint16_t node_id)
{
	bool set = FALSE;
	
	atomic {
		if (__get_bit_lock_value(node_id) == FALSE)
		{
			__set_bit_lock_value(node_id,TRUE);
			set = TRUE;
		}
	} //atomic
	return set;
}

bool __release_node_lock(uint16_t node_id)
{
	atomic {
		__set_bit_lock_value(node_id, FALSE);
	}
	return TRUE;
}


event result_t RTClockTimer.fired()
{
	rt_clock += RTCLOCKSEC;
	
	__rtstate.clock = rt_clock;
	/*if (rt_clock > (60L * 10L))
	{
		booted = FALSE;
	}*/
	return SUCCESS;
}

event result_t EvalTimer.fired()
{
	call IEval.reeval_energy_level();
	return SUCCESS;
}

event result_t IEval.reeval_done(uint8_t state, double grade)
{
	curstate = state;
	curgrade = grade;
	adjustIntervals();
	return SUCCESS;
}


/************************************
 *
 * EDGE Consumer/Producer functions
 *
 ************************************/


task void
		LocalConsumerTask ()
{
	
	uint16_t result;
	uint16_t realdest;
	uint16_t realweight;
	
	uint16_t delay;
	EdgeIn edge;
	rt_data *src_data = NULL, *dst_data;
	void *soutvar, *dinvar, *doutvar;
	
	delay = FALSE;

	result = dequeue (&moteQ, &edge);
	
  	
	
	if (result == FALSE)
	{
		localCAlive = FALSE;
		return;
	}
	
	
	
	//translate the edge
	realdest = translateIDAll (&edge, &realweight);
	if (realdest == NO_NODEID)
	{
		//translation error
		
		handle_error(edge.src_id, ERR_TRANSLATE);
		return;
	}
	
	
	//check to see if it can be advanced to its destination?
	if (!__try_node_lock(realdest))
	{
		
		//put it back on the queue
		if (!dolocalenqueue (&moteQ, edge))
		{
			//signal a full queue (drop the flow);
			if (edge.src)
			{
				getOutValid(edge.src_id)[edge.idx] = FALSE;
			}
			handle_error(edge.src_id, ERR_QUEUE);
		}
		localCAlive = TRUE;
		call localQTimer.start (TIMER_ONE_SHOT, QUEUE_DELAY);
		return;
	}
	
	//we have the lock
	
	//get the runtime data
	if (edge.src == FALSE)
	{
		src_data = getRTData(edge.src_id);
	}
	dst_data = getRTData(realdest);
	
	
	
	if ((edge.src == FALSE && src_data == NULL) || dst_data == NULL)
	{
		//runtime system/compiler bug.
		//very bad.
		
		__release_node_lock(realdest);
		if (edge.src)
		{
			getOutValid(edge.src_id)[edge.idx] = FALSE;
		}
		handle_error(edge.src_id, ERR_RTDATA);
		localCAlive = TRUE;
		call localQTimer.start (TIMER_ONE_SHOT, QUEUE_DELAY);
		return;
	}
	
	
	
	if (edge.src == FALSE)
	{
		//copy runtime data along
		memcpy(dst_data, src_data, sizeof(rt_data));
	} else {
		//initialize runtime data
		dst_data->sessionID = getNextSession();
		dst_data->weight = getSrcWeight(edge.src_id);
		dst_data->minstate = STATE_BASE;
		call IEnergyMap.startPath(dst_data->sessionID);
	}
	//increment the weight according to the translation
	dst_data->weight += realweight;
	
	//copy the source "out" to the dest "in"
	if (edge.src)
	{
		soutvar = getOutQueue(edge.src_id, edge.idx);
	} else {
		soutvar = getOutVar(edge.src_id);
	}
	dinvar = getInVar(realdest);
	doutvar = getOutVar(realdest);
	memcpy(dinvar, soutvar, getOutSize(edge.src_id));
	
	if (edge.src)
	{
		//free up the previously occupied slot
		getOutValid(edge.src_id)[edge.idx] = FALSE;
	}
	
	//release the src lock
	__release_node_lock(edge.src_id);
	
	
	//NOW WE ACTUALLY CALL THE NODE
	call PowerDisable(); //no power management in nodes
	result = callEdge(realdest, dinvar, doutvar);
	if (result != SUCCESS)
	{
		
		call PowerEnable();
		handle_error (realdest, result);
	} //if

	
	if (isqueueempty (&moteQ))
	{
		localCAlive = FALSE;
	} else {
		post LocalConsumerTask ();
	}
	
}	//end LocalConsumerTask


event result_t localQTimer.fired ()
{
	if (!post LocalConsumerTask ())
	{
		call localQTimer.start (TIMER_ONE_SHOT, QUEUE_DELAY);
	}
	return SUCCESS;
}


bool check_retry()
{
	save_retries++;
	if (save_retries > MAX_SAVE_RET)
	{
		return FALSE;
	} else {
		return TRUE;
	}
}



task void ReadStateTask()
{
	if (call PageEEPROM.read(SAVE_PAGE, 0, &__rtstate, sizeof(__runtime_state_t)) != SUCCESS)
	{
		if (check_retry())	
		{
			post ReadStateTask();
		} else {
			post FinishRecoverTask();
		}
	}
}

task void FinishRecoverTask()
{
	
	int i;
	int j=0;
  	int numpaths = 0;
	
	
	//initial capacity assumption.
	//if recovering from a dead spell, this will be
	//detected and corrected in SrcAccumM.nc
	
	
	if (__rtstate.save_flag != 0xDEAD)
	{
		//no data to recover
		//assign defaults
		__rtstate.batt_reserve = BATTERY_CAPACITY/2;
		
		__rtstate.load_avg = 0.0;
		
  		//initialize sources and paths
  		for (j=0; j < NUMSOURCES; j++)
  		{
  			numpaths = 0;
  			for (i=0; i < NUMPATHS; i++)
  			{
  				if (read_pgm_int8((int8_t*)&pathSrc[i]) == j) numpaths++;
  			}
  			for (i=0; i < NUMPATHS; i++)
  			{
  				if (read_pgm_int8((int8_t*)&pathSrc[i]) == j)
				{
					__rtstate.prob[i] = (100 / numpaths);
					__rtstate.pc[i] = 0;
				}
  			}
			__rtstate.srcprob[j] = 0;
			__rtstate.spc[j] = 0;
  		}
  		//initialize path energy	
  		for (i=0; i < NUMPATHS; i++)
  		{
  			__rtstate.pathenergy[i] = -1;
  		}
		
		
		
			
		
	}
}

event result_t PageEEPROM.readDone(result_t res)
{
	if (res == SUCCESS)
	{
		rt_clock = __rtstate.clock + RT_SAVE_SEC;
	}
	post FinishRecoverTask();
	return SUCCESS;
}

/*
	Runtime data recovery functions
*/
result_t recoverRunTimeData()
{
	
	
	
	save_retries = 0;
	__rtstate.save_flag = 0;
	post ReadStateTask();
	//post FinishRecoverTask();
	
	return SUCCESS;
}


event result_t RecoverTimer.fired ()
{
	recoverRunTimeData();
	return SUCCESS;
}


task void FlushPageTask()
{
	
	if (call PageEEPROM.flush(SAVE_PAGE) != SUCCESS)
	{
		if (check_retry())	post FlushPageTask();
	}
}

task void SaveTask()
{
	if (call PageEEPROM.write(SAVE_PAGE, 0, &__rtstate, sizeof(__runtime_state_t)) != SUCCESS)
	{
		if (check_retry())	post SaveTask();
	}
}

task void EraseTask()
{
	if (call PageEEPROM.erase(SAVE_PAGE, TOS_EEPROM_ERASE) != SUCCESS)
	{
		if (check_retry()) post EraseTask();
	}
}

event result_t SaveTimer.fired ()
{
  	//Save runtime data
	__rtstate.save_flag = 0xDEAD;
	save_retries = 0;
	//post EraseTask();
	return SUCCESS;
}

event result_t PageEEPROM.writeDone(result_t res)
    {
        if (res == SUCCESS)
        {
        	save_retries = 0;    
			post FlushPageTask();
        }
        else if (check_retry())
        {
            post SaveTask();
        }

        return (SUCCESS);
    }

    event result_t PageEEPROM.flushDone(result_t res)
    {
        //We made it!  Yeah!

        return (SUCCESS);
    }

 	event result_t PageEEPROM.eraseDone(result_t res)
    {
		if (res == SUCCESS)
		{
			post SaveTask();
		} else if (check_retry())
		{
			post EraseTask();
		}
        return (SUCCESS);
    }

    event result_t PageEEPROM.syncDone(result_t result)
    {
        return (SUCCESS);
    }

    event result_t PageEEPROM.computeCrcDone(result_t result, uint16_t crc)
    {
        return (SUCCESS);
    }


bool
		isFunctionalState (uint8_t state)
{
	return (curstate <= state);
}

/*********************************
 * A wrapper for enqueue to manage
 * the posting of consumer tasks
 ********************************/
bool dolocalenqueue (EdgeQueue * q, EdgeIn edge)
{
	bool result;

	queue_ptr = q;
	//TODO: figure out if this is necessary.
	atomic
	{
		result = enqueue (q, edge);

		if (result && localCAlive == FALSE)
		{
			localCAlive = TRUE;
			post LocalConsumerTask ();
		}
	}				//atomic
	return result;

}

#ifdef RUNTIME_TEST
	event result_t SendMsg.sendDone(TOS_MsgPtr msg, result_t success)
	{
		
		return SUCCESS;
	}

#endif

/********************************
 * AUX functions
 ********************************/

uint16_t
		getNextSession ()
{
	uint16_t nextid;
	atomic
	{
		nextid = session_id;
		session_id++;
	}
	return nextid;
}

result_t handle_exit (uint16_t nodeid)
{
	result_t res;
	rt_data *pdata = getRTData(nodeid);

	
	__release_node_lock(nodeid);
	
	res = call IEnergyMap.endPath(pdata->sessionID, pdata->weight);	

	return SUCCESS;
}

event void IEnergyMap.pathEnergy(uint16_t path, uint32_t energy, bool micro)
{
	//report path completion
	//energy is in 100 uJ <or> 0.1 mJ
	
	call IEval.reportPathDone(path, curstate, energy);
	
	signal IPathDone.done(path, energy, __rtstate.prob[path], __rtstate.srcprob[pathSrc[path]]);
	
}

event result_t DummyPathDone.done(uint16_t pathid, uint32_t cost, uint8_t prob, uint8_t srcprob)
{
	return SUCCESS;
}


result_t
		handle_error (uint16_t nodeid, uint8_t error)
{

  //add weight
  	rt_data *pdata = getRTData(nodeid);

	pdata->weight += getErrorWeight (nodeid);

	/*if (error == ERR_NOMEMORY)
	{
      
	}
	if (error == ERR_QUEUE)
	{
      
	}*/


  //call the correct error handler
	return callError (nodeid, error);
}


//CODE FOR HANDLING EDGES BETWEEN NODES


result_t handle_edge (uint16_t srcid, uint16_t dstid, uint16_t edgewt)
{
	EdgeIn newedge;
	rt_data *pdata;
	
	newedge.src_id = srcid;
	newedge.dst_id = dstid;
	newedge.src = FALSE; //mark it as not coming from a source
	pdata = getRTData(srcid);
	if (pdata == NULL)
	{
		
		return handle_error(srcid, ERR_SRC);
	}
	//add this edges weight---further translation will come when it is advanced to the next edge
	pdata->weight += edgewt;
	
	
	if (!dolocalenqueue (&moteQ, newedge))
	{
		//signal a full queue (drop the flow);
		
		handle_error(srcid, ERR_QUEUE);
		return FAIL;
	}
	
	
	return SUCCESS;	
}
 	


//CODE FOR HANDLING EDGES FROM SOURCES TO NODES

result_t handle_src_edge (uint16_t srcid, uint16_t dstid)
{

	EdgeIn newedge;
	bool *out_valid;
	int i, slot = -1;
	void *outbuf, *queuebuf;
	
	//see if there is an open queue slot
	out_valid = getOutValid(srcid);
	atomic
	{
		for (i=0; i <  SRC_QUEUE_SIZE; i++)
		{
			if (out_valid[i] == FALSE)
			{
				out_valid[i] = TRUE;
				slot = i;
				break;
			}
		}	
	}//atomic
	
	if (slot == -1)
	{
		//queue full
		
		return FAIL;
	}
	
	//copy data into queue
	outbuf = getOutVar(srcid);
	queuebuf = getOutQueue(srcid,slot);
	memcpy(queuebuf, outbuf, getOutSize(srcid));
	
	//put it on the scheduling queue
	newedge.src_id = srcid;
	newedge.dst_id = dstid;
	newedge.src = TRUE; //mark it as coming from a source
	newedge.idx = slot;
	
	
	
	if (!dolocalenqueue (&moteQ, newedge))
	{
		//signal a full queue (drop the flow);
		handle_error(srcid, ERR_QUEUE);
		
		return FAIL;
	}
	return SUCCESS;


}

/*
	atomic
	{
		newedge.node_id = nodeid;
		dest = translateIDAll (&newedge, &wt);
		newedge.node_id = dest;
 		
		if (__try_node_lock(newedge.node_id) == TRUE)
		{
			//got the lock
			newedge.invar = getInVar(newedge.node_id);
			newedge.outvar = getOutVar(newedge.node_id);
			oldedge.node_id = oldid;
			memcpy(newedge.invar, outdata, getOutSize(&oldedge));
			
			((GenericNode *)newedge.invar)->_pdata.sessionID = session;
			((GenericNode *)newedge.invar)->_pdata.weight += (edgewt + wt);
			((GenericNode *)newedge.invar)->_pdata.minstate = STATE_BASE;
			//memcpy(&newedge.outvar, newedge.invar, sizeof(rt_data));
			((GenericNode *)newedge.outvar)->_pdata.sessionID = session;
			((GenericNode *)newedge.outvar)->_pdata.weight = ((GenericNode *)newedge.invar)->_pdata.weight;
			((GenericNode *)newedge.outvar)->_pdata.minstate = ((GenericNode *)newedge.invar)->_pdata.minstate;
				
			
			if (!dolocalenqueue (&moteQ, newedge))
			{
				__release_node_lock (dest);
    		 	//queue is full
				return handle_error (dest, newedge.invar, ERR_QUEUE);
			}
			
			call IEnergyMap.startPath(session);
		}
	} //atomic	
	return SUCCESS;
	*/

#endif
