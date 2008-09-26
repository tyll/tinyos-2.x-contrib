
#include "scheduler.h"
#include "nodes.h"
#include "eonconst.h"


module EonSchedulerM
{
	provides
	{
		interface Init;
		interface StdControl;
		interface IScheduler;	
	}
	uses
	{
		interface Timer<TMilli> as QueueTimer;
		interface EonGraph;
		interface EonFlows;
		interface IEnergyMap;
		interface RuntimeState;
	}
}

implementation
{
	EdgeQueue __q;
	uint8_t __node_locks[NODE_LOCKS_LENGTH];
	uint16_t session_id;
	
	//prototypes
	task void LocalConsumerTask ();
	
	
	//session handling
	uint16_t getNextSession()
	{
		uint16_t nextid;
		nextid = session_id;
		session_id++;
		
		return nextid;
	}
	
	//node lock functions	
	
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
		
		//atomic 
		{
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
		//atomic 
		{
			__set_bit_lock_value(node_id, FALSE);
		}
		return TRUE;
	}
//end node lock functions
	
//handlers
	error_t handle_exit (uint16_t nodeid)
	{
		error_t res;
		rt_data *pdata = call EonGraph.getRTData(nodeid);
	
		
		__release_node_lock(nodeid);
		
		res = call IEnergyMap.endPath(pdata->sessionID, pdata->weight);	
	
		
		return res;
	}
	
	error_t handle_error (uint16_t nodeid, uint8_t error)
	{

		//add weight
		rt_data *pdata = call EonGraph.getRTData(nodeid);
		pdata->weight += call EonGraph.getErrorWeight (nodeid);
	
		//call the correct error handler
		return call EonGraph.call_error_handler(nodeid, error);
	}

//end handlers
	command error_t Init.init ()
	{
		__q.head = 0;
    	__q.tail = 0;
		session_id = 0;
  		return SUCCESS;
	}
	
	command error_t StdControl.start()
	{
		
		return SUCCESS;
	}
	
	command error_t StdControl.stop()
	{
		return SUCCESS;
	}

	bool isqueueempty ()
	{
	  return (__q.tail == __q.head);
	}

	
	error_t schedule (EdgeIn edge)
	{
	  error_t result = FAIL;

	  //I don't think I need this.  TODO:  Please check on this
	  //atomic
  	  {

    	if (NEXT_IDX (__q.tail) == __q.head)
      	{
			//queue is full
			result = EBUSY;
      	}
    	else
      	{
			memcpy (&__q.edges[__q.tail], &edge, sizeof (EdgeIn));
			__q.tail = NEXT_IDX (__q.tail);
			result = SUCCESS;
			post LocalConsumerTask();
      	}
  	  }
  	  return result;
	}

	error_t dequeue (EdgeIn *edge)
	{
	  error_t result;
	
	
	  //atomic
	  {
	    if (__q.tail == __q.head)
	      {
			//queue is empty
			return FAIL;
	      }
	    else
	      {
	
			memcpy (edge, &__q.edges[__q.head], sizeof (EdgeIn));
			__q.head = NEXT_IDX (__q.head);
			result = TRUE;
	      }
	  }
	
	  return result;
	}

	task void LocalConsumerTask ()
	{
		
		uint16_t result;
		uint16_t realdest;
		uint16_t realweight;
		
		uint16_t delay;
		EdgeIn edge;
		rt_data *src_data = NULL, *dst_data;
		void *soutvar, *dinvar, *doutvar;
		
		delay = FALSE;
	
		result = dequeue (&edge);
		
		
		if (result == FALSE)
		{
			//no edges to process.  Exit
			return;
		}
		
		
		//translate the edge
		realdest = call EonGraph.translate_edge_complete (&edge, &realweight);
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
			if (schedule(edge) != SUCCESS)
			{
				//signal a full queue (drop the flow);
				if (edge.src)
				{
					bool* tmp;
					(tmp = call EonGraph.getOutValid(edge.src_id))[edge.idx] = FALSE;
				}
				handle_error(edge.src_id, ERR_QUEUE);
			}
			
			call QueueTimer.startOneShot(QUEUE_DELAY);
			return;
		}
		
		//we have the lock
		
		//get the runtime data
		if (edge.src == FALSE)
		{
			src_data = call EonGraph.getRTData(edge.src_id);
		}
		dst_data = call EonGraph.getRTData(realdest);
		
		
		
		if ((edge.src == FALSE && src_data == NULL) || dst_data == NULL)
		{
			//runtime system/compiler bug.
			//very bad.  Should never happen
			
			__release_node_lock(realdest);
			if (edge.src)
			{
				(call EonGraph.getOutValid(edge.src_id))[edge.idx] = FALSE;
			}
			handle_error(edge.src_id, ERR_RTDATA);
			
			call QueueTimer.startOneShot(QUEUE_DELAY);
			return;
		}
		
		
		
		if (edge.src == FALSE)
		{
			//copy runtime data along
			memcpy(dst_data, src_data, sizeof(rt_data));
		} else {
			//initialize runtime data
			dst_data->sessionID = getNextSession();
			dst_data->weight = call EonGraph.getSrcWeight(edge.src_id);
			dst_data->minstate = STATE_BASE;
			call IEnergyMap.startPath(dst_data->sessionID);
		}
		//increment the weight according to the translation
		dst_data->weight += realweight;
		
		//copy the source "out" to the dest "in"
		if (edge.src)
		{
			soutvar = call EonGraph.getOutQueue(edge.src_id, edge.idx);
		} else {
			soutvar = call EonGraph.getOutVar(edge.src_id);
		}
		dinvar = call EonGraph.getInVar(realdest);
		doutvar = call EonGraph.getOutVar(realdest);
		memcpy(dinvar, soutvar, call EonGraph.getOutSize(edge.src_id));
		
		if (edge.src)
		{
			//free up the previously occupied slot
			(call EonGraph.getOutValid(edge.src_id))[edge.idx] = FALSE;
		}
		
		//release the src lock
		__release_node_lock(edge.src_id);
		
		
		//NOW WE ACTUALLY CALL THE NODE
		//call PowerDisable(); //no power management in nodes
		result = call EonGraph.call_edge(realdest, dinvar, doutvar);
		
		if (result != SUCCESS)
		{
			
			//call PowerEnable();
			handle_error(realdest, result);
		} //if
	
		
		if (!isqueueempty())
		{
			post LocalConsumerTask ();
		}
		
	}	//end LocalConsumerTask
	

	event void QueueTimer.fired ()
	{
		post LocalConsumerTask ();
	}
	
	event void EonFlows.flow_error (uint16_t nodeid, uint8_t error)
	{
	}
	
	event void EonFlows.schedule_edge (uint16_t srcid, uint16_t dstid, uint16_t edgewt)
	{
		EdgeIn newedge;
		rt_data *pdata;
		
		newedge.src_id = srcid;
		newedge.dst_id = dstid;
		newedge.src = FALSE; //mark it as not coming from a source
		pdata = call EonGraph.getRTData(srcid);
		if (pdata == NULL)
		{
			//bad source...should never happen
			handle_error(srcid, ERR_SRC);
			return;
		}
		
		//add this edges weight---further translation will come when it is advanced to the next edge
		pdata->weight += edgewt;
		
		
		if (schedule(newedge) != SUCCESS)
		{
			//signal a full queue (drop the flow);
			
			handle_error(srcid, ERR_QUEUE);
			return;
		}
		
	}
	
	event bool EonFlows.functional_check(uint8_t state)
	{
		__runtime_state_t *rtstate = call RuntimeState.getState();
		return (rtstate->curstate <= state);
	}
	
  	event void EonFlows.schedule_src_edge (uint16_t srcid, uint16_t dstid)
	{
		EdgeIn newedge;
		bool *out_valid;
		int i, slot = -1;
		void *outbuf, *queuebuf;
	
		//see if there is an open queue slot
		out_valid = call EonGraph.getOutValid(srcid);
		
		
		for (i=0; i <  SRC_QUEUE_SIZE; i++)
		{
			if (out_valid[i] == FALSE)
			{
				out_valid[i] = TRUE;
				slot = i;
				break;
			}
		}	
	
	
		if (slot == -1)
		{
			//queue full
			return;
		}
	
		//copy data into queue
		outbuf = call EonGraph.getOutVar(srcid);
		queuebuf = call EonGraph.getOutQueue(srcid,slot);
		memcpy(queuebuf, outbuf, call EonGraph.getOutSize(srcid));
	
		//put it on the scheduling queue
		newedge.src_id = srcid;
		newedge.dst_id = dstid;
		newedge.src = TRUE; //mark it as coming from a source
		newedge.idx = slot;
	
	
	
		if (schedule(newedge) != SUCCESS)
		{
			//signal a full queue (drop the flow);
			signal EonFlows.flow_error(srcid, ERR_QUEUE);
		}
	}
	
	event void EonFlows.flow_exit (uint16_t nodeid)
	{
		error_t res;
		rt_data *pdata = call EonGraph.getRTData(nodeid);
	
		
		__release_node_lock(nodeid);
		res = call IEnergyMap.endPath(pdata->sessionID, pdata->weight);
	}
	
	event void IEnergyMap.pathEnergy(uint16_t path, uint32_t energy, bool micro)
	{
		signal IScheduler.flow_energy(path, energy);
	}
	
	
	command void IScheduler.adjust_intervals(uint8_t state, double grade)
	{
		call EonGraph.adjust_intervals(state, grade);
	}
	

}
