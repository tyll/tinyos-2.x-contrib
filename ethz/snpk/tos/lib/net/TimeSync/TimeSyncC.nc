/*
 * Copyright (c) 2007, ETH Zuerich
 * All rights reserved.
 * Author: Min Guo 
 *
 * This component provides a modified GlobalTime interface which is previously introduced by Vanderbilt University in TinyOS 1.x
 * The code for computing the clock skew (line 202 till line 252) is copied (with modification) from Vanderbilt University's TimeSyncM.nc component
 * 
*/

#include "Timer.h"
#include "TimeSyncMsg.h"

module TimeSyncC
{
    provides interface GlobalTime;
    uses
    {
        interface Timer<TMilli> as Timer0;
        interface Leds;
        interface Boot;

        interface AMPacket;
        interface Packet;
        interface AMSend;
        interface SplitControl as AMControl;
        interface Receive;

        interface LocalTime<T32khz>;        
        interface RadioTimeStamping; 
        interface CC2420Transmit;
        interface CC2420PacketBody;
    
        interface DsnSend;
    }
}

////////////////////////////////////////////////////////////////////////////////////
/* Implementation */
implementation
{
    // how often send the synchronization msg (in seconds)
    #ifndef TIMESYNC_RATE
    #define TIMESYNC_RATE   6 
    #endif

    // how many nodes     
    #ifndef NUMBER_OF_NODES
    #define NUMBER_OF_NODES   4
    #endif

    enum {
        ITEM_NUM = 8,             // number of entries in the regression table
        NUM_SYNCED = 2,           // number of entries to become synchronized
        INVALID_MSG_LIMIT = 100,  // if the computed global time differs much from the received message, the received message is discarded               
        WAITING_LIMIT = 4,           
        FREE = 0, 
        OCCUPIED = 1,
    };

    typedef struct TableItem
    {
        uint8_t     state;
        uint32_t    localTime;
        int32_t     timeOffset; 
    } TableItem;

    TableItem   table[ITEM_NUM];
    uint8_t     waiting;
    uint32_t    localAverage;
    int32_t     offsetAverage;
    uint32_t 	arrivalTime;
    uint32_t    psend;
    uint8_t     numEntries;       // the number of occupied entries in the table

    float       skew;
    int8_t      skewInt; 
    uint32_t    skewFloat;

    bool busy = FALSE;
    message_t* processedMsg;  
    TimeSyncMsg* psg;
    message_t outgoingMsg;
    TimeSyncMsg* osg;
    cc2420_metadata_t * meta;

////////////////////////////////////////////////////////////////////////////

    error_t is_synced()
    { 
        if (numEntries>=NUM_SYNCED || osg->rootID==TOS_NODE_ID) {return SUCCESS;}
        else {return FAIL;}
    }

////////////////////////////////////////////////////////////////////////////

    async command uint32_t GlobalTime.getLocalTime()
    {
        return call LocalTime.get();
    }

////////////////////////////////////////////////////////////////////////////

    async command error_t GlobalTime.getGlobalTime(uint32_t *time)
    { 
        *time = call GlobalTime.getLocalTime();
        *time += offsetAverage + (int32_t)(skew * (int32_t)(*time - localAverage));
        return is_synced();
    }

////////////////////////////////////////////////////////////////////////////

    async command error_t GlobalTime.global2Local(uint32_t *time)
    {
        uint32_t approxLocalTime = *time - offsetAverage;
        *time = approxLocalTime - (int32_t)(skew * (int32_t)(approxLocalTime - localAverage));
        return is_synced();
    }
    
////////////////////////////////////////////////////////////////////////////

    void skewInMsg() 
    {
        if (skew>=0.0) {
            skewInt = (int8_t)skew;
            skewFloat = (uint32_t)((float)(skew - skewInt)*2147483648.0);
        }
        else {
            skewInt = (int8_t)(skew-1.0);
            skewFloat = (uint32_t)((float)(skew - skewInt)*2147483648.0);
        }
    }

    void newItem(TimeSyncMsg *msg)
    {
        int8_t i;
        uint8_t occNum;
        int8_t addPlace = -1;
        int8_t oldestPlace = 0;
        uint32_t lt = 0; 
        uint32_t timePass;
        
        uint32_t preceive;
        int32_t diffTime;

        float newSkew = skew;
        uint32_t newLocalAverage;
        int32_t newOffsetAverage;

        int64_t localSum;
        int64_t offsetSum;
        float foffsetSum;

        preceive = arrivalTime;
        preceive += offsetAverage + (int32_t)(skew * (int32_t)(arrivalTime - localAverage));
        call DsnSend.logInt(preceive);
        call DsnSend.log("global time at receiving %i \r");
        diffTime = preceive - psend;

        call DsnSend.logInt(diffTime);
        call DsnSend.log("time difference %i \r");

        if((is_synced() == SUCCESS) && (diffTime > INVALID_MSG_LIMIT || diffTime < -INVALID_MSG_LIMIT)) {
            call DsnSend.logInt(arrivalTime); 
            call DsnSend.logInt(psend);
            call DsnSend.logInt(numEntries);
            call DsnSend.log("discarding new msg arrivalLocalTime %i, sendingGlobalTime %i, current number of Entries %i \r");

          return;
        }                
        else 
        {      
            occNum = 0; waiting=0;
            for(i = 0; i < ITEM_NUM; ++i) {
                timePass = (arrivalTime - table[i].localTime);
                if (table[i].state == FREE ) {if (addPlace == -1) {addPlace = i; ++occNum;}}
                else if (timePass >= 0x7FFFFFFFL) {
                    table[i].state = FREE;
                    if (addPlace == -1) {addPlace = i; ++occNum;}              
                }
                else {
                    ++occNum;
                    if (addPlace == -1) {if (timePass >= lt) {lt = timePass; oldestPlace = i;}}
                }
            }
            if (addPlace == -1) addPlace = oldestPlace;
            table[addPlace].state = OCCUPIED;
            table[addPlace].localTime = arrivalTime;
            table[addPlace].timeOffset = psend - arrivalTime;

            atomic numEntries = occNum;

            call DsnSend.logInt(arrivalTime); 
            call DsnSend.logInt(psend);
            call DsnSend.logInt(numEntries); 
            call DsnSend.log("addding new msg arrivalLocalTime %i, sendingGlobalTime %i, current number of Entries %i \r");

            /* computing the skew */
            //call DsnSend.logInt(occNum);
            //call DsnSend.log("occNum %i \r");
       
            for(i = 0; i < ITEM_NUM && table[i].state != OCCUPIED; ++i)
                ;

            //call DsnSend.logInt(i);
            //call DsnSend.log("i %i \r");

            if( i >= ITEM_NUM )        // table is empty, in case occNum has error
                return;

            newLocalAverage = table[i].localTime;
            newOffsetAverage = table[i].timeOffset;

            localSum = 0;
            foffsetSum = 0.0;

            while( ++i < ITEM_NUM ){
                if( table[i].state == OCCUPIED ) {
                    localSum += (int32_t)(table[i].localTime - newLocalAverage) / occNum;
                    foffsetSum += (float)(table[i].timeOffset - newOffsetAverage) / (float)occNum;
                }
            }

            newLocalAverage += localSum;
            newOffsetAverage += (int32_t)(foffsetSum >= 0.0 ? (foffsetSum + 0.5):(foffsetSum - 0.5));

            localSum = 0; offsetSum = 0;
            for(i = 0; i < ITEM_NUM; ++i){
                if( table[i].state == OCCUPIED ) {
                    int32_t a = table[i].localTime - newLocalAverage;
                    int32_t b = table[i].timeOffset - newOffsetAverage;

                    localSum += (int64_t)a * a;
                    offsetSum += (int64_t)a * b;
                }
            }

            //call DsnSend.logInt(localSum);call DsnSend.logInt(offsetSum);
            //call DsnSend.log("localSum %i, offsetSum %i \r");

            if( localSum != 0 )
                newSkew = (float)offsetSum / (float)localSum;

            atomic {
                skew = newSkew;
                offsetAverage = newOffsetAverage;
                localAverage = newLocalAverage;
                skewInMsg();                      
            }
        } 
    }

////////////////////////////////////////////////////////////////////////////

    void clearTable()
    {
        int8_t i;
        for(i = 0; i < ITEM_NUM; ++i)
            table[i].state = FREE;

        atomic numEntries = 0;
    }

    void task processMsg()
    {
        int8_t i;
        TimeSyncMsg* msg = (TimeSyncMsg*)(call Packet.getPayload(processedMsg, NULL));

        for(i = 0; i<8; i++) {
            call DsnSend.logInt(i);
            call DsnSend.logInt(table[i].state);
            call DsnSend.logInt(table[i].localTime);
            call DsnSend.logInt(table[i].timeOffset);
            call DsnSend.log("$element number %i: state %i, localTime %i timeOffset %i \r");
        }

        if( msg->rootID < osg->rootID ){
            clearTable();
            osg->rootID = msg->rootID;
            osg->seqNum = msg->seqNum;
            newItem(msg);

            if(is_synced() == SUCCESS) {
                call Leds.led0Toggle();
                signal GlobalTime.synced();
            }

        }
        else if( osg->rootID == msg->rootID && (int8_t)(msg->seqNum - osg->seqNum) > 0 ) {
            osg->seqNum = msg->seqNum;
            newItem(msg);

            if(is_synced() == SUCCESS) {
                call Leds.led0Toggle();
                signal GlobalTime.synced();
            }

        }
    }

    event message_t* Receive.receive(message_t* p, void* payload, uint8_t len){
        uint16_t temp0;
        uint32_t temp;
        float skewi, skewf;
        uint32_t plocal;
        
        atomic {
	    meta = call CC2420PacketBody.getMetadata(p);
            temp = call LocalTime.get();
            temp0 = (temp - (meta->time));
            if (len == sizeof(TimeSyncMsg)){
                processedMsg = p;
                psg = (TimeSyncMsg*)payload;
       	        if (( psg->rootID < osg->rootID ) || ( osg->rootID == psg->rootID && (int8_t)(psg->seqNum - osg->seqNum) > 0 )){
                    skewi = (psg->skewInt); skewf= (psg->skewFloat);
                    psend = psg->sendingTime; plocal = psg->localAverage;
                    arrivalTime =  temp -temp0;
                    psend += (psg -> dummyOffset) - ((uint16_t) psend);
                    psend += (psg->offsetAverage) + (int32_t)((skewi+skewf/2147483648.0) * (int32_t)(psend-plocal));
                    call Leds.led1Toggle();
                    call DsnSend.logInt(TOS_NODE_ID);
                    call DsnSend.log("@node %i receives a msg@ \r");
                    call DsnSend.logInt(arrivalTime); call DsnSend.logInt(temp); call DsnSend.logInt(meta->time); 
                    call DsnSend.logInt(psend); call DsnSend.logInt(psg->sendingTime); call DsnSend.logInt(psg->dummyOffset);
                    call DsnSend.log("arrivalLocalTime %i, orriginalLocalTime %i, meta %i, sendingGlobalTime %i, sendingLocalTime %i, dummyOffset %i \r"); 
                     
                    //call DsnSend.logInt(psg->offsetAverage);
                    //call DsnSend.logInt(psg->localAverage); 
                    //call DsnSend.logInt(psg->skewInt); 
                    //call DsnSend.logInt(psg->skewFloat); 
                    
                    //call DsnSend.log("offsetAverage %i, localAverage %i, skewInt %i, skewFloat %i \r");
                    call DsnSend.log("regression table: \r");
                    call DsnSend.logInt(localAverage);
                    call DsnSend.logInt(offsetAverage);
                    call DsnSend.logInt(skewInt);
                    call DsnSend.logInt(skewFloat);
                    call DsnSend.log("localAverage %i, offsetAverage %i, skewInt %i, skewFloat %i \r");
                    post processMsg();
                }
            }
        }
      
        return processedMsg;
    }

    task void sendMsg()
    {
        uint32_t sendingLocalTime;
        if (!busy) {
            osg->offsetAverage = offsetAverage;
            osg->localAverage = localAverage;
            osg->skewInt = skewInt; osg->skewFloat = skewFloat;
            osg->dummyOffset = 0;
            sendingLocalTime = call GlobalTime.getLocalTime();
            osg->sendingTime = sendingLocalTime;
            if (call AMSend.send((TOS_NODE_ID + 1)%NUMBER_OF_NODES, &outgoingMsg, sizeof(TimeSyncMsg)) == SUCCESS) {
                busy = TRUE; 
            }
        }
    }
    
    event void AMSend.sendDone(message_t* msg, error_t error){
        if (&outgoingMsg == msg){busy = FALSE;}
    }

    event void Timer0.fired() {   
        if (osg->rootID == TOS_NODE_ID) {++(osg->seqNum); post sendMsg();}
        else if (waiting >= WAITING_LIMIT) {
            atomic{
                skew = 0.0; skewInMsg();
                localAverage = 0;
                offsetAverage = 0;
            };
            clearTable();
            osg->rootID = TOS_NODE_ID;
            osg->seqNum = 0;
            waiting = 0;
            post sendMsg();
        }
        else {
            waiting++; post sendMsg();
        }
    }

    event void Boot.booted()
    {
        call AMControl.start();
    }

    event void AMControl.startDone(error_t err){
        atomic{
            osg = (TimeSyncMsg*)(call Packet.getPayload(&outgoingMsg, NULL));
        }
        if (err == SUCCESS){
            atomic{
                skew = 0.0; skewInMsg();
                localAverage = 0;
                offsetAverage = 0;
            };

            clearTable();
            osg->rootID = TOS_NODE_ID;
            osg->seqNum = 0;
            waiting = 0;

            call Timer0.startPeriodic((uint32_t)1024 * TIMESYNC_RATE);
        }
        else{
            call AMControl.start();
        }
    }
 
    event void AMControl.stopDone(error_t err) {
    }
    
    async event void RadioTimeStamping.receivedSFD(uint16_t time) {
    }
 
    async event void RadioTimeStamping.transmittedSFD(uint16_t time, message_t *p_msg) {
        nx_uint16_t time2;
        time2 = time;
        if (p_msg == &outgoingMsg) {
            call CC2420Transmit.modify(MAC_HEADER_SIZE + MAC_FOOTER_SIZE + sizeof(TimeSyncMsg) -3 , (uint8_t *)&time2, 2 );
        }
    }

    async event void CC2420Transmit.sendDone(message_t* p_msg, error_t error) {
    }

}
