/*
 * Copyright (c) 2009, Vanderbilt University
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 * 
 * IN NO EVENT SHALL THE VANDERBILT UNIVERSITY BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE VANDERBILT
 * UNIVERSITY HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 * THE VANDERBILT UNIVERSITY SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE VANDERBILT UNIVERSITY HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.
 *
 */

/**
 *
 * FloodRoutingSync is an implementation of the Routing Integrated Time Synchronization (RITS) protocol.
 * RITS extends FloodRouting engine by aggregating time information into the data packets (e.g. local time
 * of an event) and converting the timing information from the local time of the sender to the receiver's
 * local time as the packets are routed in the network. If converge cast is used towards base station, the
 * base station can convert event times of all received packets into its local time.
 *
 * For more information on FloodRouting, please see FloodRoutingM.nc.
 *
 *   @author Miklos Maroti
 *   @author Brano Kusy, kusy@isis.vanderbilt.edu
 *   @author Janos Sallai
 */

#include "Dfrf.h"
#include <string.h>

#ifdef DFRF_DEBUG
  #if !defined(TOSSIM)
    #include "printf.h"
    #define DFRF_DBG(args...) printf(args); printfflush();
    #define DFRF_DBG_CLEAR(args...) printf(args); printfflush();
    #define ASSERT(arg) if(!(arg)) { printf("ASSERTION FAILED at %s:%d in function %s\n",__FILE__,__LINE__,__FUNCTION__); printfflush();}
  #else
    #define DFRF_DBG(args...) dbg("Dfrf", "%s:%d ",__FUNCTION__,__LINE__ ); dbg_clear("Dfrf", args);
    #define DFRF_DBG_CLEAR(args...) dbg_clear("Dfrf", args);
    #define ASSERT(arg) if(!(arg)) { dbg_clear("Dfrf", "ASSERTION FAILED at %s:%d in function %s\n",__FILE__,__LINE__,__FUNCTION__); }
  #endif
#else
  #define DFRF_DBG(args...)
  #define DFRF_DBG_CLEAR(args...)
  #define ASSERT(arg)
#endif

module DfrfEngineP
{
    provides
    {
        interface DfrfControl[uint8_t id];
        interface DfrfSendAny as DfrfSend[uint8_t appId];
        interface DfrfReceiveAny as DfrfReceive[uint8_t appId];
    }
    uses
    {
        interface DfrfPolicy[uint8_t id];

        interface TimeSyncAMSend<TDfrf, uint32_t>;
        interface Receive;
        interface PacketTimeStamp<TDfrf, uint32_t>; // for the GLOBAL_TIMING-BRANO

        interface TimeSyncPacket<TDfrf, uint32_t>;
        interface Timer<TMilli>;
        interface LocalTime<TDfrf>;
        interface Leds;
        interface Packet;
    }
}

implementation
{

    /**
    * Descriptors are stored as a linked list.
    */
    dfrf_desc_t *firstDesc = NULL;

    /**
    * Find descriptor for a specific parametrized interface.
    */
    static inline dfrf_desc_t* getDescriptor(uint8_t appId)
    {
        dfrf_desc_t* desc = firstDesc;
        while( desc != 0 )
        {
            if( desc->appId == appId )
                return desc;

            desc = desc->nextDesc;
        }
        return NULL;
    }

    /**
     * Get the length of a block
     */

    static inline uint8_t blockLength(dfrf_desc_t* desc) {
      ASSERT(desc != NULL);
      return sizeof(dfrf_block_t) + desc->dataLength;
    }

    /**
    * Return the next block in the descriptor.
    */
    static inline dfrf_block_t* nextBlock(dfrf_desc_t* desc, dfrf_block_t* blk)
    {
        return (dfrf_block_t*)( (uint8_t*)blk + blockLength(desc) );
    }

    /**
    * Returns match or block with lowest priority (set to 0xFF).
    */
    dfrf_block_t* getBlock(dfrf_desc_t* desc, uint8_t *data)
    {
        dfrf_block_t* blk = desc->blocks;
        dfrf_block_t* selected = blk;

        do
        {
            if( blk->priority != 0xFF
                && memcmp(blk->data, data, desc->uniqueLength) == 0 )
                return blk;

            if( blk->priority > selected->priority )
                selected = blk;

            blk = nextBlock(desc, blk);
        } while( blk < desc->blocksEnd );

        selected->priority = 0xFF;
        return selected;
    }

    /**
    * States of the desc->dirty flag in the struct descriptor.
    * dirty flag contains information for all blocks in the buffer;
    * allows for optimization in routing engine - can skip the whole
    *   descriptor, no need to visit all blocks in the descriptor
    */
    enum
    {
        DIRTY_CLEAN = 0x00, // no action is needed for this descriptor
        DIRTY_AGING = 0x01, // only aging is required, no sending
        DIRTY_SENDING = 0x03,   // some packets are ready to be sent
    };

    static inline bool isDirtyClean(dfrf_desc_t* desc) {
      return desc->dirty == DIRTY_CLEAN;
    }

    static inline bool isDirtyAging(dfrf_desc_t* desc) {
      return (desc->dirty & DIRTY_AGING) != 0;
    }

    static inline bool isDirtySending(dfrf_desc_t* desc) {
      return (desc->dirty & DIRTY_SENDING) != 0;
    }

    static inline void setDirtyClean(dfrf_desc_t* desc) {
      desc->dirty = DIRTY_CLEAN;
    }

    static inline void setDirtyAging(dfrf_desc_t* desc) {
      desc->dirty |= DIRTY_AGING;
    }

    static inline void setDirtySending(dfrf_desc_t* desc) {
      desc->dirty |= DIRTY_SENDING;
    }

    static inline void clearDirtyAging(dfrf_desc_t* desc) {
      desc->dirty &= ~DIRTY_AGING;
    }

    static inline void clearDirtySending(dfrf_desc_t* desc) {
      desc->dirty &= ~DIRTY_SENDING;
    }

    /*
    * There are three concurrent activities, that routing engine performs.
    *  (1) sending of packets,
    *  (2) processing of a received msg, and
    *  (3) aging of packets
    */
    enum
    {
        STATE_IDLE = 0x00,
        STATE_SENDING = 0x01,
        STATE_PROCESSING = 0x02,
        STATE_AGING = 0x04,
    };

    uint8_t state = STATE_IDLE;

    static inline bool isIdle() {
      return state == 0;
    }

    static inline void setIdle() {
      state = 0;
    }

    static inline bool isSending() {
      return (state & STATE_SENDING) != 0;
    }

    static inline bool isProcessing() {
      return (state & STATE_PROCESSING) != 0;
    }

    static inline bool isAging() {
      return (state & STATE_AGING) != 0;
    }

    static inline void setSending() {
      state |= STATE_SENDING;
    }

    static inline void setProcessing() {
      state |= STATE_PROCESSING;
    }

    static inline void setAging() {
      state |= STATE_AGING;
    }

    static inline void clearSending() {
      state &= ~STATE_SENDING;
    }

    static inline void clearProcessing() {
      state &= ~STATE_PROCESSING;
    }

    static inline void clearAging() {
      state &= ~STATE_AGING;
    }

    message_t rxMsgBuf, txMsgBuf;
    message_t* rxMsg = &rxMsgBuf;
    message_t* txMsg = &txMsgBuf;
    uint32_t rxMsgTimeStamp;

    /**
    * Packet is an encapsulation of data and timestamp. Multiple packets are transmitted
    * in a DFRF message. The packet timestamps are relative with respect to the message
    * timestamp.
    */
    typedef nx_struct packet
    {
        nx_uint32_t timeStamp; // time information is relative to the timestamp of the
                            // encapsulating DFRF message
        nx_uint8_t data[0];    // the packet data of length dataLength
    } dfrf_packet_t;

    /**
     * Get the maximum number of packets that fit in one message
     */
    uint8_t maxPacketsPerMsg(dfrf_desc_t* desc) {
//      DFRF_DBG("call Packet.maxPayloadLength() = %d\n",call Packet.maxPayloadLength());
//      DFRF_DBG("sizeof(dfrf_msg_t) = %d\n", sizeof(dfrf_msg_t));
//      DFRF_DBG("sizeof(dfrf_packet_t) = %d\n", sizeof(dfrf_packet_t));
//      DFRF_DBG("desc->dataLength = %d\n", desc->dataLength);

      return (call Packet.maxPayloadLength() - sizeof(dfrf_msg_t)) / (sizeof(dfrf_packet_t) + desc->dataLength);
    }

    /**
     * Cast a message_t* to dfrf_msg_t*
     **/
    static inline dfrf_msg_t* dfrfMsg(message_t* m) {
      return (dfrf_msg_t*)m->data;
    }

    /**
     * Get the first packet in a message_t payload
     **/
    static inline dfrf_packet_t* firstPacket(message_t* m) {
      return (dfrf_packet_t*)dfrfMsg(m)->data;
    }

    /**
     * Get the next packet in a message_t payload
     **/
    static inline dfrf_packet_t* nextPacket(message_t* m, uint8_t msgLength, dfrf_packet_t* currentPacket, uint8_t dataLength) {
      uint8_t packetSize = sizeof(dfrf_packet_t) + dataLength;
      dfrf_packet_t* rval = (dfrf_packet_t*) ( (uint8_t*)currentPacket + packetSize);

      if ((void*)rval >= (void*)m->data + msgLength)
        return NULL;
      else
        return rval;
    }


    // see selectData comments
    struct block freeBlock = { 0xFF };

    /**
    * Selects blocks for transmission from desc and stores them in selection.
    *   selection buffer is provided by caller.
    *    blocks are selected based on priority.
    *    blocks are sorted in decreasing order (priority field) in selection.
    */
    void selectData(struct descriptor *desc, struct block **selection)
    {
        uint8_t maxPriority = 0xFF;
        dfrf_block_t* blk = desc->blocks;
        dfrf_block_t** s = selection + maxPacketsPerMsg(desc);
        dfrf_block_t stopBlock = { 0x00 };

        DFRF_DBG("selectData(): selection addr = %d\n", (int)selection);
        DFRF_DBG("selectData(): maxPacketsPerMsg = %d\n", maxPacketsPerMsg(desc));


        // the blocks in selection are in decreasing order, initialization:
        //  - the last block has highest priority (0x00)
        //  - all other blocks have lowest priority (0xFF)
        //  - free Block needs to be a global variable, since if there is
        //  less to be transmitted packets in desc, than the maximum we
        //  can fit to the FloodRouting message, selection would point
        //  to non-existent data after returning
//        DFRF_DBG("selectData(): filling selection with free blocks\n");
        *s = &stopBlock;
        do {
            *(--s) = &freeBlock;
//            DFRF_DBG("selectData(): address %d links to freeBlock\n", (int)s);
        }
        while( s != selection );



        DFRF_DBG("selectData(): filling selection with blocks\n");
        // go through all blocks in desc, find the highest priority block
        // and insert them in selection in decreasing order
        do
        {
            uint8_t priority = blk->priority;
            //only block with even priority can be transmitted
            //see DfrfPolicy.nc for more details
            if( (priority & 0x01) == 0 && priority < maxPriority )
            {
                s = selection;
                while( priority < (*(s+1))->priority )
                {
                    *s = *(s+1);
                    ++s;
                }

                DFRF_DBG("selectData(): adding block to selection at address %d\n", (int)s);
                *s = blk;
                maxPriority = (*selection)->priority;
            }

            blk = nextBlock(desc, blk);
        } while( blk < desc->blocksEnd );

//        DFRF_DBG("selectData() finished\n");
    }

    /**
    * Creates FloodRoutingSync message by copying selection of blocks into the message.
    *    selection provides blocks in the decreasing order, the last
    *     block having the highest priority, that's why we want to
    *     start copying data from the end of selection.
    *    !!! as opposed to FloodRouting, FLOODROUTING_DEBUG does not work with
    *    FloodRoutingSync
    *    copyData() will be called after selectData().
    */
    void copyData(dfrf_desc_t* desc, dfrf_block_t** selection, uint32_t baseTimeStamp)
    {
        dfrf_block_t** s = selection + maxPacketsPerMsg(desc);
        dfrf_packet_t* pkt = firstPacket(txMsg);
        dfrf_msg_t* msg = dfrfMsg(txMsg);

        DFRF_DBG("copyData()\n");


        // set initial (empty) msg length
        call Packet.setPayloadLength(txMsg, sizeof(dfrf_msg_t));

        // set appId and timeStamp in msg
        msg->appId = desc->appId;
//        msg->timeStamp = baseTimeStamp;
        msg->location = call DfrfPolicy.getLocation[desc->appId]();

        // copy selection to msg
        while( s != selection && (*(--s))->priority != 0xFF )
        {

            // copy packet to msg
            memcpy(pkt->data, (*s)->data, desc->dataLength);
            // set packet timestamp relative to base timestamp
            pkt->timeStamp = baseTimeStamp - (*s)->timeStamp;

            // update msg length
            call Packet.setPayloadLength(txMsg, call Packet.payloadLength(txMsg) + sizeof(dfrf_packet_t) + desc->dataLength);

            DFRF_DBG("calling nextpacket with pkt = %d\n",(int)pkt);
            pkt = nextPacket(txMsg, call Packet.maxPayloadLength(), pkt, desc->dataLength);
            DFRF_DBG("nextpacket returned with pkt = %d\n",(int)pkt);
        }

      DFRF_DBG("copyData() DONE \n");
    }

    /**
    *  Task sendMsg() goes through the descriptions list and schedules radio messages for transmission.
    *   first a buffer is created, where the selected blocks will be stored, then for each
    *   description, we call selectData() (puts blocks into the selection buffer) and
    *   copyData() (copies selection blocks into a radio message).
    *   we transmit 1 TOSMSG containing the first blocks found in the first descriptor
    *   that had at least one block to be sent, 1 msg contains only blocks from 1 descriptor.
    *   if at least one block from a descriptor is transmitted, desc->dirty is set to aging.
    *  The only extension to FloodRouting is making sure the timestamp will be added at the
    *  message transmission.
    */
    task void sendMsg()
    {
        // allocate selection buffer, assuming that the data part of each block is at least 1 byte long;
        // note that selection contains certain number blocks that are copied into
        // a radio message
        struct block *selection[1 + ( call Packet.maxPayloadLength() - sizeof(dfrf_msg_t) ) / (sizeof(dfrf_packet_t) + 1)];

        struct descriptor *desc = firstDesc;
        uint32_t baseTimeStamp = 0;

        DFRF_DBG("sendMsg()\n");
//        DFRF_DBG("sendMsg(): allocated selection of size %d at addr %d\n", 1 + ( call Packet.maxPayloadLength() - sizeof(dfrf_msg_t) ) / (sizeof(dfrf_packet_t) + 1),(int)selection);
        while( desc != 0 )
        {
            //if DIRTY_SENDING, then there exists at least one block that need to be
            //transmitted in desc
            if( isDirtySending(desc) )
            {
                selectData(desc, selection);
//                DFRF_DBG("sendMsg(): setting baseTimeStamp\n");
                // we copy the blocks to the message, and for each block, we store the age of the block at a base time, which we chose to be now
                baseTimeStamp = call LocalTime.get();
//                DFRF_DBG("sendMsg(): calling copyData\n");
                copyData(desc, selection, baseTimeStamp);

                if( call Packet.payloadLength(txMsg) > sizeof(dfrf_msg_t) )
                {
                    error_t error_code;
                    // we send the message along with the base time
                    // TODO: make sure that length is set
                    DFRF_DBG("Sending radio message\n", error_code);

                    error_code = call TimeSyncAMSend.send(TOS_BCAST_ADDR, txMsg, call Packet.payloadLength(txMsg), baseTimeStamp);
                    if( error_code != SUCCESS ) {
                      DFRF_DBG("ERROR %u\n", error_code);

                      DFRF_DBG("posting sendMsg()\n");
                      if ( post sendMsg() == SUCCESS) {
                        DFRF_DBG("posted sendMsg()\n");
                      } else {
                        clearSending();
                      }

                    } else {
                      uint8_t i;
                      DFRF_DBG("SUCCESS\n");
                      for(i=0;i<call Packet.payloadLength(txMsg);i++)
                        DFRF_DBG_CLEAR("%02x ",txMsg->data[i]);
                      DFRF_DBG_CLEAR("\n");
                    }

                    call Leds.led0Toggle();

                    //we have sent at least one packet, this packet needs to be aged
                    setDirtyAging(desc);

                    return;
                }

            }
            desc = desc->nextDesc;
        }
        clearSending();
    }

    /**
    * Upon successfull sending, we call task sendMsg() again, to transmit all the data which
    * are waiting to be transmitted.
    */
    task void sendMsgDone()
    {
        dfrf_msg_t *msg = dfrfMsg(txMsg);
        uint8_t appId = msg->appId;
        struct descriptor *desc = getDescriptor(appId);

        if( desc != 0 )
        {
            //call policy.sent() on each of the transmitted blocks
            //this allows to update priority of the block according to the policy

            dfrf_packet_t* pkt = firstPacket(txMsg);
            while( pkt != NULL )
            {
              struct block *block = getBlock(desc, (uint8_t*)pkt->data);

              if( block->priority != 0xFF )
                  block->priority = call DfrfPolicy.sent[appId](block->priority);

              pkt = nextPacket(txMsg, call Packet.payloadLength(txMsg), pkt, desc->dataLength);
            }
        }

        DFRF_DBG("posting sendMsg()\n");
        if( post sendMsg() == SUCCESS) {
          DFRF_DBG("posted sendMsg()\n");
        } else {
            clearSending();
        }
    }

    event void TimeSyncAMSend.sendDone(message_t* p, error_t success)
    {
        if( success != SUCCESS )
        {
            DFRF_DBG("SendDone FAILed, reposting sendMsg()\n");

            DFRF_DBG("posting sendMsg()\n");
            if( post sendMsg() == SUCCESS ) {
              DFRF_DBG("posted sendMsg()\n");
            } else {
                clearSending();
            }
        }
        else
        {
            DFRF_DBG("SendDone SUCCESS, posting sendMsgDone()\n");

            if( post sendMsgDone() != SUCCESS)
                clearSending();
        }
    }


    /**
    * Blocks are extracted out from the received message and stored in routing
    * buffer, if the routing policy accepts the packet and the application that
    * initialized FloodRouting accepts the packet as well(signal
    * FloodRouting.receive[](data) == SUCCESS).
    **/
    task void procMsg()
    {
        dfrf_msg_t* msg = dfrfMsg(rxMsg);
        uint8_t appId = msg->appId;
        struct descriptor *desc = getDescriptor(appId);

        DFRF_DBG("Received message (&rxMsg= %d)", (int)rxMsg);


        call Leds.led1Toggle();
        if( desc != 0 && call DfrfPolicy.accept[appId](msg->location) )
        {
            dfrf_packet_t* pkt = firstPacket(rxMsg);
            while( pkt != NULL )
            {
                struct block *block = getBlock(desc, (uint8_t*)pkt->data);

                DFRF_DBG("Received packet (&packet = %d)", (int)pkt);

                if( block->priority == 0xFF )
                {
//                    block->timeStamp = msg->timeStamp - pkt->timeStamp;
                    block->timeStamp = rxMsgTimeStamp - pkt->timeStamp;

                    {
                      uint8_t i;
                      for(i=0;i<desc->dataLength;i++)
                        DFRF_DBG_CLEAR("%02x ",pkt->data[i]);
                      DFRF_DBG_CLEAR(" @ %d",block->timeStamp);
                      DFRF_DBG_CLEAR("\n");
                    }

                    if( signal DfrfReceive.receive[appId](pkt->data, block->timeStamp) != TRUE ){
                        pkt = nextPacket(rxMsg, call Packet.payloadLength(rxMsg), pkt, desc->dataLength);
                        continue;
                    }
                    memcpy(block->data, pkt->data, desc->dataLength);
                    block->priority = 0x00;
                    setDirtySending(desc);
                    setDirtyAging(desc);
                }

                block->priority = call DfrfPolicy.received[appId](msg->location, block->priority);
                if ( (block->priority & 0x01) == 0 )
                  setDirtySending(desc);

                pkt = nextPacket(rxMsg, call Packet.payloadLength(rxMsg), pkt, desc->dataLength);
            }

            if( !isSending() && isDirtySending(desc) ) {
              DFRF_DBG("posting sendMsg()\n");
              if ( post sendMsg() == SUCCESS ) {
                DFRF_DBG("posted sendMsg()\n");
                setSending();
              }
            }
        }

        clearProcessing();
    }

    void bufferSwitch(message_t** a, message_t** b) {
      message_t* tmp;

      tmp = *a;
      *a = *b;
      *b = tmp;
    }

    /**
    * Routing message from a different mote is scheduled for processing.
    *  since the pointer p which we obtain in the receive event can not be used
    *   after we return from the event handler, and we need to take long time to
    *   process the received message (i.e. we post a task), we need to save the
    *   pointer to some local variable (rxMsg).
    *
        * Timestamping extension requires rxMsg.timeStamp to contains offset of times of the sender and receiver.
        * The sender's timestamp taken at the transmission time of rxMsg is in rxMsg.timeStamp. The reciever's
        * timestamp can be obtained from the TimeStamping service. The offset can be computed
    * by subtractin these two values, consequentelly, we write the offset back into rxMsg.timeStamp
    **/
    event message_t* Receive.receive(message_t* p, void* payload, uint8_t len)
    {

        DFRF_DBG("Received message (&rxMsg= %d)", (int)p);
        call Leds.led2On();

        {
          uint8_t i;
          DFRF_DBG("Received radio message (dfrf_msg_t.data = %d) ", (int)(((dfrf_msg_t*)(p->data))->data));
          for(i=0;i<call Packet.payloadLength(p);i++)
            DFRF_DBG_CLEAR("%02x ",p->data[i]);
        }

        // TODO: we could still use packets with bad timestamps as acks...
        if( !isProcessing() && call TimeSyncPacket.isValid(p))
        {
//            ((dfrf_msg_t*)(p->data))->timeStamp = call TimeSyncPacket.eventTime(p);
            rxMsgTimeStamp = call TimeSyncPacket.eventTime(p);
//            DFRF_DBG_CLEAR(" @ %d\n",((dfrf_msg_t*)(p->data))->timeStamp);
            DFRF_DBG_CLEAR(" @ %d\n",rxMsgTimeStamp);

            bufferSwitch(&p, &rxMsg);

            if( post procMsg() == SUCCESS )
                setProcessing();
        } else {
            if(isProcessing())
              DFRF_DBG_CLEAR("discarded, reason: processing\n" );
            if(!call TimeSyncPacket.isValid(p))
              DFRF_DBG_CLEAR("discarded, reason: invalid timestamp\n" );
        }

        return p;
    }

    /**
    * Packets need to be aged, until they are thrown out from the buffer.
    *  moreover, after a packet has been aged, it may have to be resend (depending on
    *   the current policy), therefore we need to check for this and post a send task
    *   if it happens.
    *  dirty flag for desc is set to DIRTY_AGING, if there is at least one packet that
    *   needs to be aged, and set to DIRTY_SENDING if it needs to be sent().
    */
    task void age()
    {
        struct descriptor *desc = firstDesc;

        while( desc != 0 )
        {
            if( !isDirtyClean(desc) )
            {
                struct block *blk = desc->blocks;
                setDirtyClean(desc);
                do
                {
                    if( blk->priority != 0xFF )
                    {
                        blk->priority = call DfrfPolicy.age[desc->appId](blk->priority);

                        if( (blk->priority & 0x01) == 0 )
                            setDirtySending(desc);
                        else
                            setDirtyAging(desc);
                    }
                    blk = nextBlock(desc, blk);
                } while( blk < desc->blocksEnd );

                if( !isSending() && isDirtySending(desc) ) {
                  DFRF_DBG("posting sendMsg()\n");
                  if ( post sendMsg() == SUCCESS ) {
                    DFRF_DBG("posted sendMsg()\n");
                    setSending();
                  }
                }
            }
            desc = desc->nextDesc;
        }
        clearAging();
    }

    /**
    * Each timer event triggers aging of the blocks in descriptors.
    *  this may result in sending a radio message.
    */
    event void Timer.fired()
    {
        if( !isAging() && !isSending() && ( post age()== SUCCESS ) )
            setAging();
    }

    /** Find the actual block in a descriptor based on the match of unique data
    *   part, the new block gets assigned 0x00 priority and is sent from a task.
    *   Timestamp needs to be retrieved and stored.
    */
    command error_t DfrfSend.send[uint8_t id](void *data, uint32_t timeStamp)
    {
    struct descriptor *desc = getDescriptor(id);

      DFRF_DBG("DfrfSend.send ");

        if( desc != 0 )
        {
            struct block *blk = getBlock(desc, data);
            if( blk->priority == 0xFF )
            {
                memcpy(blk->data, data, desc->dataLength);
                blk->timeStamp = timeStamp;

                blk->priority = 0x00;

                setDirtySending(desc);

                if( !isSending() ) {
                  DFRF_DBG("posting sendMsg()\n");
                  if( post sendMsg() == SUCCESS ) {
                    DFRF_DBG("posted sendMsg()\n");
                    setSending();
                  }
                }

                call Leds.led2Toggle();
                DFRF_DBG("SUCCESS\n");

                    {
                      uint8_t i;
                      DFRF_DBG("Sending packet ");
                      for(i=0;i<desc->dataLength;i++)
                        DFRF_DBG_CLEAR("%02x ",((uint8_t*)data)[i]);
                      DFRF_DBG_CLEAR(" @ %d",timeStamp);
                      DFRF_DBG_CLEAR("\n");
                    }


                return SUCCESS;
            }
        }
        DFRF_DBG("FAIL\n");

        return FAIL;
    }

    command error_t DfrfControl.init[uint8_t id](uint8_t dataLength, uint8_t uniqueLength,
        void *buffer, uint16_t bufferLength)
    {
        dfrf_block_t *blk;
        dfrf_desc_t *desc;

        if( dataLength == 0 //dataLength is too small
            || dataLength > call Packet.maxPayloadLength() - sizeof(dfrf_msg_t) - sizeof(dfrf_packet_t) //single packet does not fit in TOSMSG
            || uniqueLength > dataLength
            || bufferLength <= //single packet does not fit in the buffer
                sizeof(dfrf_desc_t) + sizeof(dfrf_block_t)
            || getDescriptor(id)!=0 ) //the descriptor for id already exists
            return FAIL;

        desc = (dfrf_desc_t*)buffer;
        desc->appId = id;
        desc->dataLength = dataLength;
        desc->uniqueLength = uniqueLength;
        setDirtyClean(desc);

        buffer += bufferLength - (blockLength(desc)-1); // this is the first invalid position
        blk = desc->blocks;
        while( (void*)blk < buffer )
        {
            blk->priority = 0xFF;
            blk = nextBlock(desc, blk);
        }
        desc->blocksEnd = blk;

        desc->nextDesc = firstDesc;
        firstDesc = desc;

        if( !call Timer.isRunning() ) {
          call Timer.startPeriodic(1024);
        }

        return SUCCESS;
    }

    /** Just remove the descriptor from the linked list, the information is lost.
    *  stop() can not be undone (i.e. restarted).
    */
    command void DfrfControl.stop[uint8_t id]()
    {
        dfrf_desc_t **desc = &firstDesc;
        while( *desc != 0 )
        {
            if( (*desc)->appId == id )
            {
                *desc = (*desc)->nextDesc;
                return;
            }
            desc = &((*desc)->nextDesc);
        }

        // stop timer if all clients are stopped
        if( firstDesc == NULL) {
          call Timer.stop();
        }
    }

    default command uint16_t DfrfPolicy.getLocation[uint8_t id]() { return 0; }
    default command uint8_t DfrfPolicy.sent[uint8_t id](uint8_t priority) { return 0xFF; }
    default command bool DfrfPolicy.accept[uint8_t id](uint16_t location) { return FALSE; }
    default command uint8_t DfrfPolicy.received[uint8_t id](uint16_t location, uint8_t priority) { return 0xFF; }
    default command uint8_t DfrfPolicy.age[uint8_t id](uint8_t priority) { return priority; }
    default event bool DfrfReceive.receive[uint8_t id](void *data, uint32_t timestamp) { return FALSE; }

}
