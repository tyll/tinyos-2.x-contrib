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
    interface SplitControl as SubControl;
    interface DsnSend as DSN;
    interface RadioBackoff as SubBackoff[am_id_t amId];
    interface State as SendState;
    
    interface AMSend;
    interface LowPowerListening;

#ifdef CC2420SYNC_DEBUG_PINS
    interface GeneralIO as GIO3;
#endif
  }
}

implementation {

  neighbour_sync_item_t n_table[NEIGHBOURSYNCTABLESIZE];
  uint8_t numEntries=0;
  uint32_t lastWakeup;
  uint8_t m_len;
  nx_uint16_t offset;
  message_t * m_msg;
  uint8_t lastReplaceIndex=0;
  bool m_cca, m_timed_send=FALSE;
  uint16_t m_rxInterval;
  uint16_t packetCounter=0;
  
  uint32_t t[10];
  uint32_t t_radio_on;
  uint8_t state_error;
  uint8_t retries=0;
  
  norace uint16_t lplPeriod32Khz;
  
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
  uint8_t getIndex(am_addr_t lladdr);
  bool tableFull();
  uint8_t addNewEntry (am_addr_t lladdr);
  uint8_t replaceLeastUsedEntry (am_addr_t lladdr);
  void printtable();
  void send();
  
  task void startRadio();
  task void signalSendDoneFail();
  task void reportTimes();

  /***************** Send Commands ***************/
  command error_t Send.send(message_t *msg, uint8_t len) {
      neighbour_sync_header_t * header;
      am_addr_t dest;
      uint8_t idx;
      uint32_t now;
      int32_t driftCompensation;
      uint32_t lastSync;
      uint16_t halfdrift;
      uint32_t wakeup_delay;
      cc2420_metadata_t * meta = (call CC2420PacketBody.getMetadata( msg ));

      if (len - CC2420_SIZE + SYNC_HEADER_SIZE <= call SubSend.maxPayloadLength()) {
        atomic  {
          m_len = len;
          m_cca=TRUE;
          m_timed_send=FALSE;
          m_msg = msg;
          t[0]=call Alarm.getNow();
        }
        m_rxInterval=meta->rxInterval;
        header = getSyncHeader(msg, len);
        header->lplPeriod = call PowerCycle.getSleepInterval();
        header->wakeupOffset = NO_VALID_OFFSET;
        dest = (call CC2420PacketBody.getHeader(msg))->dest;
        idx=getIndex(dest);
        if ((idx!=NO_ENTRY) && (n_table[idx].lplPeriod!=0) && (meta->rxInterval > 0)
        		&& (n_table[idx].failCount<SYNC_FAIL_THRESHOLD) && (n_table[idx].measurementCount>0)) {
        	// timed send
        	atomic {
        		// m_cca=FALSE;
        		m_timed_send=TRUE;
        	}
        	meta->synced=TRUE;
        	call SyncSendState.forceState(S_PREPARE_RADIO);
        	lplPeriod32Khz = n_table[idx].lplPeriod << T32KHZ_TO_TMILLI_SHIFT;
        	//lastSync=n_table[idx].wakeupTimestamp[n_table[idx].measurementCount-1];
            /*call DSN.logInt(dest);
            call DSN.logInt(n_table[idx].odd);
            call DSN.log("pkt for %i,%i");*/
        	lastSync=n_table[idx].wakeupAverage;
        	now = call Alarm.getNow();
        	if (n_table[idx].drift!=NO_VALID_DRIFT) {
        		meta->rxInterval=0;
        		if (n_table[idx].drift<0) { // negative drift
        			n_table[idx].drift=-n_table[idx].drift;
        			// TODO: find more efficient calculation for this
        			//driftCompensation=(((now - lastSync) >> 1) * n_table[idx].drift) >> 20;
        			driftCompensation=(((now - lastSync) / 2) * n_table[idx].drift) / 1048576;
        			n_table[idx].drift=-n_table[idx].drift;        		
        			/*call DSN.logInt(driftCompensation);
        			call DSN.logInt(n_table[idx].drift);
        			call DSN.logInt(now - lastSync);
        			call DSN.log("comp -%i, drift -%i, period %i");*/
        			driftCompensation=-driftCompensation;
        		}
        		else {	// positive drift
        			//driftCompensation=(((now - lastSync)>>1) * n_table[idx].drift) >> 20;
        			driftCompensation=(((now - lastSync)/2) * n_table[idx].drift) / 1048576;
        			/*call DSN.logInt(driftCompensation);
        			call DSN.logInt(n_table[idx].drift);
        			call DSN.logInt(now - lastSync);
        			call DSN.log("comp %i, drift %i, period %i");*/
        		}
        		/**
        		 * past time in neighbour node since avg wakeup
        		 * 		now - lastSync - driftCompensation + halfdrift
        		 * time until next wakeup on neighbour node
        		 * 		lplPeriod32Khz - ( now - lastSync - driftCompensation+ halfdrift) % lplPeriod32Khz
        		 * time until next wakeup on this node
        		 * 		lplPeriod32Khz - ( now - lastSync - driftCompensation+ halfdrift) % lplPeriod32Khz + driftCompensation(time until next wakeup on neighbour node)
        		 **/
        		halfdrift=n_table[idx].odd * (lplPeriod32Khz >> 1);
        		// wakeup_delay [1..lplPeriod32Khz]
        		wakeup_delay=lplPeriod32Khz - (now - lastSync - driftCompensation + halfdrift + ALARM_OFFSET - REVERSE_SEND_OFFSET + CC2420_ACK_WAIT_DELAY) % lplPeriod32Khz;
        		if (n_table[idx].drift<0) { // negative drift
        			n_table[idx].drift=-n_table[idx].drift;
        		    driftCompensation=(wakeup_delay * n_table[idx].drift) >> 21;
        		    n_table[idx].drift=-n_table[idx].drift;
        		    driftCompensation=-driftCompensation;
        		}
        		else {	// positive drift
        			driftCompensation=(wakeup_delay * n_table[idx].drift) >> 21;
        		}
        		wakeup_delay+=driftCompensation;
        		if (call Alarm.getNow() - (now + wakeup_delay) < 0x80000000) // getNow is later than estimated wakeup time
        			wakeup_delay+=lplPeriod32Khz;
       			call Alarm.startAt(now, wakeup_delay);
#ifdef CC2420SYNC_DEBUG
       			atomic {
       				call DSN.logInt(call Alarm.getNow());
       				call DSN.logInt(now);
       				call DSN.logInt(wakeup_delay);
       				call DSN.logInt(now+wakeup_delay);
       			}
       			call DSN.log("calculations time:%i base:%i delay:%i etf:%i");
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
        	if (n_table[idx].usageCount < 0xffff)
        		n_table[idx].usageCount++;
        	if (++packetCounter == TOTAL_AGING_PERIOD) {
        		uint8_t i;
        		// do aging of table entires
        		call DSN.log("aging");
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
          meta->synced=FALSE;
          return call SubSend.send(msg, len + SYNC_HEADER_SIZE);
        }
      }
      else {
        call DSN.logInt(len);
        call DSN.logError("packet too long: %i");
        call DSN.logPacket(msg);
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
    uint8_t idx;
    error_t senderror;
    call SyncSendState.toIdle();
    if (error==ERETRY && m_timed_send) {
    	// setup new timed message
    	(call CC2420PacketBody.getHeader(msg))->length = m_len;	// set the right length
    	(call CC2420PacketBody.getMetadata( msg ))->rxInterval = m_rxInterval;
    	if ((senderror=call Send.send(m_msg, m_len))!=SUCCESS) {
    		(call CC2420PacketBody.getHeader(msg))->length = m_len;	// set the right length
    		(call CC2420PacketBody.getMetadata( msg ))->rxInterval = m_rxInterval;
    		signal Send.sendDone(msg, senderror);
    		call DSN.logInt(senderror);
    		call DSN.log("resend failed %i");
    	}
    	else
    		retries++;
    }
    else {
    	idx = getIndex((call CC2420PacketBody.getHeader(msg))->dest);
    	if (((call CC2420PacketBody.getHeader(msg))->fcf & IEEE154_FCF_ACK_REQ)!=0
          && idx!=NO_ENTRY && (call CC2420PacketBody.getMetadata( msg ))->synced) {
    		if (call PacketAcknowledgements.wasAcked(msg))
    			n_table[idx].failCount=0;
    		else
    			n_table[idx].failCount++;
    	}
    	(call CC2420PacketBody.getMetadata( msg ))->retries = retries;
    	retries=0;
    	(call CC2420PacketBody.getHeader(msg))->length = m_len;	// set the right length
    	(call CC2420PacketBody.getMetadata( msg ))->rxInterval = m_rxInterval;
    	signal Send.sendDone(msg, error);
    }
  }
  
  /***************** SubReceive Events ***************/
  
  task void calculateDrift() {
	  uint8_t i, j;
	  neighbour_sync_item_t * item;
	  uint32_t timeSum;
	  uint32_t timeDiff;
	  uint16_t periods;
	  int32_t driftSum;
	  uint32_t driftError;
	  for (i=0;i<NEIGHBOURSYNCTABLESIZE;i++) {
		  if (n_table[i].dirty) {
			  item = &n_table[i];
			  if (n_table[i].measurementCount>1) {
				  // calculate drift				  
				  timeSum=0;
				  driftSum=0;
				  periods=0;
				  for (j=1;j<item->measurementCount;j++) {
					  timeDiff=item->wakeupTimestamp[j]-item->wakeupTimestamp[j-1];
					  periods += timeDiff / (item->lplPeriod << T32KHZ_TO_TMILLI_SHIFT);
					  timeSum+=timeDiff;
					  driftError=(timeDiff) % (item->lplPeriod << T32KHZ_TO_TMILLI_SHIFT);
					  if (driftError<((item->lplPeriod << T32KHZ_TO_TMILLI_SHIFT) >> 1))
						  driftSum+=driftError;
					  else {
						  driftSum-=(item->lplPeriod << T32KHZ_TO_TMILLI_SHIFT) - driftError;
						  periods++;
					  }
				  }
				  item->odd = periods % 2 == 1;
				  item->wakeupAverage = (timeSum>>1) + item->wakeupTimestamp[0];
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
		    else {
		    	item->wakeupAverage = item->wakeupTimestamp[0];
		    }
		 item->dirty=FALSE;
		 }
	  }
  }
  
  event message_t *SubReceive.receive(message_t* msg, void* payload, 
      uint8_t len) {    
    neighbour_sync_header_t * header;
    neighbour_sync_item_t * item;
    uint8_t idx, i;
    uint32_t newSync;
    uint32_t driftError;
    int16_t drift;
    
    am_addr_t address = (call CC2420PacketBody.getHeader(msg))->src;
    header = getSyncHeader(msg, len-SYNC_HEADER_SIZE);
    if ((header->lplPeriod & ~REQ_SYNC_FLAG) > 0) {
      idx=getIndex(address);
      if (idx==NO_ENTRY) {
        if (tableFull()) {
#ifdef CC2420SYNC_DEBUG
        	call DSN.logInt(address);
        	call DSN.log("replace entry with %i");
#endif
        	idx=replaceLeastUsedEntry (address);
        }
        else {
          idx=addNewEntry (address);
        }
      }
      if (idx!=NO_ENTRY) {
        cc2420_metadata_t * meta;
        uint32_t now = call Alarm.getNow();
        meta = call CC2420PacketBody.getMetadata(msg);
        item = &n_table[idx];
        item->lplPeriod=header->lplPeriod & ~REQ_SYNC_FLAG;
        if (header->wakeupOffset != NO_VALID_OFFSET && n_table[idx].lplPeriod>0) {
        	// TODO: test ((uint16_t)now - meta->time
        	// set bound to xx ticks ?
        	// call DSN.logInt((uint16_t)now - meta->time);
        	// call DSN.log("stackdelay %i");
        	newSync = now - ((uint16_t)now - meta->time) - header->wakeupOffset;
        	// save only sync times later than last one
        	if (item->measurementCount==0 || 
        			((newSync - item->wakeupTimestamp[item->measurementCount-1] < 0x80000000) &&
        			(newSync - item->wakeupTimestamp[item->measurementCount-1] >= MIN_MEASUREMENT_PERIOD))) {
        		if (item->measurementCount<MEASURE_HISTORY_SIZE) {
        			item->wakeupTimestamp[item->measurementCount++]=newSync;        			
        			item->failCount=0;
        			item->dirty=TRUE;
        			post calculateDrift();
        		}
        		else {
        			// add entry, if drift over last period does not differ more than DRIFT_CHANGE_LIMIT
        			driftError=(newSync-item->wakeupTimestamp[MEASURE_HISTORY_SIZE-1]) % (item->lplPeriod << T32KHZ_TO_TMILLI_SHIFT);
        			if (driftError<((item->lplPeriod << T32KHZ_TO_TMILLI_SHIFT) >> 1)) {//pos
        				drift=(driftError << 19) / ((newSync-item->wakeupTimestamp[MEASURE_HISTORY_SIZE-1]) / 4);
        				/*call DSN.logInt(drift);
        				call DSN.log("added drift %i");*/
        			}
        			else {
        				drift=-((((uint32_t)((item->lplPeriod << T32KHZ_TO_TMILLI_SHIFT) - driftError)) << 19) / ((newSync-item->wakeupTimestamp[MEASURE_HISTORY_SIZE-1]) / 4));
        				/*call DSN.logInt(-drift);
        				call DSN.log("added drift -%i");*/
        			}
        			if ((item->drift>drift && item->drift-drift<DRIFT_CHANGE_LIMIT) ||
        				(item->drift<=drift && drift-item->drift<DRIFT_CHANGE_LIMIT)) {
        				// shift stamps
        				for (i=0;i<MEASURE_HISTORY_SIZE-1;i++)
        					item->wakeupTimestamp[i]=item->wakeupTimestamp[i+1];
        				item->wakeupTimestamp[item->measurementCount-1]=newSync;
        		   		item->dirty=TRUE;
        		   		post calculateDrift();
        		   		item->failCount=0;     
        		   		item->driftLimitCount = 0;
        			}
        			else {
#ifdef CC2420SYNC_DEBUG        				
        				call DSN.log("drift out of limit");
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
        			}
        		}        		 
        	}
        	else {
#ifdef CC2420SYNC_DEBUG
        		call DSN.log("bad timestamp (earlier than last)");
#endif        		
        	}
        }
        else
          call DSN.log("no valid offset");
      }
      else {
        call DSN.log("sync table full");
      }
    }
    if ((header->lplPeriod & REQ_SYNC_FLAG) != 0) {
    	signal NeighbourSyncRequest.updateRequest(address, header->lplPeriod & ~REQ_SYNC_FLAG);
    }

    // print accuracy of packet
    if ((call CC2420PacketBody.getHeader(msg))->dest == TOS_NODE_ID) {
#ifdef CC2420SYNC_DEBUG
    	call DSN.logInt(address);  	    	
    	call DSN.logInt((call CC2420PacketBody.getMetadata(msg))->time - call PowerCycle.getLastWakeUp());
    	call DSN.logInt((t_radio_on & 0xffff) - call PowerCycle.getLastWakeUp());    	
    	call DSN.log("rx packet from %i, at %i, on at %i");
#endif    	
    }
    
    (call CC2420PacketBody.getHeader(msg))->length = len - SYNC_HEADER_SIZE;
    return signal Receive.receive(msg, payload, len - SYNC_HEADER_SIZE);
  }

  /***************** Alarm Events ***************/
  async event void Alarm.fired() {
	  atomic {
		  switch (call SyncSendState.getState()) {
		  case S_PREPARE_RADIO:
			  if (call SendState.requestState(S_LPL_SYNCWAIT)==SUCCESS) {
				  post startRadio();
			  }
			  else {
				  state_error=1;
				  post signalSendDoneFail();
			  }
			  t[1]=call Alarm.getAlarm();
			  break;
		  case S_SEND:
			  if (call CC2420Transmit.resend(m_cca)!=SUCCESS) {
				  state_error=2;
				  post signalSendDoneFail();
			  }
			  if (m_timed_send) post reportTimes();
			  t[5]=call Alarm.getAlarm();
			  break;
		}
	  }
  }

  /***************** TimeStamping Events ***************/
  async event void RadioTimeStamping.receivedSFD(uint16_t time) {
  } 
 
  async event void RadioTimeStamping.transmittedSFD(uint16_t time, message_t *p_msg) {
    offset=time - (call PowerCycle.getLastWakeUp());
    call CC2420Transmit.modify( m_len -1 , (uint8_t * )&offset, 2 );
    t[6]=call Alarm.getNow();
  }

  /***************** TimedPacket Events ******************/
  async event bool TimedPacket.requestImmediatePacket(message_t* p_msg) { 
	  atomic {
		  if (call SyncSendState.getState()==S_PACKET_READY) { 
			  call SyncSendState.forceState(S_SEND);
			  t[4]=call Alarm.getNow();
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
    if (!error)
      call RadioPowerState.forceState(S_OFF);
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
	  uint8_t idx;
	  if ((idx=getIndex(neighbour)) != NO_ENTRY) {
		  *interval=n_table[idx].lplPeriod;
		  return SUCCESS;
	  }
	  return FAIL;
  }

  /***************** NeighbourSyncRequest events ***************/
  default event void NeighbourSyncRequest.updateRequest(am_addr_t address, uint16_t lplPeriod) {
	  call LowPowerListening.setRxSleepInterval(&resync_msg, lplPeriod);
	  call AMSend.send(address, &resync_msg, 0);
  }
  
  /***************** AMSend events *************/
  event void AMSend.sendDone(message_t* msg, error_t error) {
#ifdef CC2420SYNC_DEBUG 
	  call DSN.log("sent unicast resync packet");
#endif	  
  }

  /***************** Functions ***********************/

  neighbour_sync_header_t* getSyncHeader(message_t * msg, uint8_t len ) {
    return (neighbour_sync_header_t*) (msg->data - CC2420_SIZE + len);
  }

  uint8_t getIndex(am_addr_t lladdr) {
    uint8_t i;
    for (i=0;i<numEntries;i++)
      if (n_table[i].address == lladdr)
        return i;
    return NO_ENTRY;
  }

  bool tableFull() {
    return numEntries >= NEIGHBOURSYNCTABLESIZE;
  }
  
  void initTableEntry(neighbour_sync_item_t* entry) {
	  entry->measurementCount = 0;
	  entry->usageCount = 0;
	  entry->failCount = 0;
	  entry->drift = NO_VALID_DRIFT;
	  entry->dirty = FALSE;
	  entry->driftLimitCount=0;
  }

  uint8_t addNewEntry (am_addr_t lladdr) {
    if (tableFull()) return NO_ENTRY;
    initTableEntry(&n_table[numEntries]);
    n_table[numEntries].address = lladdr;
    return numEntries++;
  }

  uint8_t replaceLeastUsedEntry (am_addr_t lladdr) {
    uint8_t i;
    uint16_t minUsageCount=0xffff;
    uint8_t minUsageIndex=0;

    lastReplaceIndex++;
    for (i=0;i<numEntries;i++)
      if (n_table[(i+lastReplaceIndex) % NEIGHBOURSYNCTABLESIZE].usageCount < minUsageCount) {
        minUsageCount=n_table[(i+lastReplaceIndex) % NEIGHBOURSYNCTABLESIZE].usageCount;
        minUsageIndex=(i+lastReplaceIndex) % NEIGHBOURSYNCTABLESIZE;
      }
    initTableEntry(&n_table[minUsageIndex]);
    n_table[minUsageIndex].address = lladdr;
    lastReplaceIndex=minUsageIndex;
    return minUsageIndex;
  }

  void printtable() {
/*
    uint8_t i;
    for (i=0;i<numEntries;i++) {
      call DSN.logInt(i);
      call DSN.logInt(n_table[i].address);
      call DSN.logInt(n_table[i].lastSync);
      call DSN.logInt(n_table[i].usageCount);
      call DSN.logInt(n_table[i].failCount);
      call DSN.logInt(n_table[i].lplPeriod);
      call DSN.logInt(n_table[i].drift);
      call DSN.logInt(n_table[i].positiveDrift);
      call DSN.log("{%i: node %i, last:%i, used:%i, failed:%i, lpl:%ims, drift:%i(+%i)}");
    }
*/
  }
  
  void send() {
	  error_t error;
	  atomic t[3]=call Alarm.getNow();
	  if (call RadioPowerState.getState()!=S_ON) {
		  call DSN.logWarning("Radio off when sending started");
	  }
	  if ((error = call SubSend.send(m_msg, m_len + SYNC_HEADER_SIZE))!= SUCCESS) {
		  call SyncSendState.toIdle();
		  (call CC2420PacketBody.getHeader(m_msg))->length = m_len;	// set the right length
	      (call CC2420PacketBody.getMetadata(m_msg))->rxInterval = m_rxInterval;
	      signal Send.sendDone(m_msg, error);
	      call DSN.logInt(call SendState.getState());
	      call DSN.log("send failed (subsend %i)");
	      if (call SendState.getState()==S_LPL_SYNCWAIT)
	    	  call SendState.toIdle(); // S_LPL_SYNCWAIT -> S_LPL_NOT_SENDING;
	  }
	  else
		  call SyncSendState.forceState(S_PACKET_READY);
  }
  

  /***************** Tasks ********************************/

  task void signalSendDoneFail() {
	  call SyncSendState.toIdle();
	  atomic call DSN.logInt(state_error);
	  call DSN.log("send failed (state %i)");
	  (call CC2420PacketBody.getHeader(m_msg))->length = m_len;	// set the right length
	  (call CC2420PacketBody.getMetadata(m_msg))->rxInterval = m_rxInterval;
	  signal Send.sendDone(m_msg, FAIL);
  }

  task void startRadio() {
	atomic t[2]=call Alarm.getNow();
	call SyncSendState.forceState(S_LOAD_DATA);
    if (call RadioPowerState.getState()!=S_ON) {
      call SubControl.start();
    }
    else {
    	send();
    } 
   }
    
  task void reportTimes() { /*
	  atomic {
		  call DSN.logInt(t[1]-t[0]); // alarm offset
		  call DSN.logInt(t[2]-t[0]); // task offset
		  call DSN.logInt(t[3]-t[0]); // send offset
		  call DSN.logInt(t[4]-t[0]); // fifo ready offset
		  call DSN.logInt(t[5]-t[0]); // send allarm offset
		  call DSN.logInt(t[6]-t[0]); // sfd offset
	  }
	  call DSN.log("Times: %i,%i,%i,%i,%i,%i");*/
  }
}
