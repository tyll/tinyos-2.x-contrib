#ifndef FLUXHANDLER_H_INCLUDED
#define FLUXHANDLER_H_INCLUDED


#include "rt_structs.h"
//#include "MemAlloc.h"


bool isReadyByID (EdgeIn * edge);
error_t callEdge (EdgeIn * e);
error_t adjustIntervals();
task void FinishRecoverTask();
error_t getOutSize (EdgeIn * e);
error_t handle_error (uint16_t nodeid, uint8_t * indata, uint8_t error);
uint16_t translateIDAll (EdgeIn * e, uint16_t * wt);
void *getInVar(uint16_t nodeid);
void *getOutVar(uint16_t nodeid);

error_t callError (
		uint16_t nodeid, 
		uint8_t * in,
		uint8_t error);
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



event void RTClockTimer.fired()
{
	atomic rt_clock++;
}

event void EvalTimer.fired()
{
	call IEval.reeval_energy_level();
}

event void IEval.reeval_done(uint8_t state, double grade)
{
	curstate = state;
	curgrade = grade;
	adjustIntervals();
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
	uint16_t delay;
	EdgeIn edge;
	//bool edgefailed;

	delay = FALSE;

	result = dequeue (&moteQ, &edge);
  
	if (result == TRUE)
	{
     	call PowerDisable(); //no power management in nodes
		result = callEdge(&edge);
		if (result == FAIL)
		{
			call PowerEnable();
			__release_node_lock (edge.node_id);
			handle_error (edge.node_id, edge.invar, ERR_NOMEMORY);
		}
	} //if

	
	atomic
	{
		if (isqueueempty (&moteQ))
		{
			localCAlive = FALSE;
		}
	}//atomic

	if (localCAlive == TRUE)
	{
		if (delay == TRUE)
		{
		  //delay execution a little bit
			call localQTimer.startOneShot(QUEUE_DELAY);
		}
		else
		{
			post LocalConsumerTask ();
		}			//else(delay)
	}//else(still alive)
    

}				//end LocalConsumerTask


event void localQTimer.fired ()
{
	if (!post LocalConsumerTask ())
	{
		call localQTimer.startOneShot(QUEUE_DELAY);
	}
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
	__rtstate.batt_reserve = BATTERY_CAPACITY/2;
	
	if (__rtstate.save_flag != 0xDEAD)
	{
		//no data to recover
		//assign defaults
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

event error_t PageEEPROM.readDone(error_t res)
{
	post FinishRecoverTask();
	return SUCCESS;
}

/*
	Runtime data recovery functions
*/
error_t recoverRunTimeData()
{
	
	
	
	save_retries = 0;
	__rtstate.save_flag = 0;
	//post ReadStateTask();
	post FinishRecoverTask();
	
	return SUCCESS;
}


event void RecoverTimer.fired ()
{
	recoverRunTimeData();
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

event void SaveTimer.fired ()
{
  	//Save runtime data
	__rtstate.save_flag = 0xDEAD;
	save_retries = 0;
	//post EraseTask();
	
}

event error_t PageEEPROM.writeDone(error_t res)
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

    event error_t PageEEPROM.flushDone(error_t res)
    {
        //We made it!  Yeah!

        return (SUCCESS);
    }

 	event error_t PageEEPROM.eraseDone(error_t res)
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

    event error_t PageEEPROM.syncDone(error_t result)
    {
        return (SUCCESS);
    }

    event error_t PageEEPROM.computeCrcDone(error_t result, uint16_t crc)
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
bool
		dolocalenqueue (EdgeQueue * q, EdgeIn edge)
{
	bool result;

	queue_ptr = q;
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
	event error_t SendMsg.sendDone(TOS_MsgPtr msg, error_t success)
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

error_t handle_exit (uint16_t nodeid, uint8_t*  data)
{
	error_t res;
	GenericNode *ndata = (GenericNode *) data;

	__release_node_lock(nodeid);
	
	res = call IEnergyMap.endPath(ndata->_pdata.sessionID, ndata->_pdata.weight);	

	return SUCCESS;
}

event void IEnergyMap.pathEnergy(uint16_t path, uint32_t energy, bool micro)
{
	//report path completion
	//energy is in 100 uJ <or> 0.1 mJ
	
	call IEval.reportPathDone(path, curstate, energy);
	
	signal IPathDone.done(path, energy, __rtstate.prob[path], __rtstate.srcprob[pathSrc[path]]);
	
}

event error_t DummyPathDone.done(uint16_t pathid, uint32_t cost, uint8_t prob, uint8_t srcprob)
{
	return SUCCESS;
}


error_t
		handle_error (uint16_t nodeid, uint8_t * indata, uint8_t error)
{

  //add weight
	GenericNode *ndata = (GenericNode *) indata;


	ndata->_pdata.weight += getErrorWeight (nodeid);

	/*if (error == ERR_NOMEMORY)
	{
      
	}
	if (error == ERR_QUEUE)
	{
      
	}*/


  //call the correct error handler
	return callError (nodeid, indata, error);
}


//CODE FOR HANDLING EDGES BETWEEN NODES
error_t
		handle_edge (uint16_t oldid, uint16_t nodeid,
					 uint8_t* outdata, bool local, uint16_t edgewt)
{
	EdgeIn newedge, oldedge;
	uint16_t wt;
  	uint16_t dest;
  	
 
	atomic {
		__release_node_lock (oldid);
		newedge.node_id = nodeid;
		//temporarily point to this for type-checking
		((GenericNode *)outdata)->_pdata.weight += edgewt;
		newedge.invar = outdata;
		dest = translateIDAll (&newedge, &wt);
		newedge.node_id = dest;
		((GenericNode *)outdata)->_pdata.weight += wt;
		
		if (__try_node_lock (dest) == TRUE)
		{
			//got the lock
			newedge.invar = getInVar(newedge.node_id);
			newedge.outvar = getOutVar(newedge.node_id);
			
			oldedge.node_id = oldid;
			memcpy(newedge.invar, outdata, getOutSize(&oldedge));
			
			//((GenericNode *)newedge.invar)->_pdata.weight += (edgewt + wt);
			((GenericNode *)newedge.outvar)->_pdata.weight = ((GenericNode *)newedge.invar)->_pdata.weight;
			((GenericNode *)newedge.outvar)->_pdata.sessionID = ((GenericNode *)newedge.invar)->_pdata.sessionID;
			((GenericNode *)newedge.outvar)->_pdata.minstate = ((GenericNode *)newedge.invar)->_pdata.minstate;
		
			
		
			if (!dolocalenqueue (&moteQ, newedge))
			{
				__release_node_lock (dest);
    		 	//queue is full
				return handle_error (dest, newedge.invar, ERR_QUEUE);
			}
		} else {
			
			return handle_error (dest, outdata, ERR_USR);
		}	
		
		
	} //atomic

	return SUCCESS;
}


//CODE FOR HANDLING EDGES FROM SOURCES TO NODES
error_t
		handle_src_edge (uint16_t oldid, uint16_t nodeid,
						 uint8_t* outdata,
						 uint16_t session, bool local, uint16_t edgewt)
{

	EdgeIn newedge, oldedge;
	uint16_t wt;
	uint16_t dest;


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
}

#endif
