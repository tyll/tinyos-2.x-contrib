/* Copyright (c) 2007 ETH Zurich.
*  All rights reserved.
*
*  Redistribution and use in source and binary forms, with or without
*  modification, are permitted provided that the following conditions
*  are met:
*
*  1. Redistributions of source code must retain the above copyright
*     notice, this list of conditions and the following disclaimer.
*  2. Redistributions in binary form must reproduce the above copyright
*     notice, this list of conditions and the following disclaimer in the
*     documentation and/or other materials provided with the distribution.
*  3. Neither the name of the copyright holders nor the names of
*     contributors may be used to endorse or promote products derived
*     from this software without specific prior written permission.
*
*  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS `AS IS'
*  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
*  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
*  ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS
*  BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
*  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, LOSS OF USE, DATA,
*  OR PROFITS) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
*  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
*  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
*  THE POSSIBILITY OF SUCH DAMAGE.
*
*  For additional information see http://www.btnode.ethz.ch/
* 
*  @author: Roman Lim <lim@tik.ee.ethz.ch>
*
*/

#include "NeighbourSync.h"
#include "CC2420.h"
#include "DefaultLpl.h"
#include <Timer.h>

module NeighbourSyncP {
  provides {
    interface Send;
    interface Receive;
    interface NeighbourSyncRequest;
    interface NeighbourSyncInfo;
    interface NeighbourSyncPacket;
    interface NeighbourSyncFlowPacket;
    interface PacketLogger;
  }
  uses {
    interface Send as SubSend;
    interface Receive as SubReceive;
    interface Alarm<T32khz,uint32_t>;
    interface PowerCycle;
    interface RadioTimeStamping;
    interface CC2420Transmit;
    interface TimedPacket;
    interface CC2420PacketBody;
    interface PacketAcknowledgements;
    interface State as RadioPowerState;
    interface State as SyncSendState;
    interface State as SendState;
    interface Timer<TMilli> as UpdateTimer;
    
    interface SplitControl as SubControl;
    interface RadioBackoff as SubBackoff[am_id_t amId];
 
    interface AMSend;
    interface LowPowerListening;

#ifdef CC2420SYNC_DEBUG   
    interface DsnSend as DSN;
    interface DsnCommand<uint8_t> as SyncstatCommand;
#endif    
  }
}

implementation {

  neighbour_sync_item_t n_table[NEIGHBOURSYNCTABLESIZE];
  uint8_t numEntries=0;
  uint32_t lastWakeup;
  uint8_t m_len;
  norace nx_uint32_t offset; // offset has a well defined write order
  norace uint16_t offset_stamp; // offset has a well defined write order
  message_t * m_msg;
  uint8_t lastReplaceIndex=0;
  bool m_cca, m_timed_send=FALSE;
  uint16_t m_rxInterval;
  uint16_t packetCounter=0;
  
  //uint32_t t[10];
  uint32_t t_radio_on;
  uint8_t state_error;
  uint8_t retries=0;
  bool delayedDriftUpdate=FALSE;
  
  norace uint32_t lplPeriod32Khz;
  
  message_t resync_msg;
  
 enum {
    CC2420_SIZE = MAC_HEADER_SIZE + MAC_FOOTER_SIZE,
    SYNC_HEADER_SIZE = sizeof(neighbour_sync_header_t),
  };

  enum {
    S_OFF, // off by default
    S_ON,
  };

  enum {   // send states
	S_IDLE,
    S_PREPARE_RADIO,
    S_LOAD_DATA,
    S_PACKET_READY,
    S_SEND,
  };

  /***************** Prototypes *********/
  neighbour_sync_header_t* getSyncHeader(message_t * msg, uint8_t len ) ;
  bool tableFull();
  neighbour_sync_item_t* getSyncItem(am_addr_t lladdr);
  neighbour_sync_item_t* addNewEntry (am_addr_t lladdr);
  neighbour_sync_item_t* replaceLeastUsedEntry (am_addr_t lladdr);
  void calculateDrift(neighbour_sync_item_t* item);
  void printtable();
  void send();
  void finishDriftUpdate();
  
  task void startRadio();
  task void signalSendDoneFail();
  task void updateDriftTable();
  //task void reportTimes();

  /***************** Send Commands ***************/
  command error_t Send.send(message_t *msg, uint8_t len) {
      neighbour_sync_header_t * header;
      am_addr_t dest;
      neighbour_sync_item_t* item;
      uint32_t now;
      int32_t driftCompensation;
      uint32_t lastSync;
      uint32_t halfdrift;
      uint32_t wakeup_delay;
      cc2420_metadata_t * meta = (call CC2420PacketBody.getMetadata( msg ));
            
      if (len - CC2420_SIZE + SYNC_HEADER_SIZE <= call SubSend.maxPayloadLength()) {
        atomic  {
          m_len = len;
          m_cca=TRUE;
          m_timed_send=FALSE;
          m_msg = msg;
          //t[0]=call Alarm.getNow();
        }
#if LPL_DEFAULT_SLEEP_INTERVAL!=0
        meta->rxInterval = LPL_DEFAULT_SLEEP_INTERVAL;
#endif
        m_rxInterval=meta->rxInterval;
        header = getSyncHeader(msg, len);
        header->lplPeriod = call PowerCycle.getSleepInterval() | (meta->more * MORE_FLAG);
        header->wakeupOffset = NO_VALID_OFFSET;
        dest = (call CC2420PacketBody.getHeader(msg))->dest;
        item=getSyncItem(dest);
        if ((item!=NULL) && (item->lplPeriod!=0) && (meta->rxInterval > 0)
        		&& (item->failCount<SYNC_FAIL_THRESHOLD) && (item->measurementCount>0)) {
        	// timed send
        	// these caclulations take about 5ms without debug output

        	atomic {
        		m_timed_send=TRUE;
        	}
        	meta->synced=TRUE;
        	call SyncSendState.forceState(S_PREPARE_RADIO);
        	lplPeriod32Khz = item->lplPeriod;
        	lastSync=item->wakeupAverage;
        	now = call Alarm.getNow();
        	if (item->drift!=NO_VALID_DRIFT) {
        		meta->rxInterval=0;
        		if (item->drift<0) { // negative drift
        			item->drift=-item->drift;
        			// TODO: find more efficient calculation for this
        			//driftCompensation=(((now - lastSync) >> 1) * n_table[idx].drift) >> 20;
        			driftCompensation=(((now - lastSync) / 2) * item->drift) / 1048576;
        			item->drift=-item->drift;      
        			/*        			
        			call DSN.logInt(driftCompensation);
        			call DSN.logInt(-item->drift);
        			call DSN.logInt(now - lastSync);
        			call DSN.log("comp -%i, drift -%i, period %i");
        			*/
        			driftCompensation=-driftCompensation;
        		}
        		else {	// positive drift
        			//driftCompensation=(((now - lastSync)>>1) * n_table[idx].drift) >> 20;
        			driftCompensation=(((now - lastSync)/2) * item->drift) / 1048576;
        			/*
        			call DSN.logInt(driftCompensation);
        			call DSN.logInt(item->drift);
        			call DSN.logInt(now - lastSync);
        			call DSN.log("comp %i, drift %i, period %i");
        			*/
        		}
        		/**
        		 * past time in neighbour node since avg wakeup
        		 * 		now - lastSync - driftCompensation + halfdrift
        		 * time until next wakeup on neighbour node
        		 * 		lplPeriod32Khz - ( now - lastSync - driftCompensation+ halfdrift) % lplPeriod32Khz
        		 * time until next wakeup on this node
        		 * 		lplPeriod32Khz - ( now - lastSync - driftCompensation+ halfdrift) % lplPeriod32Khz + driftCompensation(time until next wakeup on neighbour node)
        		 **/
        		halfdrift=item->odd * (lplPeriod32Khz >> 1);
        		// wakeup_delay [1..lplPeriod32Khz]
        		wakeup_delay=lplPeriod32Khz - (now - lastSync - driftCompensation + halfdrift + ALARM_OFFSET - REVERSE_SEND_OFFSET + CC2420_ACK_WAIT_DELAY) % lplPeriod32Khz;
        		if (item->drift<0) { // negative drift
        			item->drift=-item->drift;
        		    driftCompensation=(wakeup_delay * item->drift) >> 21;
        		    item->drift=-item->drift;
        		    driftCompensation=-driftCompensation;
        		}
        		else {	// positive drift
        			driftCompensation=(wakeup_delay * item->drift) >> 21;
        		}
        		wakeup_delay+=driftCompensation;
        		if (call Alarm.getNow() - (now + wakeup_delay) < 0x80000000) // getNow is later than estimated wakeup time
        			wakeup_delay+=lplPeriod32Khz;
       			call Alarm.startAt(now, wakeup_delay);
#ifdef CC2420SYNC_DEBUG
       			/*
       			atomic {
       				call DSN.logInt(call Alarm.getNow());
       				call DSN.logInt(now);
       				call DSN.logInt(wakeup_delay);
       				call DSN.logInt(now+wakeup_delay);
       			}
       			call DSN.log("calculations time:%i base:%i delay:%i etf:%i");
       			*/
#endif        		
        	}
        	else {
        		meta->rxInterval=20;
        		call Alarm.startAt(now, lplPeriod32Khz - (now - lastSync + ALARM_OFFSET - REVERSE_SEND_OFFSET + CC2420_ACK_WAIT_DELAY + NO_COMPENSATION_OFFSET) % lplPeriod32Khz);
        	}
        	/*
        	call DSN.logInt(lplPeriod32Khz - (now - n_table[idx].lastSync) % lplPeriod32Khz);
        	call DSN.logInt(lplPeriod32Khz - (now - n_table[idx].lastSync + ALARM_OFFSET) % lplPeriod32Khz);
        	call DSN.log("timed packet in %i ticks, startup in %i ticks");
        	*/
        	// save some statistics for table maintenance 
        	if (item->usageCount < 0xffff)
        		item->usageCount++;
        	if (++packetCounter == TOTAL_AGING_PERIOD) {
        		uint8_t i;
        		// do aging of table entires
        		for (i=0;i<numEntries;i++) {
        			if (n_table[i].usageCount<AGING_PERIOD)
        				n_table[i].usageCount=0;
        			else
        				n_table[i].usageCount-=AGING_PERIOD;
        		}
        		packetCounter=0;
        	}
        	return SUCCESS;
        }
        else {
          if (dest!=AM_BROADCAST_ADDR && meta->rxInterval!=0) {
        	  header->lplPeriod |= REQ_SYNC_FLAG; // request resynchronisation
          }
          else if (item!=NULL && item->lplPeriod>0 && meta->rxInterval==0) { // subsequent packet
        	  atomic m_cca=FALSE;
          }
          meta->synced=FALSE;
          now = call Alarm.getNow();
          offset_stamp=(uint16_t) now;
          offset=now - call PowerCycle.getLastWakeUp();
          return call SubSend.send(msg, len + SYNC_HEADER_SIZE);
        }
      }
      else {
        //call DSN.logInt(len);
        //call DSN.logError("packet too long: %i");
        //call DSN.logPacket(msg);
        return ESIZE;
      }
  }

  command error_t Send.cancel(message_t *msg) {
	if (call SyncSendState.getState() == S_PREPARE_RADIO) {
		call SyncSendState.forceState(S_IDLE);
		return SUCCESS;
	}
	else
		return call SubSend.cancel(msg);
  }
  
  command uint8_t Send.maxPayloadLength() {
    return call SubSend.maxPayloadLength() - SYNC_HEADER_SIZE;
  }

  command void *Send.getPayload(message_t* msg, uint8_t len) {
    return call SubSend.getPayload(msg, len);
  }

  /***************** SubSend Events ***************/
  event void SubSend.sendDone(message_t* msg, error_t error) {
	  // return ERETRY on cca fail for synced packets,
	  // retry later
	neighbour_sync_item_t* item;
    error_t senderror;
    call SyncSendState.toIdle();
    finishDriftUpdate();
    if (error==ERETRY && m_timed_send) {
    	// setup new timed message
    	(call CC2420PacketBody.getHeader(msg))->length = m_len;	// set the right length
    	(call CC2420PacketBody.getMetadata( msg ))->rxInterval = m_rxInterval;
    	if ((senderror=call Send.send(m_msg, m_len))!=SUCCESS) {
    		(call CC2420PacketBody.getHeader(msg))->length = m_len;	// set the right length
    		(call CC2420PacketBody.getMetadata( msg ))->rxInterval = m_rxInterval;
    		signal Send.sendDone(msg, senderror);
    		//call DSN.logInt(senderror);
    		//call DSN.log("resend failed %i");
    	}
    	else
    		retries++;
    }
    else {
    	item = getSyncItem((call CC2420PacketBody.getHeader(msg))->dest);
    	if (((call CC2420PacketBody.getHeader(msg))->fcf & IEEE154_FCF_ACK_REQ)!=0
          && item!=NULL && (call CC2420PacketBody.getMetadata( msg ))->synced) {
    		if (call PacketAcknowledgements.wasAcked(msg))
    			item->failCount=0;
    		else {
    			item->failCount++;
    			if ((call CC2420PacketBody.getMetadata( msg ))->snoopedAcks > 0) {
    				//call DSN.logInt((call CC2420PacketBody.getMetadata( msg ))->snoopedAcks);
    				//call DSN.log("delayed ack %i");
    			}
    		}
    	}
    	(call CC2420PacketBody.getMetadata( msg ))->retries = retries;
    	retries=0;
    	(call CC2420PacketBody.getHeader(msg))->length = m_len;	// set the right length
    	(call CC2420PacketBody.getMetadata( msg ))->rxInterval = m_rxInterval;
    	signal PacketLogger.sendDone(msg, error);
    	signal Send.sendDone(msg, error);
    }
  }
  
  /***************** SubReceive Events ***************/
  
  event message_t *SubReceive.receive(message_t* msg, void* payload, 
      uint8_t len) {    
    neighbour_sync_header_t * header;
    neighbour_sync_item_t * item;
    cc2420_metadata_t * meta;
    uint32_t now;
    uint32_t newSync;
    
    am_addr_t address = (call CC2420PacketBody.getHeader(msg))->src;
    header = getSyncHeader(msg, len-SYNC_HEADER_SIZE);
    if ((header->lplPeriod & ~(REQ_SYNC_FLAG|MORE_FLAG)) > 0) {
    	item=getSyncItem(address);
    	if (item==NULL) {
    		if (tableFull()) {
    			item=replaceLeastUsedEntry (address);
    		}
    		else {
    			item=addNewEntry (address);
    		}
    	}
#ifdef CC2420SYNC_NO_HISTORY_REFILL
    	if (item->measurementCount < MEASURE_HISTORY_SIZE)
#endif    		
        // add new measurement
        if (header->wakeupOffset != NO_VALID_OFFSET) {
        	now = call Alarm.getNow();
        	meta = call CC2420PacketBody.getMetadata(msg);
        	newSync = now - ((uint16_t)now - meta->time) - header->wakeupOffset;
        	if (newSync - item->newTimestamp >= MIN_MEASUREMENT_PERIOD) {
        		item->lplPeriod=((uint32_t)(header->lplPeriod & ~(REQ_SYNC_FLAG|MORE_FLAG))) << T32KHZ_TO_TMILLI_SHIFT; // save in table as 32khz ticks
        		item->newTimestamp = newSync;
        		item->failCount=0;
        		item->dirty=TRUE;
       			call UpdateTimer.startOneShot(TABLE_UPDATE_DELAY);
        	}
        }
        else
        	;//call DSN.log("no valid offset");
    }
    if ((header->lplPeriod & REQ_SYNC_FLAG) != 0) {
    	signal NeighbourSyncRequest.updateRequest(address, header->lplPeriod & ~(REQ_SYNC_FLAG|MORE_FLAG));
    }

#ifdef CC2420SYNC_DEBUG
    // print accuracy of packet
    /*
    if ((call CC2420PacketBody.getHeader(msg))->dest == TOS_NODE_ID) {
    	call DSN.logInt(address);  	    	
    	call DSN.logInt((call CC2420PacketBody.getMetadata(msg))->time - call PowerCycle.getLastWakeUp());
    	call DSN.logInt((t_radio_on & 0xffff) - call PowerCycle.getLastWakeUp());    	
    	call DSN.log("rx packet from %i, at %i, on at %i");
    }
    */
#endif
    (call CC2420PacketBody.getHeader(msg))->length = len - SYNC_HEADER_SIZE;
    signal PacketLogger.received(msg);
    return signal Receive.receive(msg, payload, len - SYNC_HEADER_SIZE);
  }
  
  /***************** UpdateTimer Events ***************/
  
  event void UpdateTimer.fired() {
  	  post updateDriftTable();
  }

  /***************** Alarm Events ***************/
  async event void Alarm.fired() {
	  atomic {
		  switch (call SyncSendState.getState()) {
		  case S_PREPARE_RADIO:
			  if (call SendState.requestState(S_LPL_SYNCWAIT)==SUCCESS) {
#ifdef CC2420SYNC_DEBUG_PINS
     TOSH_SET_GIO2_PIN();
#endif
				  post startRadio();
			  }
			  else {
				  state_error=1;
				  post signalSendDoneFail();
			  }
			  //t[1]=call Alarm.getAlarm();
			  break;
		  case S_SEND:
			  if (call CC2420Transmit.resend(m_cca)!=SUCCESS) {
				  state_error=2;
				  post signalSendDoneFail();
			  }
			  //if (m_timed_send) post reportTimes();
			  //t[5]=call Alarm.getAlarm();
			  break;
		}
	  }
  }

  /***************** TimeStamping Events ***************/
  async event void RadioTimeStamping.receivedSFD(uint16_t time) {
  } 
 
  async event void RadioTimeStamping.transmittedSFD(uint16_t time, message_t *p_msg) {
	offset+= time - offset_stamp;
    call CC2420Transmit.modify( m_len -1 , (uint8_t * )&offset, 4 );
    offset_stamp = time;
    //t[6]=call Alarm.getNow();
  }

  /***************** TimedPacket Events ******************/
  async event bool TimedPacket.requestImmediatePacket(message_t* p_msg) { 
	  atomic {
		  if (call SyncSendState.getState()==S_PACKET_READY) {
#ifdef CC2420SYNC_DEBUG_PINS
     TOSH_CLR_GIO2_PIN();
#endif
			  call SyncSendState.forceState(S_SEND);
			  //t[4]=call Alarm.getNow();
			  if ((call Alarm.getAlarm()+RADIO_STARTUP_OFFSET) - call Alarm.getNow() < 0x8000)
				  call Alarm.startAt(call Alarm.getAlarm(), RADIO_STARTUP_OFFSET);
			  else 
				  call Alarm.startAt(call Alarm.getAlarm(), RADIO_STARTUP_OFFSET +  lplPeriod32Khz); // we missed the right point, try one period later
		  }
		  return !m_timed_send;
	  }
  }
  
  /***************** CC2420Transmit Events ***************/
  async event void CC2420Transmit.sendDone(message_t* p_msg, error_t error) {
  }

 /***************** SubControl Events ****************/
  event void SubControl.startDone(error_t error) {
    if (!error) {
    	t_radio_on=call Alarm.getNow();
    	call RadioPowerState.forceState(S_ON);
    }
    if (call SyncSendState.getState()==S_LOAD_DATA) {
    	send();
    }    
  }
  
  event void SubControl.stopDone(error_t error) {
    if (!error) {
      call RadioPowerState.forceState(S_OFF);
      if (call UpdateTimer.isRunning()) {
    	  call UpdateTimer.stop();
    	  post updateDriftTable();
      }
    }
  }

 /***************** PowerCycle Events ****************/
  event void PowerCycle.detected() {}

  /***************** RadioBackoff Events *************/
  async event void SubBackoff.requestInitialBackoff[am_id_t amId](message_t *msg) {
  }

  async event void SubBackoff.requestCongestionBackoff[am_id_t amId](message_t *msg) {
  }
  
  async event void SubBackoff.requestCca[am_id_t amId](message_t *msg) {
      call SubBackoff.setCca[amId](m_cca);
  }

  /***************** NeighbourSyncInfo commands ***************/
  command error_t NeighbourSyncInfo.getRxSleepInterval(am_addr_t neighbour, uint16_t* interval) {
	  neighbour_sync_item_t* item;
	  if ((item=getSyncItem(neighbour)) != NULL) {
		  *interval=item->lplPeriod;
		  return SUCCESS;
	  }
	  return FAIL;
  }
  
  /***************** NeighbourSyncPacket commands ***************/
	/**
	 * return state of MORE_FLAG
	 * This command can only be applied to packets that still contain the neighboursync footer
	 **/
    command bool NeighbourSyncPacket.isMore(message_t* msg) {
    	return (getSyncHeader(msg, (call CC2420PacketBody.getHeader(msg))->length-SYNC_HEADER_SIZE)->lplPeriod & MORE_FLAG) !=0;
    }
    
  /***************** NeighbourSyncFlowPacket commands ***************/
 	/**
 	 * set state of MORE_FLAG
 	 * This command can only be applied to packets that do _not_ contain the neighboursync footer, e.g. higher
 	 * layer components should access this interface. 
   	 **/
     command void NeighbourSyncFlowPacket.setMore(message_t* msg) {
    	(call CC2420PacketBody.getMetadata( msg ))->more=TRUE;
     }
     command void NeighbourSyncFlowPacket.clearMore(message_t* msg) {
     	(call CC2420PacketBody.getMetadata( msg ))->more=FALSE;
     }
  /***************** NeighbourSyncRequest events ***************/
  default event void NeighbourSyncRequest.updateRequest(am_addr_t address, uint16_t lplPeriod) {
	  call LowPowerListening.setRxSleepInterval(&resync_msg, lplPeriod);
	  call AMSend.send(address, &resync_msg, 0);
  }
  
  /***************** PacketLogger events ***************/
   default event void PacketLogger.received(message_t* msg) {
   }
   
   default event void PacketLogger.sendDone(message_t* msg, error_t error) {
   }
  
  /***************** AMSend events *************/
  event void AMSend.sendDone(message_t* msg, error_t error) {
#ifdef CC2420SYNC_DEBUG 
	  call DSN.log("sent unicast resync packet");
#endif	  
  }

  /***************** DSN events *************/
#ifdef CC2420SYNC_DEBUG
  event void SyncstatCommand.detected(uint8_t * values, uint8_t n) {
	  printtable();
  }
#endif
  /***************** Functions ***********************/

  neighbour_sync_header_t* getSyncHeader(message_t * msg, uint8_t len ) {
    return (neighbour_sync_header_t*) (msg->data - CC2420_SIZE + len);
  }
  /***************** Neighbourtable Functions ***********************/

  neighbour_sync_item_t* getSyncItem(am_addr_t lladdr) {
    uint8_t i;
    for (i=0;i<numEntries;i++)
      if (n_table[i].address == lladdr)
        return &n_table[i];
    return NULL;
  }

  bool tableFull() {
    return numEntries >= NEIGHBOURSYNCTABLESIZE;
  }
  
  void initTableEntry(neighbour_sync_item_t* entry) {
	  entry->measurementCount = 0;
	  entry->newTimestamp = call Alarm.getNow() - (MIN_MEASUREMENT_PERIOD << 1);
	  entry->usageCount = 0;
	  entry->failCount = 0;
	  entry->drift = NO_VALID_DRIFT;
	  entry->dirty = FALSE;
	  entry->driftLimitCount=0;
  }

  neighbour_sync_item_t* addNewEntry (am_addr_t lladdr) {
    if (tableFull()) return NULL;
    initTableEntry(&n_table[numEntries]);
    n_table[numEntries].address = lladdr;
    return &n_table[numEntries++];
  }

  neighbour_sync_item_t* replaceLeastUsedEntry (am_addr_t lladdr) {
    uint8_t i;
    uint16_t minUsageCount=0xffff;
    uint8_t minUsageIndex=0;

#ifdef CC2420SYNC_DEBUG
    call DSN.logInt(lladdr);
	call DSN.log("replace entry with %i");
#endif

    lastReplaceIndex++;
    for (i=0;i<numEntries;i++)
      if (n_table[(i+lastReplaceIndex) % NEIGHBOURSYNCTABLESIZE].usageCount < minUsageCount) {
        minUsageCount=n_table[(i+lastReplaceIndex) % NEIGHBOURSYNCTABLESIZE].usageCount;
        minUsageIndex=(i+lastReplaceIndex) % NEIGHBOURSYNCTABLESIZE;
      }
    initTableEntry(&n_table[minUsageIndex]);
    n_table[minUsageIndex].address = lladdr;
    lastReplaceIndex=minUsageIndex;
    return &n_table[minUsageIndex];
  }

  void printtable() {
	  /*
    uint8_t i;
    neighbour_sync_item_t* item;
    for (i=0;i<numEntries;i++) {
    	item=&n_table[i];
      call DSN.logInt(i);
      call DSN.logInt(item->address);
      call DSN.logInt(item->wakeupTimestamp[item->measurementCount-1]);
      call DSN.logInt(item->measurementCount);
      call DSN.logInt(item->usageCount);
      call DSN.logInt(item->failCount);
      call DSN.logInt(item->driftLimitCount);
      call DSN.logInt(item->lplPeriod>>T32KHZ_TO_TMILLI_SHIFT);
      call DSN.appendLog("{%i: %i, l:%i, m:%i, u:%i, f:%i, d:%i, lpl:%ims, ");
      if (item->drift>=0) {
    	  call DSN.logInt(item->drift);
    	  call DSN.log("drift:%i}");
      }
      else {
    	  call DSN.logInt(-item->drift);
    	  call DSN.log("drift:-%i}");
      }
    
  }
  */
  }
  
  void finishDriftUpdate() {
	  if (delayedDriftUpdate) {
		  delayedDriftUpdate=FALSE;
		  post updateDriftTable();
	  }
  }
  
  void calculateDrift(neighbour_sync_item_t* item) {
	  uint8_t j;
	  uint32_t timeSum;
	  uint32_t timeDiff=0;
	  uint16_t periods;
	  int32_t driftSum;
	  uint32_t driftError=0;
	  if (item->measurementCount>1) {
		  // calculate drift				  
		  timeSum=0;
		  driftSum=0;
		  periods=0;
		  for (j=1;j<item->measurementCount;j++) {
			  timeDiff=item->wakeupTimestamp[j]-item->wakeupTimestamp[j-1];
			  periods += timeDiff / item->lplPeriod;
			  timeSum+=timeDiff;
			  driftError=timeDiff % item->lplPeriod;
			  if (driftError<(item->lplPeriod >> 1))
				  driftSum+=driftError;
			  else {
				  driftSum-=item->lplPeriod - driftError;
				  periods++;
			  }
		  }
		  item->odd = periods & 0x1;
		  item->wakeupAverage = (timeSum >> 1) + item->wakeupTimestamp[0];
		  if (driftSum<0) {
			  driftSum=-driftSum;
			  item->drift=(driftSum << 19) / (timeSum >> 2); // effectively 2^21
			  item->drift=-item->drift;
#ifdef CC2420SYNC_DEBUG
			  call DSN.logInt(item->address);
			  call DSN.logInt(timeDiff);
			  call DSN.logInt(driftError);
			  call DSN.logInt(-item->drift);
			  call DSN.logInt(item->odd);
			  call DSN.logInt(item->wakeupAverage);
			  call DSN.logInt(item->wakeupTimestamp[0]);
			  call DSN.log("node %i, measure period: %i, drift error=%i, rel=-%i %i %i %i");
#endif					  
		  }
		  else {
			  item->drift=(driftSum << 19) / (timeSum >> 2);
#ifdef CC2420SYNC_DEBUG					  
			  call DSN.logInt(item->address);
			  call DSN.logInt(timeDiff);
			  call DSN.logInt(driftError);
			  call DSN.logInt(item->drift);
			  call DSN.logInt(item->odd);
			  call DSN.logInt(item->wakeupAverage);
			  call DSN.logInt(item->wakeupTimestamp[0]);
			  call DSN.log("node %i, measure period: %i, drift error=%i, rel=%i %i %i %i");
#endif					  
		  }
	}
	else { // only one measurement available
		item->wakeupAverage = item->wakeupTimestamp[0];
	}  
  }
  
  /***************** Send Functions ***********************/
  
  void send() {
	  uint32_t now;
	  error_t error;
	  // atomic t[3]=call Alarm.getNow();
	  if (call RadioPowerState.getState()!=S_ON) {
		  //call DSN.logWarning("Radio off when sending started");
	  }
	  now = call Alarm.getNow();
	  offset_stamp=(uint16_t) now;
	  offset=now - call PowerCycle.getLastWakeUp();
	  if ((error = call SubSend.send(m_msg, m_len + SYNC_HEADER_SIZE))!= SUCCESS) {
		  call SyncSendState.toIdle();
		  finishDriftUpdate();
		  (call CC2420PacketBody.getHeader(m_msg))->length = m_len;	// set the right length
	      (call CC2420PacketBody.getMetadata(m_msg))->rxInterval = m_rxInterval;
	      signal Send.sendDone(m_msg, error);
	      //call DSN.logInt(call SendState.getState());
	      //call DSN.log("send failed (subsend %i)");
	      if (call SendState.getState()==S_LPL_SYNCWAIT)
	    	  call SendState.toIdle(); // S_LPL_SYNCWAIT -> S_LPL_NOT_SENDING;
	  }
	  else
		  call SyncSendState.forceState(S_PACKET_READY);
  }
  

  /***************** Tasks ********************************/

  task void signalSendDoneFail() {
	  call SyncSendState.toIdle();
	  finishDriftUpdate();
	  //atomic call DSN.logInt(state_error);
	  //call DSN.log("send failed (state %i)");
	  (call CC2420PacketBody.getHeader(m_msg))->length = m_len;	// set the right length
	  (call CC2420PacketBody.getMetadata(m_msg))->rxInterval = m_rxInterval;
	  signal Send.sendDone(m_msg, FAIL);
  }

  task void startRadio() {
	//atomic t[2]=call Alarm.getNow();
	call SyncSendState.forceState(S_LOAD_DATA);
    if (call RadioPowerState.getState()!=S_ON) {
      call SubControl.start();
    }
    else {
    	send();
    } 
   }
  
  task void updateDriftTable() {
	  uint8_t i, j;
	  neighbour_sync_item_t * item;
	  uint32_t newSync, lastSync;
	  uint32_t driftError;
	  int16_t drift;
	  if (!call SyncSendState.isIdle()) { // avoid critical sections for timing calculations
		  delayedDriftUpdate=TRUE;
		  return;
	  }
	  for (i=0;i<numEntries;i++) {
		  if (n_table[i].dirty) {
			  item = &n_table[i];
			  // check new measurement for sanity
			  // decide whether to add the measurment or not
			  newSync=item->newTimestamp;
			  lastSync=item->wakeupTimestamp[item->measurementCount-1];
			  if (item->measurementCount==0 ||																	// fill empty history 
				  (newSync - lastSync < 0x80000000)) {					// save only sync times later than last one
				  if (item->measurementCount < MEASURE_HISTORY_SIZE) {	// a short measurement history
					  item->wakeupTimestamp[item->measurementCount++]=item->newTimestamp;
					  // calculate new drift...
					  calculateDrift(item);
				  }
				  else {
					  // add entry, if drift over last period does not differ more than DRIFT_CHANGE_LIMIT
					  driftError=(newSync - lastSync) % item->lplPeriod;
					  if (driftError < (item->lplPeriod >> 1)) //positive
						  drift=(driftError << 19) / ((newSync - lastSync) / 4);
					  else {
						  driftError=item->lplPeriod - driftError;
						  drift=-((driftError << 19) / ((newSync - lastSync) / 4));
					  }
			          if ((item->drift>drift && item->drift-drift<DRIFT_CHANGE_LIMIT) ||
			        	  (item->drift<=drift && drift-item->drift<DRIFT_CHANGE_LIMIT)) {
#ifdef CC2420SYNC_DEBUG
			        	  if (drift>=0) {
			        		  call DSN.logInt(drift);
			        		  call DSN.log("drift: %i");
			        	  }
			        	  else {
			        		  call DSN.logInt(-drift);
			        		  call DSN.log("drift: -%i");
			        	  }
#endif  
			        	  // shift stamps
			        	  for (j=0;j<MEASURE_HISTORY_SIZE-1;j++)
			        		  item->wakeupTimestamp[j]=item->wakeupTimestamp[j+1];
			        	  item->wakeupTimestamp[item->measurementCount-1]=newSync;  
			        	  item->driftLimitCount = 0;
			        	  // calculate new drift...
			        	  calculateDrift(item);
			          }
			          else { // drift measurment seems too big 
#ifdef CC2420SYNC_DEBUG
			        	  if (drift>=0) {
			        		  call DSN.logInt(drift);
			        		  call DSN.log("drift out of limit: %i");
			        	  }
			        	  else {
			        		  call DSN.logInt(-drift);
			        		  call DSN.log("drift out of limit: -%i");
			        	  }
#endif        				
			        	  item->driftLimitCount++;
			        	  if (item->driftLimitCount >= MAX_DRIFT_ERRORS) {
			        		  item->measurementCount = 0;
			        		  item->drift = NO_VALID_DRIFT;
			        		  item->driftLimitCount = 0;
#ifdef CC2420SYNC_DEBUG					
			        		  call DSN.logInt(item->address);
			        		  call DSN.log("max limits reached, flush history node %i");
#endif        					
			        	  }
			          } // drift too big
				  }  // check drift      		 
			  } // lpl not 0 or earlier than last
			  else {
#ifdef CC2420SYNC_DEBUG
				  call DSN.log("bad timestamp (earlier than last)");
#endif        		
			  }
			  item->dirty=FALSE;
		  }
	} // for
  }
  
/*    
  task void reportTimes() {
	  atomic {
		  call DSN.logInt(t[1]-t[0]); // alarm offset
		  call DSN.logInt(t[2]-t[0]); // task offset
		  call DSN.logInt(t[3]-t[0]); // send offset
		  call DSN.logInt(t[4]-t[0]); // fifo ready offset
		  call DSN.logInt(t[5]-t[0]); // send allarm offset
		  call DSN.logInt(t[6]-t[0]); // sfd offset
	  }
	  call DSN.log("Times: %i,%i,%i,%i,%i,%i");
  }
  */
}
