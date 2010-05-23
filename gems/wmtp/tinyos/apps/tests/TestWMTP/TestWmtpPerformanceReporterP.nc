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
 * Wmtp Performance Monitor.
 *
 * This component periodically presents usefull performance statistics to help
 * evaluate the Wmtp transport protocol.
 *
 * @author Luis D. Pedrosa <luis.pedrosa@tagus.ist.utl.pt>
**/

#include "Wmtp.h"

module TestWmtpPerformanceReporterP {
    provides {
        interface Init;
    }
    uses {
        interface Boot;
        interface WmtpCoreMonitor;
        interface Timer<TMilli>;
    }
} implementation {
    WmtpConnectionSpecification_t *Connections[REPORTER_NUM_MONITORED_CONNECTIONS];
    unsigned int RcvdMsgCnts[REPORTER_NUM_MONITORED_CONNECTIONS];
    unsigned char MinQueueAvailability;
    unsigned int GenMsgCnt;
    unsigned int SntWmtpMsgCnt;
    unsigned int RcvdWmtpMsgCnt;

    /**
     * Initializes the module.
    **/

    command error_t Init.init() {
        unsigned char i;

        for ( i = 0; i < REPORTER_NUM_MONITORED_CONNECTIONS; i++ ) {
            Connections[i] = NULL;
            RcvdMsgCnts[i] = 0;
        }
        MinQueueAvailability = call WmtpCoreMonitor.GetCoreQueueAvailability();
        GenMsgCnt = 0;
        SntWmtpMsgCnt = 0;
        RcvdWmtpMsgCnt = 0;

        return SUCCESS;
    }


    event void Boot.booted() {
        if ( TOS_NODE_ID == 0 ) {
            dbg( "REPORTER", "WmtpPerformanceReporterP: \"Time\";\"Node\";\"MinQueueAvailability\";\"SentWmtpMsgs\";\"ReceivedWmtpMsgs\";\"GeneratedPackets\";\"ReceivedPacketPerConnection\"\n" );
        }

        return call Timer.startPeriodic( REPORTER_PERIOD );
    }


    event void Timer.fired() {
        uint32_t curTime = call Timer.getNow();
        unsigned char i;
        static char TxtBfr[100];
        char *TxtPtr = TxtBfr;

        TxtPtr += sprintf( TxtPtr, "WmtpPerformanceReporterP: %lu;%u;%u;%u;%u;%u", curTime, TOS_NODE_ID, MinQueueAvailability, SntWmtpMsgCnt, RcvdWmtpMsgCnt, GenMsgCnt );

        for ( i = 0; i < REPORTER_NUM_MONITORED_CONNECTIONS && Connections[i]; i++ )
            TxtPtr += sprintf( TxtPtr, ";%d", RcvdMsgCnts[i] );
        sprintf( TxtPtr, "\n" );

        dbg( "REPORTER", "%s", TxtBfr );

        for ( i = 0; i < REPORTER_NUM_MONITORED_CONNECTIONS; i++ )
            RcvdMsgCnts[i] = 0;
        MinQueueAvailability = call WmtpCoreMonitor.GetCoreQueueAvailability();
        GenMsgCnt = 0;
        SntWmtpMsgCnt = 0;
        RcvdWmtpMsgCnt = 0;
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
            for ( i = 0; i < REPORTER_NUM_MONITORED_CONNECTIONS; i++ ) {
                if ( Connections[i] == Packet->ConnectionSpecification )
                    break;
                if ( Connections[i] == NULL ) {
                    Connections[i] = Packet->ConnectionSpecification;
                    break;
                }
            }
            if ( i < REPORTER_NUM_MONITORED_CONNECTIONS )
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
}
