#ifndef FLUXHANDLER_H_INCLUDED
#define FLUXHANDLER_H_INCLUDED


//#include "rt_structs.h"
#include "MemAlloc.h"


//bool isReadyByID (EdgeIn * edge);
//result_t callEdge (EdgeIn * e);
//result_t adjustIntervals();
task void FinishRecoverTask();
//result_t getOutSize (EdgeIn * e);
result_t handle_error (uint16_t nodeid, Handle indata, uint8_t error);

/*result_t callError (
		uint16_t nodeid, 
		Handle in,
		uint8_t error);
		*/
//uint16_t getErrorWeight (uint16_t nodeid);
//void factorSGDC (uint8_t state, bool awake);
//bool islocal (uint16_t nodeid);
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
	atomic rt_clock++;
	return SUCCESS;
}

event result_t EvalTimer.fired()
{
	call IEval.reeval_energy_level();
	return SUCCESS;
}

event result_t SGSleepTimer.fired()
{

	TOSH_CLR_INT0_PIN();
	return SUCCESS;	
}

event result_t SGStatusTimer.fired()
{
	return SUCCESS;	
}

event result_t SGStateTimer.fired()
{
	int intgrade;

	intgrade = (int)(curgrade * 100);
	__rt_send_buf.data[0] = curstate;
	__rt_send_buf.data[1] = intgrade;
	if (call StateSend.send(TOS_UART_ADDR, 2, &__rt_send_buf ) != SUCCESS)
	{
		call Leds.redToggle();
	}
	return SUCCESS;	
}

event result_t SGCardTimer.fired()
{

	TOSH_SET_INT0_PIN();
	return SUCCESS;	
}

event result_t StateSend.sendDone(TOS_MsgPtr msg, result_t success)
{
		return SUCCESS;
}

event TOS_MsgPtr PathRecv.receive (TOS_MsgPtr msg)
{
	result_t res;
	int32_t penergy;
	bool start = msg->data[0];
	int id = msg->data[1];
	int path = msg->data[2];
	
	if (start)
	{
		//starting a flow	
		call IEnergyMap.startPath(id);
	} else {
		//ending a flow
		res = call IEnergyMap.getPathEnergy(id, &penergy);		
		
		call IEval.reportPathDone(path, curstate, penergy);
	}
	
	return msg;
}

event TOS_MsgPtr SleepRecv.receive (TOS_MsgPtr msg)
{
	call SGCardTimer.start(TIMER_REPEAT, (2L * 1024L));
	call SGSleepTimer.start(TIMER_REPEAT, (25L * 1024L));
	call SGStateTimer.start(TIMER_REPEAT, (34L * 1024L));
	
	return msg;
}



event result_t IEval.reeval_done(uint8_t state, double grade)
{
	curstate = state;
	curgrade = grade;
	//adjustIntervals();
	return SUCCESS;
}


/************************************
 *
 * EDGE Consumer/Producer functions
 *
 ************************************/

/*
task void
		LocalConsumerTask ()
{
  
	uint16_t result;
	uint16_t delay, ready;
	uint16_t outsize;
	EdgeIn edge;
	bool edgefailed;

	delay = FALSE;

	result = dequeue (&moteQ, &edge);
  
	if (result == TRUE)
	{
     //Got an edge
     //is it ready
		ready = isReadyByID (&edge);

		
		if (!ready)
		{
			//not ready, put it to the back of the queue
			//deadlocked_edge_id = edge.node_id;
			//drop the flow.
			if (call BAlloc.free((Handle)edge.invar) == FAIL)
			{
			
				call Leds.redToggle();	
			}
			//call BAlloc.free((Handle)edge.outvar);
			//should probably do some error handling here
			
		} 
		else 
		{
			edgefailed = FALSE;
  			outsize = getOutSize (&edge);
  			if (outsize == 0)
			{
    			edgefailed = TRUE;
			} else {
  				result = call BAlloc.allocate ((HandlePtr) &(edge.outvar), outsize);
  				if (result == FAIL)
    			{
					edgefailed = TRUE;
    			}
			}
			if (edgefailed)
			{
				__release_node_lock (edge.node_id);
				handle_error (edge.node_id, (Handle) edge.invar, ERR_NOMEMORY);
				
				
			} else {
				call PowerDisable(); //no power management in nodes
				result = callEdge(&edge);
				if (result == FAIL)
				{
					call PowerEnable();
					__release_node_lock (edge.node_id);
					call BAlloc.free((Handle)edge.outvar);
					handle_error (edge.node_id, (Handle) edge.invar, ERR_NOMEMORY);
					
				}
			}
		} //if
	    	
	} //if islocal

	
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
			call localQTimer.start (TIMER_ONE_SHOT, QUEUE_DELAY);
		}
		else
		{
			post LocalConsumerTask ();
		}			//else(delay)
	}//else(still alive)
    

}				//end LocalConsumerTask
*/

event result_t localQTimer.fired ()
{
	/*if (!post LocalConsumerTask ())
	{
		call localQTimer.start (TIMER_ONE_SHOT, QUEUE_DELAY);
	}*/
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
	
	
	__rtstate.batt_reserve = BATTERY_CAPACITY/2;
	if (__rtstate.save_flag != 0xDEAD)
	{
		__rtstate.batt_reserve = 0;
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
				}
  			}
			__rtstate.srcprob[j] = 0;
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
	post FinishRecoverTask();
	return SUCCESS;
}

/*
	Runtime data recovery functions
*/
result_t recoverRunTimeData()
{
	
	
	//Restore runtime data
	/*call IFlash.read((void*)IFLASH_SRCPROB_ADDR, srcprob, sizeof(srcprob));
	call IFlash.read((void*)IFLASH_PATHPROB_ADDR, prob, sizeof(prob));
	call IFlash.read((void*)IFLASH_PATHENERGY_ADDR, pathenergy, sizeof(pathenergy));
	call IFlash.read((void*)IFLASH_HISTORYIDX_ADDR, &load_history_index, sizeof(load_history_index));
	call IFlash.read((void*)IFLASH_LOADHISTORY_ADDR, load_history, sizeof(load_history));
	call IFlash.read((void*)IFLASH_BATTERY_ADDR, &batt_reserve, sizeof(batt_reserve));*/
	save_retries = 0;
	post ReadStateTask();
	
	
	return SUCCESS;
}


event result_t RecoverTimer.fired ()
{
	recoverRunTimeData();
	return SUCCESS;
}



/*task void SaveSrcProbTask()
{
	save_state = STATE_SRC_PROB;
	if (PageEEPROM.write(SAVE_PAGE, IFLASH_SRCPROB_ADDR, srcprob, sizeof(srcprob)) != SUCCESS)
	{
		if (check_retry())	post SaveSrcProbTask();
		
	}
}

task void SaveProbTask()
{
	save_state = STATE_PROB;
	if (PageEEPROM.write(SAVE_PAGE, IFLASH_PATHPROB_ADDR, prob, sizeof(prob)) != SUCCESS)
	{
		if (check_retry())	post SaveProbTask();
	}
}

task void SavePathEnergyTask()
{
	save_state = STATE_PATH_ENERGY;
	if (PageEEPROM.write(SAVE_PAGE, IFLASH_PATHENERGY_ADDR, pathenergy, sizeof(pathenergy)) != SUCCESS)
	{
		if (check_retry())	post SavePathEnergyTask();
	}
}

task void SaveLoadIdxTask()
{	
	save_state = STATE_LOAD_IDX;
	if (PageEEPROM.write(SAVE_PAGE, IFLASH_LOADHISTORYIDX_ADDR, &load_history_index, sizeof(load_history_index)) != SUCCESS)
	{
		if (check_retry())	post SaveLoadIdxTask();
	}
}

task void SaveLoadTask()
{

	
	save_state = STATE_LOAD;
	if (PageEEPROM.write(SAVE_PAGE, IFLASH_LOADHISTORY_ADDR, load_history, sizeof(load_history)) != SUCCESS)
	{
		if (check_retry())	post SaveLoadTask();
	}
}

task void SaveBatteryTask()
{
	save_state = STATE_BATTERY;
	if (PageEEPROM.write(SAVE_PAGE, IFLASH_BATTERY_ADDR, &batt_reserve, sizeof(batt_reserve)) != SUCCESS)
	{
		if (check_retry())	post SaveBatteryTask();
	}
}

task void SaveFlagTask()
{
	save_state = STATE_FLAG;
	if (PageEEPROM.write(SAVE_PAGE, IFLASH_RT_ADDR, &save_flag, sizeof(save_flag)) != SUCCESS)
	{
		if (check_retry())	post SaveFlagTask();
	}
}*/

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
	post EraseTask();
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
	return TRUE;
}

/*********************************
 * A wrapper for enqueue to manage
 * the posting of consumer tasks
 ********************************/
bool
		dolocalenqueue (EdgeQueue * q, EdgeIn edge)
{
	bool result;

	/*queue_ptr = q;
	atomic
	{
		result = enqueue (q, edge);

		if (result && localCAlive == FALSE)
		{
			localCAlive = TRUE;
			post LocalConsumerTask ();
		}
	}*/				//atomic
	return SUCCESS;

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

result_t handle_exit (Handle data)
{
	uint32_t penergy;
	result_t res;
	GenericNode **ndata = (GenericNode **) data;

	res = call IEnergyMap.getPathEnergy((*ndata)->_pdata.sessionID, &penergy);
	
	if (res == FAIL)
	{
		penergy = 0xFFFFFFFF;
	}
	
	#ifdef RUNTIME_TEST
		memcpy(__rt_send_buf.data, &((*ndata)->_pdata.weight), sizeof(uint16_t));
		memcpy(__rt_send_buf.data + 2, &penergy, sizeof(uint32_t));
		memcpy(__rt_send_buf.data + 6, &((*ndata)->_pdata.sessionID), sizeof(uint16_t));
		if (SUCCESS == call SendMsg.send(TOS_BCAST_ADDR, 8, &__rt_send_buf ))
		{
			//call Leds.redToggle();
		}
	#endif
	
	//report path completion
	call IEval.reportPathDone((*ndata)->_pdata.weight, curstate, penergy);
 
	call BAlloc.free (data);

	return SUCCESS;
}

/*
result_t
		handle_error (uint16_t nodeid, Handle indata, uint8_t error)
{

  //add weight
	GenericNode **ndata = (GenericNode **) indata;


	(*ndata)->_pdata.weight += getErrorWeight (nodeid);

	if (error == ERR_NOMEMORY)
	{
      
	}
	if (error == ERR_QUEUE)
	{
      
	}


  //call the correct error handler
	return callError (nodeid, indata, error);
}
*/

//CODE FOR HANDLING EDGES BETWEEN NODES
/*
result_t
		handle_edge (uint16_t nodeid,
					 Handle outdata, bool local, uint16_t edgewt)
{
//	result_t result;
	Handle hin;
//	Handle hout;
	EdgeIn newedge;


  
  //out becomes in.
	hin = outdata;
//needs to be done right before calling nodeCall;


  //put it on the queue
  //Copy src contents to new edge
	((GenericNode *) (*hin))->_pdata.weight += edgewt;
	newedge.node_id = nodeid;
	newedge.invar = (uint8_t **) hin;
  //newedge.outvar = (uint8_t **) hout;



	if (!dolocalenqueue (&moteQ, newedge))
	{
     //queue is full
		return handle_error (nodeid, hin, ERR_QUEUE);
	}
  

	return SUCCESS;
}
*/

/*
//CODE FOR HANDLING EDGES FROM SOURCES TO NODES
result_t
		handle_src_edge (uint16_t nodeid,
						 Handle outdata,
						 uint16_t session, bool local, uint16_t edgewt)
{
	result_t result;
	Handle hin;
	//Handle hout;
	EdgeIn newedge;
	uint16_t datasize;



	
  //allocate in variable
	datasize = call BAlloc.size (outdata);
	alloc_size = call BAlloc.freeBytes ();
	result = call BAlloc.allocate (&hin, datasize);
	if (result == FAIL)
	{
      //error handling code
		//call Leds.redToggle();
		deadlocked_edge_id = 0xe0;
		return handle_error (nodeid, outdata, ERR_NOMEMORY);
	}
	memcpy (*hin, *outdata, datasize);


	call IEnergyMap.startPath(session);
  //put it on the queue
  //Copy src contents to new edge
	((GenericNode *) (*hin))->_pdata.sessionID = session;
	//((GenericNode *) (*hin))->_pdata.sessionID = session;
	((GenericNode *) (*hin))->_pdata.weight += edgewt;
	((GenericNode *) (*hin))->_pdata.minstate = STATE_BASE;
	((GenericNode *) (*hin))->_pdata.wake = FALSE;
	newedge.node_id = nodeid;
	newedge.invar = (uint8_t **) hin;
  //newedge.outvar = (uint8_t **) hout;

  

	if (!dolocalenqueue (&moteQ, newedge))
	{
      //queue is full
      	deadlocked_edge_id = 0xe1;
		return handle_error (nodeid, hin, ERR_QUEUE);
	}
	deadlocked_edge_id = 0xe2;

	return SUCCESS;
}
*/
#endif
