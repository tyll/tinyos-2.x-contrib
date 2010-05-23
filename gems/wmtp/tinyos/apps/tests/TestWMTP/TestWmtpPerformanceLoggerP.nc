/*
 * WMTP - Wireless Modular Transport Protocol
 *
 * Copyright (c) 2008 Luis D. Pedrosa and IT - Instituto de Telecomunicacoes
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
 * luis.pedrosa@tagus.ist.utl.pt
 */

/**
 * WMTP Performance Logger.
 *
 * This component periodically logs usefull performance statistics to help
 * evaluate the WMTP transport protocol. Afterwards the logs are sent over to the
 * sink node, where they are relayed over to the compter for further analysis.
 *
 * @author Luis D. Pedrosa <luis.pedrosa@tagus.ist.utl.pt>
**/

#include "Wmtp.h"

module TestWmtpPerformanceLoggerP {
    provides {
        interface Init;
        interface StdControl;
    }
    uses {
        interface Boot;

        interface WmtpConnectionManager;
        interface WmtpSendMsg;
        interface WmtpReceiveMsg;
        interface WmtpCoreMonitor;

        interface SplitControl as SerialControl;
        interface AMSend as SerialSend;

        interface Timer<TMilli> as LogTimer;
        interface Timer<TMilli> as SendTimer;

        interface Leds;

        interface LogWrite;
        interface LogRead;
    }
} implementation {
    WmtpConnectionSpecification_t *Connections[LOGGER_NUM_MONITORED_CONNECTIONS];
    unsigned int RcvdMsgCnts[LOGGER_NUM_MONITORED_CONNECTIONS];
    unsigned char MinQueueAvailability;
    unsigned int GenMsgCnt;
    unsigned int SntWmtpMsgCnt;
    unsigned int RcvdWmtpMsgCnt;
    WmtpConnectionSpecification_t *ConnectionID = NULL;
    uint8_t logWrite = 0;
    uint8_t logRead = 0;
    WmtpPayload_t WmtpPayload;
    message_t MsgBuffer;

    event void Boot.booted() {
        call LogWrite.erase();
    }


    event void LogWrite.eraseDone(error_t error) {
        if ( error != SUCCESS ) {
            call LogWrite.erase();
            return;
        }
        if ( TOS_NODE_ID == 0 )
            call SerialControl.start();
    }

    command error_t Init.init() {
        unsigned char i;

        for ( i = 0; i < LOGGER_NUM_MONITORED_CONNECTIONS; i++ ) {
            Connections[i] = NULL;
            RcvdMsgCnts[i] = 0;
        }
        MinQueueAvailability = call WmtpCoreMonitor.GetCoreQueueAvailability();
        GenMsgCnt = 0;
        SntWmtpMsgCnt = 0;
        RcvdWmtpMsgCnt = 0;

        return SUCCESS;
    }


    event void SerialControl.startDone(error_t err) {
        if (err != SUCCESS) {
            call SerialControl.start();
        }
    }


    event void SerialControl.stopDone(error_t error) {};


    event void SerialSend.sendDone(message_t *msg, error_t error) {
        if ( logRead < logWrite ) {
            call LogRead.read( MsgBuffer.data, sizeof( EventRecord_t ) );
        } else {
            call Leds.set( 7 );
        }
    }


    command error_t StdControl.start() {
        dbg( "TESTWMTP", "WmtpPerformanceLoggerP: Started logging.\n" );

        if ( TOS_NODE_ID == 0 ) {
            static WmtpServiceSpecification_t SS;
            SS.Connectionless = TRUE;
            SS.ConnectionOriented = FALSE;
            SS.ServiceType = WMTP_SERVICETYPE_PACKETSINK;
            call WmtpConnectionManager.RegisterService( &SS );
        }

        call LogTimer.startPeriodic( LOGGER_PERIOD );

        return SUCCESS;
    }


    command error_t StdControl.stop() {
        dbg( "TESTWMTP", "WmtpPerformanceLoggerP: Stopped logging.\n" );

        call LogTimer.stop();

        call SendTimer.startOneShot( ((uint32_t) LOGGER_WAIT_TIME*TOS_NODE_ID) );

        return SUCCESS;
    }


    event void LogTimer.fired() {
        static EventRecord_t eventRecord;
        uint32_t curTime = call LogTimer.getNow();
        unsigned char i;

        dbg( "TESTWMTP", "WmtpPerformanceLoggerP: Logging event.\n" );

        eventRecord.time = curTime;
        eventRecord.nodeAddress = TOS_NODE_ID;
        eventRecord.minQueueAvailability = MinQueueAvailability;
        eventRecord.sntWmtpMsgCnt = SntWmtpMsgCnt;
        eventRecord.rcvdWmtpMsgCnt = RcvdWmtpMsgCnt;
        eventRecord.genMsgCnt = GenMsgCnt;
        for ( i = 0; i < LOGGER_NUM_MONITORED_CONNECTIONS && Connections[i]; i++ )
            eventRecord.rcvdMsgCnts[i] = RcvdMsgCnts[i];

        call LogWrite.append( &eventRecord, sizeof( EventRecord_t ) );

        for ( i = 0; i < LOGGER_NUM_MONITORED_CONNECTIONS; i++ )
            RcvdMsgCnts[i] = 0;
        MinQueueAvailability = call WmtpCoreMonitor.GetCoreQueueAvailability();
        GenMsgCnt = 0;
        SntWmtpMsgCnt = 0;
        RcvdWmtpMsgCnt = 0;
    }


    event void SendTimer.fired() {
        if ( TOS_NODE_ID == 0 ) {
            call LogRead.read(MsgBuffer.data, sizeof( EventRecord_t ) );
        } else {
            WmtpConnectionSpecification_t *CS;
            if ( call WmtpConnectionManager.GetNewConnectionSpecification( &CS ) != SUCCESS )
                return;
            CS->PathSpecification.PathType = WMTP_PATHTYPE_DECREMENTADDRESS;
            CS->FeatureSpecification.QueueAvailabilityShaper.Active = TRUE;
            CS->FeatureSpecification.Throttling.Period = 200;
            CS->FeatureSpecification.ReliabilityHandlerID = WMTP_RELIABILITYHANDLER_WMTPRELIABILITY;


            call WmtpConnectionManager.OpenConnection( CS );
        }
    }


    void checkQueueAvailability() {
        uint8_t qa = call WmtpCoreMonitor.GetCoreQueueAvailability();

        if ( qa < MinQueueAvailability )
            MinQueueAvailability = qa;
    }


    event error_t WmtpCoreMonitor.ServiceRegistered( WmtpServiceSpecification_t *ServiceSpecification ) {
        return SUCCESS;
    }
    event error_t WmtpCoreMonitor.ServiceCanceled( WmtpServiceSpecification_t *ServiceSpecification ) {
        return SUCCESS;
    }
    event error_t WmtpCoreMonitor.ConnectionOpened( WmtpConnectionSpecification_t *ConnectionSpecification ) {
        return SUCCESS;
    }
    event error_t WmtpCoreMonitor.ConnectionClosed( WmtpConnectionSpecification_t *ConnectionSpecification ) {
        return SUCCESS;
    }
    event error_t WmtpCoreMonitor.GeneratedPacket( WmtpQueueElement_t *Packet ) {
        GenMsgCnt++;

        checkQueueAvailability();

        return SUCCESS;
    }
    event error_t WmtpCoreMonitor.ReceivedPacket( WmtpQueueElement_t *Packet ) {
        checkQueueAvailability();

        return SUCCESS;
    }
    event error_t WmtpCoreMonitor.DeliveringPacket( WmtpQueueElement_t *Packet ) {
        unsigned char i;

        if ( Packet && Packet->ConnectionSpecification ) {
            for ( i = 0; i < LOGGER_NUM_MONITORED_CONNECTIONS; i++ ) {
                if ( Connections[i] == Packet->ConnectionSpecification )
                    break;
                if ( Connections[i] == NULL ) {
                    Connections[i] = Packet->ConnectionSpecification;
                    break;
                }
            }
            if ( i < LOGGER_NUM_MONITORED_CONNECTIONS )
                RcvdMsgCnts[i]++;
        }

        return SUCCESS;
    }
    event error_t WmtpCoreMonitor.SendingPacket( WmtpQueueElement_t *Packet ) {
        return SUCCESS;
    }
    event error_t WmtpCoreMonitor.DroppingPacket( WmtpQueueElement_t *Packet ) {
        return SUCCESS;
    }
    event error_t WmtpCoreMonitor.ReceivedWmtpMsg() {
        RcvdWmtpMsgCnt++;
        return SUCCESS;
    }
    event error_t WmtpCoreMonitor.SendingWmtpMsg() {
        return SUCCESS;
    }
    event error_t WmtpCoreMonitor.SentWmtpMsg() {
        SntWmtpMsgCnt++;
        return SUCCESS;
    }


    event error_t WmtpConnectionManager.ConnectionOpened( WmtpConnectionSpecification_t *ConnectionSpecification ) {
        ConnectionID = ConnectionSpecification;

        call LogRead.read( &WmtpPayload, sizeof( EventRecord_t ) );

        return SUCCESS;
    }


    event error_t WmtpConnectionManager.ConnectionReconfigured( WmtpConnectionSpecification_t *ConnectionSpecification ) {
        return SUCCESS;
    }


    event error_t WmtpConnectionManager.ConnectionClosed( WmtpConnectionSpecification_t *ConnectionSpecification ) {
        return SUCCESS;
    }


    event error_t WmtpSendMsg.ClearToSend( WmtpConnectionSpecification_t *ConnectionSpecification ) {
        if ( logRead < logWrite ) {
            call LogRead.read( &WmtpPayload, sizeof( EventRecord_t ) );
        } else {
            call Leds.set( 7 );
        }

        return SUCCESS;
    }


    event WmtpPayload_t *WmtpReceiveMsg.Receive( WmtpConnectionSpecification_t *ConnectionSpecification, uint8_t Length, WmtpPayload_t *Msg ) {
        memcpy( MsgBuffer.data, Msg, sizeof( EventRecord_t ) );
        call SerialSend.send( 0xffff, &MsgBuffer, sizeof( EventMsg_t ) );
        return Msg;
    }

    event void LogRead.readDone( void* buffer, storage_len_t len, error_t error ) {
        logRead++;

        if ( TOS_NODE_ID == 0 ) {
            call SerialSend.send( 0xffff, &MsgBuffer, sizeof( EventMsg_t ) );
        } else {
            call WmtpSendMsg.Send( ConnectionID, sizeof( EventRecord_t ), &WmtpPayload );
        }
    }

    event void LogWrite.appendDone( void* buffer, storage_len_t len, bool recordsLost, error_t error ) {
        logWrite++;
    }
    event void LogRead.seekDone(error_t error) {}
    event void LogWrite.syncDone(error_t error) {}
}
