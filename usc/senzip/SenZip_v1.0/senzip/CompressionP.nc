/*
 * SenZip compression component
 * perform all compression operations: store neighbor measurements, apply transform, encode coefficients, packetize
 *
 * @ author        Sundeep Pattem
 * @ author        Ying Chen
 * @ affiliation   Autonomous Networks Research Group
 * @ institution   University of Southern California
*/

#include <Compression.h>
#include <Senzip.h>

generic module CompressionP(uint8_t tableSize) {
  provides {
    interface Init;
    interface StdControl;
    interface Set<uint16_t> as Measurements;
    interface StartGathering;
  }

  uses {
    interface Packet;
    interface Send;
    interface Queue<comp_queue_entry_t*> as SendQueue;
    interface Pool<comp_queue_entry_t> as QEntryPool;
    interface AggregationTable as Table;
    interface Intercept;
    interface Pool<buffer_t> as StoragePool;
    interface Timer<TMilli> as AllRxTimer;
    interface Timer<TMilli> as PostSendTaskTimer;
    interface Leds;
    interface Timer<TMilli> as RawDataTimer;
    
    interface AMSend as StartSend;
    interface Receive as StartReceive;
    interface Packet as StartPacket;
  }
}

implementation {
  
  bool sending;
  bool allChildRx;

  uint8_t numChildRx;
  uint8_t measurementCount;
  uint8_t selfEpochNumber;
  uint8_t childEpochNumber;

  senzip_start_msg_t* startMsg;
  
  uint8_t searchTable(uint8_t type, uint16_t id);
  
  void computeTransform();
  int16_t quantize(int16_t c);
  uint8_t bitCount(int16_t v, uint8_t k);
  void generateCode(uint8_t cIdx, int16_t v, uint8_t k);
  void writeBit(uint8_t cIdx, uint16_t bit);

  void sendSinkPacket();
  void sendRawPacket();
  void sendCompPacket(uint8_t cIdx);

  task void sendTask();
  task void changesTask();
  task void encodeCoefficientsTask();

  agg_table_entry_t *aggTable;
  self_info *aggSelfInfo, compSelfInfo;
  changes change;
  
  buffer_t selfBuffer;
  buffer_t selfTempBuffer;
  buffer_entry_t childBuffer[MAX_NUM_CHILDREN];
  
  bool startFlag;  

  message_t packet, packet1;
  
  command error_t Init.init() {
    numChildRx = 0;
    allChildRx = FALSE;
    selfEpochNumber = 1;
    childEpochNumber = 1;
    measurementCount = 0;
    compSelfInfo.numChildren = 0;
    startFlag = FALSE;
    
    return SUCCESS;
  }

  command error_t StdControl.start() {
    return SUCCESS;
  }

  command error_t StdControl.stop() {
    return SUCCESS;
  }

  // commands called by the application
  command void Measurements.set(uint16_t val) {
    selfBuffer.partial[measurementCount] = val;
    measurementCount = (measurementCount + 1)%(2*NUM_MEASUREMENTS);
    if ((measurementCount%NUM_MEASUREMENTS) == 0) {
      call RawDataTimer.startOneShot(750 + TOS_NODE_ID*100);
      selfEpochNumber++;
      if (compSelfInfo.numChildren == 0) {
        sendRawPacket();
      } else {
        call AllRxTimer.startOneShot(COMP_RX_DELAY);
      }
    }
  }
  
 command bool StartGathering.isStarted() {
   return startFlag;  
 }
  
 command void StartGathering.getStarted() {		
   startFlag = TRUE;
   startMsg = (senzip_start_msg_t*)call StartPacket.getPayload(&packet, NULL);
   startMsg -> type = FLOOD_START;   
   call StartSend.send(0xFFFF, &packet, sizeof(senzip_start_msg_t));
   signal StartGathering.startDone();	
 }

 event void StartSend.sendDone(message_t* m, error_t e) {}
  
 event message_t* StartReceive.receive(message_t* msg, void* payload, uint8_t len)  {
   if( len != sizeof(senzip_start_msg_t) ) {
     return msg;
   } else {    
     uint8_t epochNum, type;
     startMsg = (senzip_start_msg_t *) payload;
     type = startMsg->type;
     epochNum = startMsg->epochNumber;    
    
     if( !startFlag ) {
       if(type == FLOOD_START) {  
	  startFlag = TRUE;	
	  startMsg = (senzip_start_msg_t*)call StartPacket.getPayload(&packet, NULL);
	  startMsg -> type = FLOOD_START;    
	  call StartSend.send(0xFFFF, &packet, sizeof(senzip_start_msg_t));	
	  signal StartGathering.startDone();
       } else if (type == REPLY_PARENT_START) {
	  startFlag = TRUE;
	  selfEpochNumber = epochNum;			
	  signal StartGathering.startDone();		
       }
		
     } else {
       if(type == QUERY_PARENT_START){
         startMsg = (senzip_start_msg_t*)call StartPacket.getPayload(&packet, NULL);
         startMsg -> type = REPLY_PARENT_START;
         startMsg -> epochNumber = selfEpochNumber;    		
         call StartSend.send(0xFFFF, &packet, sizeof(senzip_start_msg_t));
       }
     }
   }  
   return msg;
 }
   

  // signalled by the Aggregation component
  event void Table.tablePointer(agg_table_entry_t *entry, self_info *info) {
    aggTable = entry;
    aggSelfInfo = info;
  }

  // signalled by the Aggregation component
  event void Table.change(uint8_t type, uint8_t pos) {

    if (type == PARENT) {
      change.parent = TRUE;
      // how will forwarding deal with this?
      // if change in hop count, changes to filter down to all descendants
    } else if (type == ADD_CHILD) {
      change.child = TRUE;
    } else if (type == DELETE_CHILD) {
      change.child = TRUE;
    } 
    post changesTask();
  }

  event void AllRxTimer.fired() {
    uint8_t cIdx, mIdx;
    if (!allChildRx) {
      sendRawPacket();
      // fill in older coeffs for the missing node
      for (cIdx = 0; cIdx < compSelfInfo.numChildren; cIdx++) {
        if (childBuffer[cIdx].lastSeqHeard < childEpochNumber) {
          for (mIdx = 0; mIdx < NUM_MEASUREMENTS; mIdx++)
            childBuffer[cIdx].store->partial[mIdx + (1 - childEpochNumber%2)*NUM_MEASUREMENTS] = childBuffer[cIdx].store->partial[mIdx + (childEpochNumber%2)*NUM_MEASUREMENTS];
        }
	if ((childBuffer[cIdx].lastSeqHeard + LOST_PKT_THRESHOLD < childEpochNumber) || 
	((childEpochNumber < MAX_SEQ_NUM/4)&&(childEpochNumber + MAX_SEQ_NUM > childBuffer[cIdx].lastSeqHeard + LOST_PKT_THRESHOLD))){
          call Table.contactDescendant(1, childBuffer[cIdx].id);	  
	}
      }
      computeTransform();
      post encodeCoefficientsTask();
      numChildRx = 0;
    }
    allChildRx = FALSE;
  }

  event void RawDataTimer.fired() {
    sendSinkPacket();
  }

  event bool Intercept.forward(message_t* m, void* payload, uint16_t len) {
    if (len != sizeof(comp_msg_t)) {
      return TRUE;
    } else {
      uint8_t idx, childPos;
      comp_msg_t *msg = (comp_msg_t *)payload;
      if (msg->type == COEFF_M1) {             // coefficients from one-hop child node
        childPos = searchTable(CHILD, msg->src);
	if (childPos != 0xFF) {
	  if ((msg->seq > childBuffer[childPos].lastSeqHeard) || 
	  ((msg->seq < MAX_SEQ_NUM/4)&&(childBuffer[childPos].lastSeqHeard > 3*MAX_SEQ_NUM/4))){     // check for wraparound
	    childBuffer[childPos].lastSeqHeard = msg->seq;
	    for (idx = 0; idx < NUM_MEASUREMENTS; idx++) {
	      childBuffer[childPos].store->partial[idx + childBuffer[childPos].count*NUM_MEASUREMENTS] = msg->data[idx];
	    }
	    numChildRx++;
	    if (numChildRx == compSelfInfo.numChildren) {
	      call Leds.led0Toggle();
	      allChildRx = TRUE;
	      sendRawPacket();
	      computeTransform();
	      post encodeCoefficientsTask();
              numChildRx = 0;
	    }
	  }
	}
        return FALSE;
      }
      return TRUE;
    }
  }

  event void Send.sendDone(message_t* msg, error_t error) {
    comp_queue_entry_t *qe = call SendQueue.head();
    // need to address the case (error != SUCCESS)
    call QEntryPool.put(qe); 
    call SendQueue.dequeue();
    sending = FALSE;
    if (!call SendQueue.empty()) {
      post sendTask();
    }
  }

  event void PostSendTaskTimer.fired() {
    if (!call SendQueue.empty()) {
      post sendTask();
    }    
  }

  task void sendTask() {
    error_t eval;
    comp_queue_entry_t *head;
    if (sending) {
      call PostSendTaskTimer.startOneShot(SEND_TASK_DELAY);
      return;
    }
    head = call SendQueue.head();
    eval = call Send.send(&(head->msg), sizeof(comp_msg_t));
    if (eval == SUCCESS) {
      sending = TRUE;
    } else { 
      call PostSendTaskTimer.startOneShot(SEND_TASK_DELAY);
    }
  }

  /* task for handling topology changes signalled by Aggregation component */

  task void changesTask() { // should this be a function?
    bool childFound;
    uint8_t aIdx, cIdx, numEnt, i;
    uint8_t numNewChild;
    if (change.parent) {
      compSelfInfo.prevParent = compSelfInfo.currParent;
      compSelfInfo.currParent = aggSelfInfo->currParent;
      change.parent = FALSE;
      
      // query parent if data gathering has started
      if( !startFlag ) {
        startMsg = (senzip_start_msg_t*)call StartPacket.getPayload(&packet, NULL);
        startMsg -> type = QUERY_PARENT_START;     
        call StartSend.send(compSelfInfo.currParent, &packet, sizeof(senzip_start_msg_t));
      }      
    } 

    if (change.child) {
      // check for new children and add
      numNewChild = 0;
      for (aIdx = 0; aIdx < aggSelfInfo->numChildren; aIdx++) {
        childFound = FALSE;
        for (cIdx = 0; cIdx < compSelfInfo.numChildren; cIdx++) {
	  if (childBuffer[cIdx].id == (aggTable + aIdx)->nodeInfo.id)
	    childFound  = TRUE;
	}
	if (!childFound) {
	  childBuffer[compSelfInfo.numChildren + numNewChild].id = (aggTable + aIdx)->nodeInfo.id;
	  childBuffer[compSelfInfo.numChildren + numNewChild].mark = FALSE;
	  childBuffer[compSelfInfo.numChildren + numNewChild].store = call StoragePool.get();
	  childBuffer[compSelfInfo.numChildren + numNewChild].seqNum = 0;
  	  childBuffer[compSelfInfo.numChildren + numNewChild].count = 0;
	  numNewChild++;
	}
      }

      // mark children to remove and delete
      for (cIdx = 0; cIdx < compSelfInfo.numChildren; cIdx++) {
        childFound =  FALSE;
        for (aIdx = 0; aIdx < aggSelfInfo->numChildren; aIdx++) {
	  if ((aggTable + aIdx)->nodeInfo.id == childBuffer[cIdx].id) {
	    childFound = TRUE;
	    break;
	  }
	}
	if (!childFound) {
          childBuffer[cIdx].mark = TRUE;
	}
      }
      numEnt = 0;
      cIdx = 0;
      while (numEnt < compSelfInfo.numChildren) {
        if (childBuffer[cIdx].mark) {
	  // node about to be removed from table, send out the full coeffs for this node
	  if (childBuffer[cIdx].count > 0)
	    sendCompPacket(cIdx);
	  call StoragePool.put(childBuffer[cIdx].store);
	  for (i = cIdx; i < compSelfInfo.numChildren; i++) {
	    childBuffer[i] = childBuffer[i + 1];
	  }
	} else {
	  cIdx++;
	};
        numEnt++;
      }
      compSelfInfo.numChildren = aggSelfInfo->numChildren;      
      change.child = FALSE;
    }
  }

  /* compression functions */ 

  // currently DPCM
  void computeTransform() {
    uint8_t cIdx, mIdx;
    for (cIdx = 0; cIdx < compSelfInfo.numChildren; cIdx++) {
      for (mIdx = 0; mIdx < NUM_MEASUREMENTS; mIdx++)
        childBuffer[cIdx].store->partial[mIdx + childBuffer[cIdx].count*NUM_MEASUREMENTS] -= selfBuffer.partial[mIdx + (1 - childEpochNumber%2)*NUM_MEASUREMENTS];
    }
  }

  task void temporalOnlyCompressionTask() {
    uint8_t mIdx;
    for (mIdx = 0; mIdx < NUM_MEASUREMENTS; mIdx++) {
      selfTempBuffer.partial[mIdx + (selfEpochNumber%(BIT_WIDTH/BIT_ALLOCATION))*NUM_MEASUREMENTS] = selfBuffer.partial[mIdx + (selfEpochNumber%2)*NUM_MEASUREMENTS];
    }    
  }

  // currently fixed quantization encoding
  task void encodeCoefficientsTask() {
    uint8_t cIdx, mIdx;
    uint8_t start, entry;
    int8_t offset;
    for (cIdx = 0; cIdx < compSelfInfo.numChildren; cIdx++) {
      childBuffer[cIdx].count++;
      if (childBuffer[cIdx].count%(BIT_WIDTH/BIT_ALLOCATION) == 0) {
        start = ((childBuffer[cIdx].count - 1)/(BIT_WIDTH/BIT_ALLOCATION))*(BIT_WIDTH/BIT_ALLOCATION)*NUM_MEASUREMENTS;
        childBuffer[cIdx].min = childBuffer[cIdx].store->partial[start];
	childBuffer[cIdx].max = childBuffer[cIdx].store->partial[start];
        for (mIdx = 0; mIdx < (BIT_WIDTH/BIT_ALLOCATION)*NUM_MEASUREMENTS; mIdx++) {
	  if (childBuffer[cIdx].min > childBuffer[cIdx].store->partial[start + mIdx])
	    childBuffer[cIdx].min = childBuffer[cIdx].store->partial[start + mIdx];
	  if (childBuffer[cIdx].max < childBuffer[cIdx].store->partial[start + mIdx])
	    childBuffer[cIdx].max = childBuffer[cIdx].store->partial[start + mIdx];
	}
        if ((childBuffer[cIdx].max - childBuffer[cIdx].min) >= QUANTIZATION_FACTOR) {
	  for (mIdx = 0; mIdx < (BIT_WIDTH/BIT_ALLOCATION)*NUM_MEASUREMENTS; mIdx++) {	  
	    childBuffer[cIdx].store->partial[start + mIdx] -= childBuffer[cIdx].min;
	    childBuffer[cIdx].store->partial[start + mIdx] = (QUANTIZATION_FACTOR*childBuffer[cIdx].store->partial[start + mIdx])/(childBuffer[cIdx].max-childBuffer[cIdx].min+1);
	  }
	}
	for (mIdx = 0; mIdx < (BIT_WIDTH/BIT_ALLOCATION)*NUM_MEASUREMENTS; mIdx++) {
	  entry = (mIdx*BIT_ALLOCATION)/BIT_WIDTH + (childBuffer[cIdx].seqNum%2)*NUM_MEASUREMENTS;
	  offset = BIT_WIDTH - BIT_ALLOCATION - ((mIdx*BIT_ALLOCATION)%BIT_WIDTH);
	  if (offset > 0) { 
	    childBuffer[cIdx].store->full[entry] = childBuffer[cIdx].store->full[entry] | (childBuffer[cIdx].store->partial[start + mIdx] << offset);
	  } else {
	    childBuffer[cIdx].store->full[entry] = childBuffer[cIdx].store->full[entry] | (childBuffer[cIdx].store->partial[start + mIdx] >> (-offset));
	    childBuffer[cIdx].store->full[entry + 1] = childBuffer[cIdx].store->full[entry + 1] | (childBuffer[cIdx].store->partial[start + mIdx] << (BIT_WIDTH + offset));
	  }
	}
	childBuffer[cIdx].seqNum++;
	sendCompPacket(cIdx);
      }
      if (childBuffer[cIdx].count == 2*(BIT_WIDTH/BIT_ALLOCATION))
        childBuffer[cIdx].count = 0;
    } 
    childEpochNumber++;
    return;
  }


  task void encodeCoefficientsTempTask() {
    uint8_t cIdx, mIdx;
    uint8_t start, entry;
    int8_t offset;
    for (cIdx = 0; cIdx < compSelfInfo.numChildren; cIdx++) {
      childBuffer[cIdx].count++;
      if (childBuffer[cIdx].count%(BIT_WIDTH/BIT_ALLOCATION - 1) == 0) {
        start = ((childBuffer[cIdx].count - 1)/(BIT_WIDTH/BIT_ALLOCATION - 1))*(BIT_WIDTH/BIT_ALLOCATION - 1)*NUM_MEASUREMENTS;
        childBuffer[cIdx].store->full[0] = childBuffer[cIdx].store->partial[start];
        last = childBuffer[cIdx].store->full[0];
        // find min, max
	// if max - min >= (1 << BIT_ALLOCATION) 
	// loop: (i) = (i) - last
	//       (i) = quant(i)
	//        if (i) >= (1 << BIT_ALLOCATION)
	//           (i) = (1 << BIT_ALLOCATION) - 1;
	for (mIdx = 0; mIdx < (BIT_WIDTH/BIT_ALLOCATION)*NUM_MEASUREMENTS; mIdx++) {
	  entry = (mIdx*BIT_ALLOCATION)/BIT_WIDTH + (childBuffer[cIdx].seqNum%2)*NUM_MEASUREMENTS;
	  offset = BIT_WIDTH - BIT_ALLOCATION - ((mIdx*BIT_ALLOCATION)%BIT_WIDTH);
	  if (offset > 0) { 
	    childBuffer[cIdx].store->full[entry] = childBuffer[cIdx].store->full[entry] | (childBuffer[cIdx].store->partial[start + mIdx] << offset);
	  } else {
	    childBuffer[cIdx].store->full[entry] = childBuffer[cIdx].store->full[entry] | (childBuffer[cIdx].store->partial[start + mIdx] >> (-offset));
	    childBuffer[cIdx].store->full[entry + 1] = childBuffer[cIdx].store->full[entry + 1] | (childBuffer[cIdx].store->partial[start + mIdx] << (BIT_WIDTH + offset));
	  }
	}
	childBuffer[cIdx].seqNum++;
	sendCompPacket(cIdx);
      }
      if (childBuffer[cIdx].count == 2*(BIT_WIDTH/BIT_ALLOCATION))
        childBuffer[cIdx].count = 0;
    } 
    childEpochNumber++;
    return;
  }

  /* packet handling functions */

  /* raw data to parent */
  void sendRawPacket() {
    uint8_t i;
    comp_queue_entry_t *qe = call QEntryPool.get();
    comp_msg_t *msg = (comp_msg_t *)call Packet.getPayload(&(qe->msg), NULL);
    msg->type = COEFF_M1; 
    msg->src = TOS_NODE_ID;
    msg->parent = compSelfInfo.currParent;
    msg->seq = selfEpochNumber-1;
    for (i = 0; i < NUM_MEASUREMENTS; i++) {
      msg->data[i] = selfBuffer.partial[i + (selfEpochNumber%2)*NUM_MEASUREMENTS];
    }
    if (call SendQueue.enqueue(qe) == SUCCESS) {
      post sendTask();
    }
    return;
  }

  void sendCompPacket(uint8_t cIdx) {
    uint8_t i;
    comp_queue_entry_t *qe = call QEntryPool.get();
    comp_msg_t *msg = (comp_msg_t *)call Packet.getPayload(&(qe->msg), NULL);
    msg->type = FULL; // is this needed?
    msg->src = childBuffer[cIdx].id;
    msg->parent = TOS_NODE_ID;
    msg->seq = childBuffer[cIdx].seqNum;
    msg->min = childBuffer[cIdx].min;
    msg->max = childBuffer[cIdx].max;
    for (i = 0; i < NUM_MEASUREMENTS; i++) {
      msg->data[i] = childBuffer[cIdx].store->full[i + (1 - (childBuffer[cIdx].seqNum%2))*NUM_MEASUREMENTS];
      childBuffer[cIdx].store->full[i + (1 - (childBuffer[cIdx].seqNum%2))*NUM_MEASUREMENTS] = 0;
    }
    if (call SendQueue.enqueue(qe) == SUCCESS) {
      post sendTask();
    }
    return;
  }

 /* test/debug functions */

  /* raw data to sink */
  void sendSinkPacket() {
    uint8_t i;
    comp_queue_entry_t *qe = call QEntryPool.get();
    comp_msg_t *msg = (comp_msg_t *)call Packet.getPayload(&(qe->msg), NULL);
    msg->type = RAW; 
    msg->src = TOS_NODE_ID;
    msg->parent = compSelfInfo.currParent;
    msg->seq = selfEpochNumber-1;
    for (i = 0; i < NUM_MEASUREMENTS; i++) {
      msg->data[i] = selfBuffer.partial[i + (selfEpochNumber%2)*NUM_MEASUREMENTS];
    }

    if (call SendQueue.enqueue(qe) == SUCCESS) {
      post sendTask();
    }
    return;
  }

  /* table functions */
  uint8_t searchTable(uint8_t type, uint16_t id) {
    uint8_t pos;
    for (pos = 0; pos < compSelfInfo.numChildren; pos++) {
      if (childBuffer[pos].id == id)
        return pos;
    }
    return 0xFF;
  }
  
}

