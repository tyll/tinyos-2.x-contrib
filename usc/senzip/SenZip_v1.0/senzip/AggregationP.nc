/*
 * SenZip aggregation component
 * build and maintain a table for local aggregation
 *
 * @ author        Sundeep Pattem
 * @ affiliation   Autonomous Networks Research Group
 * @ institution   University of Southern California
*/

#include <Compression.h>
#include <Senzip.h>

generic module AggregationP(uint8_t tableSize) {
  provides {
    interface Init;
    interface StdControl;
    interface AggregationTable as Table;
    interface UnicastNameFreeRouting as FixedRouting;
  }

  uses {
    interface SplitControl as RadioControl;
    interface Packet;
    interface AMSend as AggBeaconSend;
    interface Receive as AggBeaconReceive;
    interface AggregationInformation as Routing;
    interface Pool<agg_table_entry_t> as TablePool;
    interface Queue<agg_queue_entry_t*> as SendQueue;
    interface Pool<agg_queue_entry_t> as QEntryPool;
    interface Timer<TMilli> as BeaconTimer;

    interface Leds;

    //Log-Flash
    interface SplitControl as StorageControl;
    interface RWLogger;
    
  }
}

implementation {
  task void sendTask();
  
  //Log-Flash
  TrialLog logData; 
  bool logLock;  
  bool resetFlag;
  uint8_t counter;
        
  void aggTableInit();
  entry_position* aggTableFind(uint16_t, uint16_t, uint8_t, uint8_t);
  bool aggTableAdd(agg_header_t*);
  bool aggTableRemove(agg_header_t*);
  entry_position entry;

  agg_table_entry_t aggTable[tableSize];
  uint8_t aggTableActive;

  message_t aggBeaconMsgBuffer;
  agg_header_t* aggBeaconMsg; 
  bool sending;

  self_info selfInfo; 
  
  command error_t Init.init() {
    call Routing.initSettings(ETX);
    signal Table.tablePointer(aggTable, &selfInfo);
    selfInfo.currParent = 0xFFFF;
    selfInfo.prevParent = 0xFFFF;
    selfInfo.numChildren = 0;
    aggBeaconMsg = call AggBeaconSend.getPayload(&aggBeaconMsgBuffer);
    sending = FALSE;

    // Log-Flash
    counter = 0;
    logLock = FALSE;
    resetFlag = FALSE;
    call StorageControl.start();

    return SUCCESS;
  }

  command error_t StdControl.start() {
    return SUCCESS;
  }

  command error_t StdControl.stop() {
    return SUCCESS;
  }

  command am_addr_t FixedRouting.nextHop() {
    return selfInfo.currParent;    
  }
  command bool FixedRouting.hasRoute() {
    return (selfInfo.currParent != 0xFFFF);
  }

  command void Table.contactDescendant(uint8_t pos, uint8_t id) {
    // Aggregation should check if the ETX is low? or send an explicit beacon to check with the child?
    agg_queue_entry_t *qe;
    qe = call QEntryPool.get();
    aggBeaconMsg = (agg_header_t *)call Packet.getPayload(&(qe->msg), NULL);
    aggBeaconMsg->type = SEND_PARENT_INFO;
    aggBeaconMsg->src = TOS_NODE_ID;
    aggBeaconMsg->forNode = id;
    aggBeaconMsg->relPos = UP;
    aggBeaconMsg->hops = 1;    

    if (pos == 1) {
      qe->dest = id;
    }
    if (call SendQueue.enqueue(qe) == SUCCESS) {
      post sendTask();
    }
  }

  event void RadioControl.startDone(error_t err) {}

  event void RadioControl.stopDone(error_t err) {}

  event void BeaconTimer.fired() {
    if (!call SendQueue.empty()) {
      post sendTask();
    }
  }

  event void AggBeaconSend.sendDone(message_t* msg, error_t error) {
    // what if error != SUCCESS
    agg_queue_entry_t *head;    
    head = call SendQueue.head();
    call QEntryPool.put(head); 
    call SendQueue.dequeue();
    sending = FALSE;
    // introduce timer?
    if ((!call SendQueue.empty())&&(!call BeaconTimer.isRunning())) {
      call BeaconTimer.startOneShot(AGG_BEACON_INTERVAL);
    }
  }

  event void Routing.parentChange(uint16_t newParent, uint8_t hopCount) {
    uint8_t idx;
    agg_queue_entry_t *qe;

    selfInfo.hopCount = hopCount;
    if (selfInfo.currParent == newParent) {
      // how to handle changes in hop count? 
    } else {
      // parent change, update selfInfo
      selfInfo.prevParent = selfInfo.currParent;
      selfInfo.currParent = newParent;

      // inform new parent
      qe = call QEntryPool.get();
      aggBeaconMsg = (agg_header_t *)call Packet.getPayload(&(qe->msg), NULL);
      aggBeaconMsg->type = ADD;
      aggBeaconMsg->src = TOS_NODE_ID;
      aggBeaconMsg->relPos = DOWN;
      aggBeaconMsg->forNode = TOS_NODE_ID;
      aggBeaconMsg->hops = 0;
      if (DOWNSTREAM_HOPS == 2) {
        aggBeaconMsg->weight = selfInfo.numChildren;
        for (idx = 0; idx < selfInfo.numChildren; idx++) {
          //aggBeaconMsg->childIds[idx] = aggTable[idx].nodeInfo.id;
          //aggBeaconMsg->numGrandchildren[idx] = aggTable[idx].weight.downstrOneHopNbrhoodSize;
        }
      }
      qe->dest = selfInfo.currParent;

      if (call SendQueue.enqueue(qe) == SUCCESS) {
        post sendTask();
      }

      // inform old parent
      if (selfInfo.prevParent != 0xFFFF) {
        qe = call QEntryPool.get();
	aggBeaconMsg = (agg_header_t *)call Packet.getPayload(&(qe->msg), NULL);
        aggBeaconMsg->type = DELETE;
        aggBeaconMsg->src = TOS_NODE_ID;
        aggBeaconMsg->relPos = DOWN;
        aggBeaconMsg->forNode = TOS_NODE_ID;
        aggBeaconMsg->hops = 0;
	qe->dest = selfInfo.prevParent;
        if (call SendQueue.enqueue(qe) == SUCCESS) {
	  post sendTask();
        }
      }
    }
    signal Table.change(PARENT, selfInfo.hopCount);
  }

  event message_t* AggBeaconReceive.receive(message_t* msg, void* payload, uint8_t len) {
    bool tableOper;
    uint8_t pos, idx;
    agg_queue_entry_t *qe;
    agg_header_t* aggBeacon;
    aggBeacon = (agg_header_t*)payload;    
    
    if(!resetFlag) {
      call RWLogger.reset();
      resetFlag = TRUE;
    }

    //Log-Flash
    logData.sender=aggBeaconMsg->src;
    logData.receiver = aggBeaconMsg->forNode;
    logData.type = aggBeaconMsg->type;
    logData.counter = counter;
    counter++;
    if (!logLock) {
      if (call RWLogger.log(&logData,sizeof(logData)) == SUCCESS){
         call Leds.led1Toggle();
	 logLock = TRUE;
      }
    }
    
    if(aggBeacon->type == ADD) {
      tableOper = aggTableAdd(aggBeacon);
      if (tableOper == SUCCESS) {
        signal Table.change(ADD_CHILD, selfInfo.hopCount);
        if ((aggBeacon->relPos == DOWN) && (DOWNSTREAM_HOPS == 2)) {
          qe = call QEntryPool.get();
	  aggBeaconMsg = (agg_header_t *)call Packet.getPayload(&(qe->msg), NULL);
          aggBeaconMsg->type = ADD;
          aggBeaconMsg->src = TOS_NODE_ID;
          aggBeaconMsg->relPos = DOWN;
          aggBeaconMsg->forNode = aggBeacon->src;
          if (aggBeacon->hops == 0) {
            aggBeaconMsg->hops = 1;
	    aggBeaconMsg->weight = aggBeacon->weight;
          } else if (aggBeacon->hops == 1) { 
            aggBeaconMsg->hops = 2;
	    aggBeaconMsg->weight = aggTable[pos].weight.downstrOneHopNbrhoodSize;
          } 
	  qe->dest = selfInfo.currParent;
	  if (call SendQueue.enqueue(qe) == SUCCESS) {
	    post sendTask();
          }
	}
      }
    } else if (aggBeacon->type == DELETE) {
      call Leds.led1Toggle();
      tableOper = aggTableRemove(aggBeacon);
      if (tableOper == SUCCESS) {
        signal Table.change(DELETE_CHILD, selfInfo.hopCount);
        if ((aggBeacon->relPos == DOWN) && (DOWNSTREAM_HOPS == 2)) {
          qe = call QEntryPool.get();
	  aggBeaconMsg = (agg_header_t *)call Packet.getPayload(&(qe->msg), NULL);
          aggBeaconMsg->type = DELETE;
          aggBeaconMsg->src = TOS_NODE_ID;
          aggBeaconMsg->relPos = DOWN;
          aggBeaconMsg->forNode = aggBeacon->src;
          aggBeaconMsg->hops = aggBeacon->hops + 1;
	  qe->dest = selfInfo.currParent;
          if (call SendQueue.enqueue(qe) == SUCCESS) {
	    post sendTask();
          }
        }
      }
    } else if(aggBeacon->type == SEND_PARENT_INFO) {
      if (aggBeacon->relPos == UP) {
        if (aggBeacon->hops == 1) {
          qe = call QEntryPool.get();
	  aggBeaconMsg = (agg_header_t *)call Packet.getPayload(&(qe->msg), NULL);
          aggBeaconMsg->type = PARENT_INFO;
          aggBeaconMsg->src = TOS_NODE_ID;
          aggBeaconMsg->relPos = DOWN;
	  aggBeaconMsg->forNode = selfInfo.currParent;
	  aggBeaconMsg->hops = 1;
	  qe->dest = aggBeacon->src;
          if (call SendQueue.enqueue(qe) == SUCCESS) {
	    post sendTask();
          }
	}
      }
    } else if(aggBeacon->type == PARENT_INFO) {
      if (aggBeacon->relPos == DOWN) {
        if (aggBeacon->hops == 1) {
	  if (aggBeaconMsg->forNode != TOS_NODE_ID) {
	    aggBeacon->forNode = aggBeacon->src;
            tableOper = aggTableRemove(aggBeacon);
	    if (tableOper == SUCCESS) {
              signal Table.change(DELETE_CHILD, selfInfo.hopCount);
	    }
	  }
	}
      }
    } else if(aggBeacon->type == ALL_INFO) {
        qe = call QEntryPool.get();
	aggBeaconMsg = (agg_header_t *)call Packet.getPayload(&(qe->msg), NULL);
        aggBeaconMsg->type = ALL_INFO;
        aggBeaconMsg->src = TOS_NODE_ID;
        aggBeaconMsg->weight = selfInfo.numChildren;
	aggBeaconMsg->forNode = aggBeaconMsg->src;
        for (idx = 0; idx < selfInfo.numChildren; idx++) {
          //aggBeaconMsg->childIds[idx] = aggTable[idx].nodeInfo.id;
        }
	qe->dest = aggBeacon->src;
        if (call SendQueue.enqueue(qe) == SUCCESS) {
	  post sendTask();
        }      
    }
    return msg;
  }

  task void sendTask() {
    agg_queue_entry_t *head;
    error_t eval;

    if(!resetFlag) {
       call RWLogger.reset();
       resetFlag = TRUE;
    }

    if (sending) {
      if(!call BeaconTimer.isRunning()) {
        call BeaconTimer.startOneShot(AGG_BEACON_INTERVAL);        
      }      
      return;
    }
    head = call SendQueue.head();
    eval = call AggBeaconSend.send(head->dest, &(head->msg), sizeof(agg_header_t));
    if (eval == SUCCESS) {
      call Leds.led1Toggle();
       
      //Log-Flash
      logData.sender=aggBeaconMsg->src;
      logData.receiver = aggBeaconMsg->forNode;
      logData.type = aggBeaconMsg->type;
      logData.counter = counter;
      counter++;
      if (!logLock) {
         if (call RWLogger.log(&logData,sizeof(logData)) == SUCCESS){
            logLock = TRUE;
            call Leds.led1Toggle(); 
	 }
      }    
      sending = TRUE;
    } else {
      // address failure modes
    }
    
  }  

  /* Aggregation table functions */

  /*
  void aggTableInit() {
    uint8_t i, idx;
    for (idx = 0; idx < tableSize; idx++) {
      if (UPSTREAM_HOPS == 1) {
         aggTable[idx].upstrNeighborEntry = NULL;
      }
      if (DOWNSTREAM_HOPS == 1)
        aggTable[idx].downstrNeighborEntry = NULL; 
      else if (DOWNSTREAM_HOPS == 2) {
        aggTable[idx].downstrNeighborEntry = call TablePool.get();
	for (i = 0; i < MAX_NUM_CHILDREN; i++) {
          (aggTable[idx].downstrNeighborEntry + i)->upstrNeighborEntry = NULL;
	  (aggTable[idx].downstrNeighborEntry + i)->downstrNeighborEntry = NULL;
	}
      }
    }
    return;
  }
  */

  entry_position* aggTableFind(uint16_t neighborId, uint16_t toFindId, uint8_t relPos, uint8_t hops) {
    uint8_t idx1, idx2;
    agg_table_entry_t* current;
    entry.parent = NULL;
    entry.offset = NOT_FOUND;
    for (idx1 = 0; idx1 < selfInfo.numChildren; idx1++) {
      current = aggTable + idx1;
      if (current->nodeInfo.id == neighborId) {
        if (hops == 1)  {
	  entry.parent = NULL;
	  entry.offset = idx1;
        } else if (hops == 2) {
	  entry.parent = current;
	  if (relPos == DOWN) {
            for (idx2 = 0; idx2 < entry.parent->weight.downstrOneHopNbrhoodSize; idx2++) {
	      current = entry.parent->downstrNeighborEntry[idx2];
	      if (current->nodeInfo.id == toFindId) {
	        entry.offset = idx2;
	        return &entry;
	      }
	    }
	    entry.offset = NOT_FOUND;
	    return &entry;
	  }
	}
      }
    }
    return &entry;
  }

  bool aggTableAdd(agg_header_t* aggBeacon) {
    uint8_t idx;
    entry_position *foundEntry;
    foundEntry = aggTableFind(aggBeacon->src, aggBeacon->forNode, aggBeacon->relPos, aggBeacon->hops + 1);
    if (aggBeacon->hops == 0) {
      if ((foundEntry->offset != NOT_FOUND)||(selfInfo.numChildren == MAX_NUM_CHILDREN)) {
        return FAIL; // need to distinguish between already existing foundEntry and full table?
      }
      aggTable[selfInfo.numChildren].nodeInfo.id = aggBeacon->src;
      if (aggBeacon->relPos == DOWN) {
        aggTable[selfInfo.numChildren].weight.downstrOneHopNbrhoodSize = aggBeacon->weight;
	if (DOWNSTREAM_HOPS == 2) {
          for (idx = 0; idx < aggBeacon->weight; idx++) {
            aggTable[selfInfo.numChildren].downstrNeighborEntry[idx] = call TablePool.get();
            //aggTable[selfInfo.numChildren].downstrNeighborEntry[idx]->nodeInfo.id = aggBeaconMsg->childIds[idx];
            //aggTable[selfInfo.numChildren].downstrNeighborEntry[idx]->weight.downstrOneHopNbrhoodSize = aggBeaconMsg->numGrandchildren[idx];
          }
        }
      }
      selfInfo.numChildren++;
    } else if (aggBeacon->hops == 1) {
      if ((foundEntry->parent == NULL) || (foundEntry->offset != NOT_FOUND) || (foundEntry->parent->weight.downstrOneHopNbrhoodSize == MAX_NUM_CHILDREN)) {
        return FAIL; // differentiate fail modes?
      }
      // add grandchild
      foundEntry->parent->downstrNeighborEntry[foundEntry->offset] = call TablePool.get();
      foundEntry->parent->downstrNeighborEntry[foundEntry->offset]->nodeInfo.id = aggBeacon->forNode;
      foundEntry->parent->downstrNeighborEntry[foundEntry->offset]->weight.downstrOneHopNbrhoodSize = aggBeacon->weight;
      foundEntry->parent->weight.downstrOneHopNbrhoodSize++;
    } else if (aggBeacon->hops == 2) {
      // change weight for grandchild
      foundEntry->parent->downstrNeighborEntry[foundEntry->offset]->weight.downstrOneHopNbrhoodSize = aggBeacon->weight;
    }
    return SUCCESS;
  }

  bool aggTableRemove(agg_header_t* aggBeacon) {
    uint8_t idx = 0;
    entry_position *foundEntry;
    foundEntry = aggTableFind(aggBeacon->src, aggBeacon->forNode, aggBeacon->relPos, aggBeacon->hops + 1);
    if (foundEntry->offset == NOT_FOUND) {
      return FAIL;
    }
    // check if (aggBeacon->relPos == DOWN)?
    if (aggBeacon->hops == 0) {
      selfInfo.numChildren--;
      for (idx = foundEntry->offset; idx < selfInfo.numChildren; idx++) {
        aggTable[idx] = aggTable[idx+1];
      }
    } else if (aggBeacon->hops == 1) {
      // remove a grandchild
      call TablePool.put(foundEntry->parent->downstrNeighborEntry[idx]);
      foundEntry->parent->weight.downstrOneHopNbrhoodSize--;
      for (idx = foundEntry->offset; idx < foundEntry->parent->weight.downstrOneHopNbrhoodSize; idx++) {
        foundEntry->parent->downstrNeighborEntry[idx] = foundEntry->parent->downstrNeighborEntry[idx+1];
      }
    } else if (aggBeacon->hops == 2) {
      // update weight for grandchild
      foundEntry->parent->downstrNeighborEntry[foundEntry->offset]->weight.downstrOneHopNbrhoodSize--;
    }
    return SUCCESS;
  }

  // Log-Flash-----------------------
  event void StorageControl.startDone(error_t err){
    //do nothing   
  }

  event void StorageControl.stopDone(error_t err){
    //do nothing
  }

  event void RWLogger.logDone(error_t err){
    //Release the lock on the logging functionality.
    atomic{
      logLock = FALSE;
    }
  }

  event void RWLogger.eraseDone(error_t err){
    // do nothing    
  }
  
  // -----------------------------------
 
}

