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
 * Author: Andras Nadas, Miklos Maroti, Sachin Mujumdar
 * Author: Janos Sallai (sallai@isis.vanderbilt.edu)
 *
 */

/**
 * RemoteControlM contains the implementation of the RemoteControl service.
 * The RemoteControl service allows sending commands, and starting/stopping and
 * restarting TinyOS components on all or on a subset of nodes of a multi-hop network,
 * and it routes acknowledgments or return values from the affected components
 * back to the base station.
 *
 */

#include "RemoteControl.h"

module RemoteControlM
{
    provides
    {
        interface StdControl;
    }

    uses
    {
        interface IntCommand[uint8_t id];
        interface DataCommand[uint8_t id];
        interface StdControl as StdControlCommand[uint8_t id];

        interface Receive;
        interface AMSend;
        interface AMPacket;
        interface Packet;
        interface Timer<TMilli>;
        interface Random;
        interface ParameterInit<uint16_t> as RandomInit;
        interface DfrfSend<reply_t>;
        interface StdControl as DfrfControl;
        
#if defined(DFRF_32KHZ)
        interface LocalTime<T32khz>;
#else
        interface LocalTime<TMilli>;
#endif
        
    }
}

implementation
{
    //***
    // Globals, typedefs and enums

#ifndef TOS_SUBGROUP_ADDR
#define TOS_SUBGROUP_ADDR 0xFF00
#endif

    uint8_t sentSeqNum;
    message_t tosMsg;
    uint8_t lastAppId;
    uint8_t ackTimer;
    uint16_t ackReturnValue;

    uint8_t state;
    enum
    {
        STATE_BUSY = 0x00,
        STATE_FORWARDED = 0x01,
        STATE_EXECUTED = 0x02,
        STATE_IDLE = 0x03,
    };

    static inline am_addr_t localAddress() {
      return call AMPacket.address();
    }

    static inline remotecontrol_t* rcCommand() {
      return (remotecontrol_t*)tosMsg.data;
    }

    //***
    // StdControl interface

    /**
     * Start floodrouting, start timer. The timer is responsible for
     * defering the returning of the acknowledgement values, as well as
     * for the deferred forwarding of the command messages.
     */
    command error_t StdControl.start()
    {
        ackTimer = 0;
        sentSeqNum = 0;
        rcCommand()->seqNum = 0;
        state = STATE_IDLE;

    		call RandomInit.init(localAddress());
    		call DfrfControl.start();
        call Timer.startPeriodic(1024/4);

        return SUCCESS;
    }

    /**
     * Stop floodrouting and timer.
     */
    command error_t StdControl.stop()
    {
        call DfrfControl.stop();
        call Timer.stop();

        return SUCCESS;
    }


    //***
    // Timer interface

    /**
     * The timer is responsible for defering the returning of the
     * acknowledgement values, as well as for the deferred forwarding of
     * the command messages.
     * We defer routing the acknowledgement back to the root - we don't want it
     * to collide with the disseminated remote control messages. We forward the
     * most recently received remote control message.
     */
    event void Timer.fired()
    {
        // if ackTimer is not 0 we decrease it
        if (ackTimer>0 && --ackTimer==0){
            // if ackTimer is 0 we route the acknowledgement back to the root
           reply_t reply;
           reply.nodeId = localAddress();
           reply.seqNum = rcCommand()->seqNum;
           reply.ret = ackReturnValue;
           call DfrfSend.send(&reply, call LocalTime.get());
        }
        // if ackTimer is not 0 and the remote control command has not been
        // forwarded then we forward it
        else if( sentSeqNum != rcCommand()->seqNum ){
            if (call AMSend.send(TOS_BCAST_ADDR, &tosMsg, call Packet.payloadLength(&tosMsg)) != SUCCESS)
                state |= STATE_FORWARDED;
        }
    }

    //***
    // SendMsg interface

    /**
     * Called when the remote control message has been forwarded.
     */
    event void AMSend.sendDone(message_t* p, error_t success)
    {
        sentSeqNum = rcCommand()->seqNum;
        state |= STATE_FORWARDED;
    }

    /**
     * Execute an StdControlCommand.
     */
    void task execute()
    {
        lastAppId = rcCommand()->appId;

        if( rcCommand()->dataType == 0 ) {     // IntCommand
            uint16_t cmd = *(nx_uint16_t*)(rcCommand()->data);
            call IntCommand.execute[lastAppId](cmd);
        }
        else if( rcCommand()->dataType == 1 ) {    // DataCommand
            call DataCommand.execute[lastAppId](rcCommand()->data,
                call Packet.payloadLength(&tosMsg) - sizeof(remotecontrol_t));
        }
        else if( rcCommand()->dataType == 2 )    // StdControlCommand
        {
            uint8_t cmd = *(nx_uint8_t*)(rcCommand()->data);

            reply_t reply;
            reply.nodeId = localAddress();
            reply.seqNum = rcCommand()->seqNum;
            reply.ret = 0xFF;

            if( cmd == 0 )  // stop
                reply.ret = call StdControlCommand.stop[lastAppId]();
            else if( cmd == 1 ) // start
                reply.ret = call StdControlCommand.start[lastAppId]();
            else if( cmd == 2 ) { // restart
                reply.ret = ecombine(call StdControlCommand.stop[lastAppId](),
                    call StdControlCommand.start[lastAppId]());
            }
            call DfrfSend.send(&reply, call LocalTime.get());
        }

        state |= STATE_EXECUTED;
    }

    //***
    // ReceiveMsg interface

    /**
     * Receive remote control message.
     */
    event message_t* Receive.receive(message_t* p, void* payload, uint8_t len)
    {
        remotecontrol_t* newRcCommand = (remotecontrol_t*)payload;
        int8_t age = newRcCommand->seqNum - rcCommand()->seqNum;

        if( state == STATE_IDLE && ( age <= -50 || 0 < age ) )
        {
            state = STATE_BUSY;
            tosMsg = *p;

            if( rcCommand()->target == localAddress()
                    || rcCommand()->target == TOS_BCAST_ADDR
                    || rcCommand()->target == TOS_SUBGROUP_ADDR )
                post execute();
            else
            {
                // to allow acks from nodes where execute is not called
                lastAppId = rcCommand()->appId;
                state |= STATE_EXECUTED;
            }
        }
        return p;
    }


    /**
     * Randomize acknowledgements: 0 - 2 sec delay
     */
    void startAckTimer(){
    	ackTimer = call Random.rand16() & 0x7;
    }


    //***
    // IntCommand interface

    /**
     * When execution has finished, store return value in global and defer
     * routing it back to the root.
     */
    event void IntCommand.ack[uint8_t appId](uint16_t returnValue)
    {
        if( appId == lastAppId ) {
            ackReturnValue = returnValue;
            startAckTimer();
        }
    }


    //***
    // DataCommand interface

    /**
     * When execution has finished, store return value in global and defer
     * routing it back to the root.
     */
    event void DataCommand.ack[uint8_t appId](uint16_t returnValue)
    {
        if( appId == lastAppId ) {
            ackReturnValue = returnValue;
            startAckTimer();
        }
    }


    //***
    // Default wirings

    default command void IntCommand.execute[uint8_t appId](uint16_t param) {}
    default command void DataCommand.execute[uint8_t appId](void *data, uint8_t length) {}
    default command error_t StdControlCommand.start[uint8_t appId]() { return 0xFF; }
    default command error_t StdControlCommand.stop[uint8_t appId]() { return 0xFF; }
}
