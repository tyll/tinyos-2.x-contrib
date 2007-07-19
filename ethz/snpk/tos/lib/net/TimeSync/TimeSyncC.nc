/*
 * Copyright (c) 2007, ETH Zuerich
 * All rights reserved.
 * Author: Min Guo 
 *
 * This component provides a modified GlobalTime interface which is previously introduced by Vanderbilt University in TinyOS 1.x
 * The code for computing the clock skew (line 170 till line 205) is copied (with modification) from Vanderbilt University's TimeSyncM.nc component
 * 
*/

// Variable skewFloat needs update when clearing the table
// Function Global2Local needs modification. Although the effect on time difference is no more than 3 ticks (less than 1 normally).

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
        interface CC2420Packet;
    }
}

////////////////////////////////////////////////////////////////////////////////////
/* Implementation */
implementation
{

    enum {
        ITEM_NUM = 8,             // number of entries in the regression table
        NUM_SYNCED = 2,           // number of entries to become synchronized
        INVALID_MSG_LIMIT = 100,  // if the computed global time differs much from the received message, the received message is discarded
        TIMESYNC_RATE = 5,        // how often send the synchronization msg (in seconds)
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
    uint8_t     occNum;
    uint8_t     waiting;
    uint32_t    localAverage;
    int32_t     offsetAverage;
    uint32_t 	arrivalTime;
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
        if (skew>=0) {
          skewInt = skew;
          skewFloat = (uint32_t)((float)(skew - skewInt)*2147483648.0);
        }
        else {
          skewInt = skew-1;
          skewFloat = (uint32_t)((float)(skew - skewInt)*2147483648.0);
        }
    }

    void newItem(TimeSyncMsg *msg)
    {
        int8_t i;
        int8_t addPlace = -1;
        int8_t oldestPlace = -1;
        uint32_t lt = -1; 
        uint32_t timePass;

        int32_t differTime;

        float newSkew = skew;
        uint32_t newLocalAverage;
        int32_t newOffsetAverage;

        int64_t localSum;
        int64_t offsetSum;

        occNum = 0;

        differTime = arrivalTime;
        differTime += offsetAverage + (int32_t)(skew * (int32_t)(differTime - localAverage));
        differTime -= msg->sendingTime;          

        if((is_synced() == SUCCESS) && (differTime > INVALID_MSG_LIMIT || differTime < -INVALID_MSG_LIMIT)) {}
        else {
          for(i = 0; i < ITEM_NUM; ++i) {
            timePass = (arrivalTime - table[i].localTime);
            if (table[i].state == FREE ) {if (addPlace == -1) {addPlace = i; ++occNum;}}
            else if (arrivalTime - table[i].localTime >= 2147483647) {
              table[i].state = FREE;
              if (addPlace == -1) {addPlace = i; ++occNum;}              
            }
            else {
              ++occNum;
              if (addPlace == -1) {if (lt < timePass) {lt = timePass; oldestPlace = i;}}
            }
          }
          if (addPlace == -1) addPlace = oldestPlace; 

          table[addPlace].state = OCCUPIED;
          table[addPlace].localTime = arrivalTime;
          table[addPlace].timeOffset = msg->sendingTime - arrivalTime;

          /* computing the skew */

          for(i = 0; i < ITEM_NUM && table[i].state != OCCUPIED; ++i) ;
          if( i >= ITEM_NUM ) return;
          newLocalAverage = table[i].localTime;
          newOffsetAverage = table[i].timeOffset;

          localSum = offsetSum = 0;
          while( ++i < ITEM_NUM )
              if( table[i].state == OCCUPIED ) {
                  localSum += (int32_t)(table[i].localTime - newLocalAverage) / occNum;
                  offsetSum += (int32_t)(table[i].timeOffset - newOffsetAverage) / occNum;
              }

          newLocalAverage += localSum;
          newOffsetAverage += offsetSum;
          localSum = offsetSum = 0;

          for(i = 0; i < ITEM_NUM; ++i)
              if( table[i].state == OCCUPIED ) {
                  int32_t a = table[i].localTime - newLocalAverage;
                  int32_t b = table[i].timeOffset - newOffsetAverage;
                  localSum += (int64_t)a * a;
                  offsetSum += (int64_t)a * b;
              }

          if( localSum != 0 )
              newSkew = (float)offsetSum / (float)localSum;

          atomic {
              skew = newSkew;
              offsetAverage = newOffsetAverage;
              localAverage = newLocalAverage;
              numEntries = occNum;
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
        TimeSyncMsg* msg = (TimeSyncMsg*)(call Packet.getPayload(processedMsg, NULL));
        if( msg->rootID < osg->rootID ){
            clearTable();
            osg->rootID = msg->rootID;
            osg->seqNum = msg->seqNum;
            osg->fromID = msg->nodeID;
            newItem(msg);
            waiting=0;

            if(is_synced() == SUCCESS) {
              call Leds.led0Toggle();
              signal GlobalTime.synced();
            }

        }
        else if( osg->rootID == msg->rootID && (int8_t)(msg->seqNum - osg->seqNum) > 0 ) {
            osg->seqNum = msg->seqNum;
            osg->fromID = msg->nodeID;
            newItem(msg);
            waiting=0;

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
        uint32_t psend, plocal;
        
        meta = call CC2420Packet.getMetadata(p);
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
              psg->sendingTime = psend;

              post processMsg();

            }
        }
        return processedMsg;
    }

    task void sendMsg()
    {
        uint32_t localTime, globalTime;
        if (!busy) {

            osg->offsetAverage = offsetAverage;
            osg->localAverage = localAverage;
            osg->tentry = numEntries; osg->skewInt = skewInt; osg->skewFloat = skewFloat;

            globalTime = localTime = call GlobalTime.getLocalTime();
            osg->sendingTime = globalTime;

            if (call AMSend.send(1, &outgoingMsg, sizeof(TimeSyncMsg)) == SUCCESS) {
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
          osg->nodeID = TOS_NODE_ID;
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
          osg->nodeID = TOS_NODE_ID;
          osg->fromID = TOS_NODE_ID;
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
