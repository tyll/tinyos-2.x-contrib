/*
 * TTSP - Tagus Time Synchronization Protocol
 *
 * Copyright (c) 2010 Hugo Freire and IT - Instituto de Telecomunicacoes
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 *
 * Address:
 * Instituto Superior Tecnico - Taguspark Campus
 * Av. Prof. Dr. Cavaco Silva, 2744-016 Porto Salvo
 *
 * E-Mail:
 * hugo.freire@ist.utl.pt
 */

/**
 * TTSP pair-wise and network-wide synchronization implementation.
 *
 * This component implements the pair-wise and network-wide synchronization
 * algorithms used by TTSP synchronization protocol.
 *
 * @author Hugo Freire <hugo.freire@ist.utl.pt>
**/

#include "TimeSyncMsg.h"
#include "printf.h"

generic module TimeSyncP(typedef precision_tag) {
    provides {
    	interface Init;
   		interface StdControl;
      interface GlobalTime<TMilli>;
      interface TimeSyncInfo;
      interface TimeSyncControl;
    }
    uses {
    	interface Boot;
     	interface SplitControl as RadioControl;
      interface TimeSyncAMSend<TMilli,uint32_t> as Send;
      interface Receive;
      interface Random;
      interface TimeSyncPacket<TMilli,uint32_t>;
      interface LocalTime<TMilli> as LocalTime;
      interface Packet;
    }
} implementation {

    enum {
        MAX_ENTRIES           = 4,              // number of entries in the table
        IGNORE_ROOT_MSG       = 4,              // after becoming the root ignore other roots messages (in send period)
        ENTRY_VALID_LIMIT     = 4,              // number of entries to become synchronized
        ENTRY_SEND_LIMIT      = 3,              // number of entries to send sync messages
        ENTRY_THROWOUT_LIMIT  = 500,            // if time sync error is bigger than this clear the table
    };

    typedef struct TableItem
    {
    		uint8_t			position;
        uint8_t     state;
        uint32_t    localTime;
        int32_t     timeOffset; // globalTime - localTime
        int32_t			timeError;
    } TableItem;

    enum {
        ENTRY_EMPTY = 0,
        ENTRY_FULL = 1,
    };

    TableItem   table[MAX_ENTRIES];
    uint8_t tableEntries;
    
    TableItem 	backup;
    
    TableItem 	recentTable[MAX_ENTRIES];
    uint8_t recentEntry = 0;
    
    bool entryError = FALSE;
    
    enum {
        STATE_IDLE = 0x00,
        STATE_PROCESSING = 0x01,
        STATE_SENDING = 0x02,
        STATE_INIT = 0x04,
    };

    uint8_t state, mode;
    float       skew;
    uint32_t    localAverage;
    int32_t     offsetAverage;
    uint8_t     numEntries; // the number of full entries in the table
    message_t processedMsgBuffer;
    message_t* processedMsg;
    message_t outgoingMsgBuffer;
    TtspMsg* outgoingMsg;

    void calculateConversion()
    {
        float newSkew = skew;
        uint32_t newLocalAverage;
        int32_t newOffsetAverage;
        int32_t localAverageRest;
        int32_t offsetAverageRest;

        int64_t localSum;
        int64_t offsetSum;

        int8_t i;

        for(i = 0; i < MAX_ENTRIES && table[i].state != ENTRY_FULL; ++i)
            ;

        if( i >= MAX_ENTRIES )  // table is empty
            return;

        newLocalAverage = table[i].localTime;
        newOffsetAverage = table[i].timeOffset;

        localSum = 0;
        localAverageRest = 0;
        offsetSum = 0;
        offsetAverageRest = 0;

        while( ++i < MAX_ENTRIES )
            if( table[i].state == ENTRY_FULL ) {
                /*
                   This only works because C ISO 1999 defines the signe for modulo the same as for the Dividend!
                */ 
                localSum += (int32_t)(table[i].localTime - newLocalAverage) / tableEntries;
                localAverageRest += (table[i].localTime - newLocalAverage) % tableEntries;
                offsetSum += (int32_t)(table[i].timeOffset - newOffsetAverage) / tableEntries;
                offsetAverageRest += (table[i].timeOffset - newOffsetAverage) % tableEntries;
            }

        newLocalAverage += localSum + localAverageRest / tableEntries;
        newOffsetAverage += offsetSum + offsetAverageRest / tableEntries;

        localSum = offsetSum = 0;
        for(i = 0; i < MAX_ENTRIES; ++i)
            if( table[i].state == ENTRY_FULL ) {
                int32_t a = table[i].localTime - newLocalAverage;
                int32_t b = table[i].timeOffset - newOffsetAverage;

                localSum += (int64_t)a * a;
                offsetSum += (int64_t)a * b;
            }

        if( localSum != 0 )
            newSkew = (float)offsetSum / (float)localSum;

        atomic
        {
            skew = newSkew;
            offsetAverage = newOffsetAverage;
            localAverage = newLocalAverage;
            numEntries = tableEntries;
        }
        
        
           printf("%i;%i;%lu;%lu;%ld\n", 0, table[0].state, table[0].localTime, table[0].timeOffset, table[0].timeError);
           printf("%i;%i;%lu;%lu;%ld\n", 1, table[1].state, table[1].localTime, table[1].timeOffset, table[1].timeError);
           printfflush();
           printf("%i;%i;%lu;%lu;%ld\n", 2, table[2].state, table[2].localTime, table[2].timeOffset, table[2].timeError);
           printf("%i;%i;%lu;%lu;%ld\n", 3, table[3].state, table[3].localTime, table[3].timeOffset, table[3].timeError);
           printfflush(); 
    }

    void clearTable()
    {
        int8_t i;
        for(i = 0; i < MAX_ENTRIES; ++i)
            table[i].state = ENTRY_EMPTY;

        atomic numEntries = 0;
    }

    uint8_t numErrors=0;
    
    int8_t removeOldestEntry(uint32_t localTime) {
        int8_t i, freeItem = -1, oldestItem = 0;
        uint32_t age, oldestTime = 0;	
    
        tableEntries = 0; // don't reset table size unless you're recounting
        numErrors = 0;

        for(i = 0; i < MAX_ENTRIES; ++i) {
            age = localTime - table[i].localTime;

            //logical time error compensation
            if( age >= 0x7FFFFFFFL )
                table[i].state = ENTRY_EMPTY;

            if( table[i].state == ENTRY_EMPTY )
                freeItem = i;
            else
                ++tableEntries;

            if( age >= oldestTime ) {
                oldestTime = age;
                oldestItem = i;
            }
        }

        if( freeItem < 0 )
            freeItem = oldestItem;
        else
            ++tableEntries;
            
       return freeItem;
    }
    
    void addNewEntry(TtspMsg *msg)
    {
    		int8_t freeItem;
        int32_t timeError;

        // clear table if the received entry's been inconsistent for some time
				if (call GlobalTime.get(msg->localTime) > msg->globalTime) {
					timeError = call GlobalTime.get(msg->localTime) - msg->globalTime;
				} else {
					timeError = msg->globalTime - call GlobalTime.get(msg->localTime);
				}    
        
        if( (call TimeSyncInfo.isSynced()) &&
            (timeError > ENTRY_THROWOUT_LIMIT || timeError < -ENTRY_THROWOUT_LIMIT))
        {
            if (++numErrors>3)
                clearTable();
            return; // don't incorporate a bad reading
        }
				
				backup.position = freeItem = removeOldestEntry(msg->localTime);
				backup.state = table[freeItem].state;
				backup.localTime = table[freeItem].localTime;
				backup.timeOffset = table[freeItem].timeOffset;
				backup.timeError = table[freeItem].timeError;	
				
				recentTable[recentEntry].state = ENTRY_FULL;
				recentTable[recentEntry].position = freeItem;
				recentTable[recentEntry].localTime = msg->localTime;
				recentTable[recentEntry].timeOffset = msg->globalTime - msg->localTime;
				recentTable[recentEntry].timeError = timeError;
				
				if(recentEntry == 0) {
					recentEntry = 1;
				} else {
					recentEntry = 0;
				}				
				
        table[freeItem].state = ENTRY_FULL;

        table[freeItem].localTime = msg->localTime;
        table[freeItem].timeOffset = msg->globalTime - msg->localTime;
        table[freeItem].timeError = timeError;
    }

    void task processMsg()
    {
        TtspMsg* msg = (TtspMsg*)(call Send.getPayload(processedMsg, sizeof(TtspMsg)));
				int8_t prevNumEntries;
				//uint32_t localTime;
				uint32_t tmp, tmp2;
				
				if( msg->rootID != TOS_NODE_ID) {
				
	        if( msg->rootID < outgoingMsg->rootID && msg->rootID != TOS_NODE_ID) { //received a msg from a root with id below mine
	        	
	            outgoingMsg->rootID = msg->rootID;
	            outgoingMsg->seqNum = msg->seqNum;
	        } 
	        else if(msg->rootID > outgoingMsg->rootID && outgoingMsg->rootID == TOS_NODE_ID) {
	        		signal TimeSyncControl.foundFalseRoot();
	        		goto exit;
	        }
	        else if( outgoingMsg->rootID == msg->rootID && (int8_t)(msg->seqNum - outgoingMsg->seqNum) > 0 ) { // received a msg from mine root id
	            outgoingMsg->seqNum = msg->seqNum;
	        }
	        else
	            goto exit;

					prevNumEntries = numEntries;
	
					//localTime = call LocalTime.get();
					//tmp = call GlobalTime.get(localTime);
					if (call GlobalTime.get(msg->localTime) > msg->globalTime) {
						tmp = call GlobalTime.get(msg->localTime) - msg->globalTime;
					} else {
						tmp = msg->globalTime - call GlobalTime.get(msg->localTime);
					}
	
	        addNewEntry(msg);
	        calculateConversion();
	        //signal TimeSyncNotify.msg_received();


					if (call GlobalTime.get(msg->localTime) > msg->globalTime) {
						tmp2 = call GlobalTime.get(msg->localTime) - msg->globalTime;
					} else {
						tmp2 = msg->globalTime - call GlobalTime.get(msg->localTime);
					}

	        if (msg->syncPeriod > outgoingMsg->syncPeriod && numEntries>=ENTRY_VALID_LIMIT && prevNumEntries>=ENTRY_VALID_LIMIT && tmp < tmp2) {
	        	//printf("error: %ld>1||%ld<-1\n", (((int32_t)tmp-(int32_t)call GlobalTime.get(localTime))), (((int32_t)tmp-(int32_t)call GlobalTime.get(localTime))));
		        //printfflush();
	        	
	        	
	        	if (entryError) {
	        		printf("2 errors.\n");
	        		printfflush();
	        		
	        		table[recentTable[0].position].localTime = recentTable[0].localTime;
	        		table[recentTable[0].position].timeOffset = recentTable[0].timeOffset;
	        		table[recentTable[0].position].timeError = recentTable[0].timeError;
	        		
	        		table[recentTable[1].position].localTime = recentTable[1].localTime;
	        		table[recentTable[1].position].timeOffset = recentTable[1].timeOffset;
	        		table[recentTable[1].position].timeError = recentTable[1].timeError;
	        		
	        		calculateConversion();
	        		
	        		entryError = FALSE;
	        		
	        	} else {
		        	table[backup.position].state = backup.state;
							table[backup.position].localTime = backup.localTime;
							table[backup.position].timeOffset = backup.timeOffset;
							table[backup.position].timeError = backup.timeError;
							calculateConversion();
							entryError = TRUE;
	        	}
	        	
	        } else {
	        	entryError = FALSE;
	        }
	        
	        if( outgoingMsg->rootID < TOS_NODE_ID ) {
	            //heartBeats = 0;
	            signal TimeSyncControl.foundRoot(msg->syncPeriod, msg->nodeID);
	        }	        
	        
	        if(numEntries>=ENTRY_VALID_LIMIT && prevNumEntries<ENTRY_VALID_LIMIT) {
	      		signal TimeSyncControl.synced();
	      	}
	      	
					if (call GlobalTime.get(msg->localTime) > msg->globalTime) {
						signal TimeSyncControl.currentPrecisionError(msg->seqNum, msg->nodeID, call GlobalTime.get(msg->localTime) - msg->globalTime);
					} else {
						signal TimeSyncControl.currentPrecisionError(msg->seqNum, msg->nodeID, msg->globalTime - call GlobalTime.get(msg->localTime));
					}	      	
	      	
	    	} else {
					if (call GlobalTime.get(msg->localTime) > msg->globalTime) {
						signal TimeSyncControl.currentPrecisionError(msg->seqNum, msg->nodeID, call GlobalTime.get(msg->localTime) - msg->globalTime);
					} else {
						signal TimeSyncControl.currentPrecisionError(msg->seqNum, msg->nodeID, msg->globalTime - call GlobalTime.get(msg->localTime));
					}	    		
	    	}

    exit:
        state &= ~STATE_PROCESSING;
    }

    event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len) {	
			
			if(TOS_NODE_ID == 1 && ((TtspMsg *)(payload))->nodeID == 2) {
				return msg;
			}
			
			if(TOS_NODE_ID == 2 && ((TtspMsg *)(payload))->nodeID == ((TtspMsg *)(payload))->rootID) {
				return msg;
			}
			
     	if( (state & STATE_PROCESSING) == 0 && call TimeSyncPacket.isValid(msg)) {
      	message_t* old = processedMsg;

        processedMsg = msg;
        ((TtspMsg*)(payload))->localTime = call TimeSyncPacket.eventTime(msg);

        state |= STATE_PROCESSING;
        post processMsg();

        return old;
      }

      return msg;
    }

    task void sendMsg()
    {
        uint32_t localTime, globalTime;
       
       	state |= STATE_SENDING;
       
				localTime = call LocalTime.get();
				globalTime = call GlobalTime.get(localTime);        

        // we need to periodically update the reference point for the root
        // to avoid wrapping the 32-bit (localTime - localAverage) value
        if( outgoingMsg->rootID == TOS_NODE_ID ) {
            if( (int32_t)(localTime - localAverage) >= 0x20000000 )
            {
                atomic
                {
                    localAverage = localTime;
                    offsetAverage = globalTime - localTime;
                }
            }
        }
//        else if( heartBeats >= ROOT_TIMEOUT ) {
//            heartBeats = 0; //to allow ROOT_SWITCH_IGNORE to work
//            outgoingMsg->rootID = TOS_NODE_ID;
//            ++(outgoingMsg->seqNum); // maybe set it to zero?
//        }

        outgoingMsg->globalTime = globalTime;

        // we don't send time sync msg, if we don't have enough data
//        if( numEntries < ENTRY_SEND_LIMIT && outgoingMsg->rootID != TOS_NODE_ID ){
//            //++heartBeats;
//            state &= ~STATE_SENDING;
//        }
//        else if( call Send.send(AM_BROADCAST_ADDR, &outgoingMsgBuffer, TIMESYNCMSG_LEN, localTime ) != SUCCESS ){
//            state &= ~STATE_SENDING;
//            //signal TimeSyncNotify.msg_sent();
//        }
        
        if(call Send.send(AM_BROADCAST_ADDR, &outgoingMsgBuffer, sizeof(TtspMsg), localTime) != SUCCESS){
            state &= ~STATE_SENDING;
        }
    }

    event void Send.sendDone(message_t* ptr, error_t error)
    {
        if (ptr != &outgoingMsgBuffer)
          return;

        if(error == SUCCESS)
        {

            if( outgoingMsg->rootID == TOS_NODE_ID )
                ++(outgoingMsg->seqNum);
        }

        state &= ~STATE_SENDING;

        signal TimeSyncControl.sendDone();
    }

		command uint32_t GlobalTime.get(uint32_t localTime) {
			if(call TimeSyncInfo.isSynced()) {
				return localTime + offsetAverage + (int32_t)(skew * (localTime - localAverage));
			} else {
				return localTime;
			}
		}
		
		command uint32_t GlobalTime.getOffset(uint32_t localTime) {
			if(call TimeSyncInfo.isSynced()) {
				return offsetAverage + (int32_t)(skew * (localTime - localAverage));
			} else {
				return 0;
			}
		}    

	  command bool TimeSyncInfo.isSynced() {
	  	if (numEntries>=ENTRY_VALID_LIMIT || outgoingMsg->rootID==TOS_NODE_ID) {
				return TRUE;
			} else {
				return FALSE;
			}
	  }
		
	  command bool TimeSyncInfo.isRoot() {
	  	return outgoingMsg->rootID==TOS_NODE_ID;
	  }
	
	  command uint16_t TimeSyncInfo.getRootId() {
	  	if(call TimeSyncInfo.isSynced()) {
	  		return outgoingMsg->rootID;
	  	} else {
	  		return -1;
	  	}
	  }

		void clearTimeSync() {

      atomic{
          skew = 0.0;
          localAverage = 0;
          offsetAverage = 0;
      };

			clearTable();
			
			outgoingMsg->rootID = 0xFFFF;
		}

	  command error_t TimeSyncControl.setRoot() {
	  	clearTimeSync();
	  	
	  	outgoingMsg->rootID = TOS_NODE_ID;
	  	outgoingMsg->seqNum = 0;
	  	return SUCCESS;
	  }
	
		command error_t TimeSyncControl.setSyncPeriod(uint32_t period) {
			outgoingMsg->syncPeriod = period;
			return SUCCESS;
		}
		
		command error_t TimeSyncControl.clearTable() {
			clearTable();
			
			return SUCCESS;
		}
	
		command void TimeSyncControl.removeOldestSyncPoint() {
			if (call TimeSyncInfo.isSynced() && numEntries>=ENTRY_VALID_LIMIT) {
				//removeOldestSyncPoint(call LocalTime.get());
				calculateConversion();
			}
		}

    command error_t Init.init() {
    	atomic{
      	skew = 0.0;
        localAverage = 0;
        offsetAverage = 0;
      };

      clearTable();

      atomic outgoingMsg = (TtspMsg*)call Send.getPayload(&outgoingMsgBuffer, sizeof(TtspMsg));
      outgoingMsg->rootID = 0xFFFF;
      outgoingMsg->nodeID = TOS_NODE_ID;
      
      processedMsg = &processedMsgBuffer;
      state = STATE_INIT;

      return SUCCESS;
    }

    command error_t StdControl.start() {
    	return SUCCESS;
    }

		async command error_t TimeSyncControl.sendMsg() {
			return post sendMsg();
		}

    command error_t StdControl.stop() {return SUCCESS;}
		event void Boot.booted() {}
	  event void RadioControl.startDone(error_t error){}
    event void RadioControl.stopDone(error_t error){}
}
