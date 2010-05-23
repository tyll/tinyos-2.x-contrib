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
 * WMTP Reliability Test.
 *
 * This component tests the WMTP reliability feature.
 *
 * @author Luis D. Pedrosa <luis.pedrosa@tagus.ist.utl.pt>
 * @author Hugo Freire <hugo.freire@ist.utl.pt> (port to TinyOS 2.x)
**/

#include "Wmtp.h"

module TestWmtpReliabilityP {
    uses {
        interface Boot;
        interface StdControl as WmtpControl;
        interface WmtpConnectionManager;
        interface WmtpSendMsg;
        interface WmtpReceiveMsg;
        interface Timer<TMilli>;
        interface Leds;
    }
} implementation {
    WmtpConnectionSpecification_t *ConnectionID = NULL;

    error_t startTest();

    event void Boot.booted() {
        if ( TOS_NODE_ID == 0 ) {
            call WmtpControl.start();
            startTest();
        } else {
            call WmtpControl.start();
            call Timer.startPeriodic( 10240 );
        }
    }

    error_t startTest() {
        if ( TOS_NODE_ID == 0 ) {
            static WmtpServiceSpecification_t SS;
            dbg( "TESTWMTP", "TestWmtpP: Starting reliability test.\n" );
            SS.Connectionless = FALSE;
            SS.ConnectionOriented = TRUE;
            SS.ServiceType = WMTP_SERVICETYPE_PACKETSINK;
            dbg( "TESTWMTP", "TestWmtpP: Registering service.\n" );
            call WmtpConnectionManager.RegisterService( &SS );
        } else if ( TOS_NODE_ID == 4 ) {
            WmtpConnectionSpecification_t *CS;
            if ( call WmtpConnectionManager.GetNewConnectionSpecification( &CS ) != SUCCESS )
                return FAIL;
            dbg( "TESTWMTP", "TestWmtpP: Starting test case 7 - Basic Reliability.\n" );
            CS->PathSpecification.PathType = WMTP_PATHTYPE_SOURCEROUTEDCONNECTION;
            CS->PathSpecification.PathData.SourceRoutedConnection.ServiceSpecification.ServiceType = WMTP_SERVICETYPE_PACKETSINK;
            CS->PathSpecification.PathData.SourceRoutedConnection.NumHops = 4;
            CS->PathSpecification.PathData.SourceRoutedConnection.Hops[0] = 3;
            CS->PathSpecification.PathData.SourceRoutedConnection.Hops[1] = 2;
            CS->PathSpecification.PathData.SourceRoutedConnection.Hops[2] = 1;
            CS->PathSpecification.PathData.SourceRoutedConnection.Hops[3] = 0;
            CS->FeatureSpecification.QueueAvailabilityShaper.Active = TRUE;
            CS->FeatureSpecification.Throttling.Period = 10240;
            CS->FeatureSpecification.ReliabilityHandlerID = WMTP_RELIABILITYHANDLER_WMTPRELIABILITY;
            dbg( "TESTWMTP", "TestWmtpP: Opening connection.\n" );
            call WmtpConnectionManager.OpenConnection( CS );
        }
        return SUCCESS;
    }

    event void Timer.fired() {
        if ( ConnectionID == NULL ) startTest();
    }

    event error_t WmtpConnectionManager.ConnectionOpened( WmtpConnectionSpecification_t *ConnectionSpecification ) {
        if ( ConnectionSpecification->PathSpecification.PathType == WMTP_PATHTYPE_SOURCEROUTEDCONNECTION ) {
            ConnectionID = ConnectionSpecification;

            dbg( "TESTWMTP", "TestWmtpP: Connection opened.\n" );

            if ( TOS_NODE_ID == 4 ) {
                static WmtpPayload_t PL;
                call Leds.led0Toggle();
                dbg( "TESTWMTP", "TestWmtpP: Sending message (c = 0).\n" );
                PL.Data[0] = 0;
                return call WmtpSendMsg.Send( ConnectionID, 0, &PL );
            } else return SUCCESS;
        } else {
            return SUCCESS;
        }
    }

    event error_t WmtpConnectionManager.ConnectionReconfigured( WmtpConnectionSpecification_t *ConnectionSpecification ) {
        return SUCCESS;
    }

    event error_t WmtpConnectionManager.ConnectionClosed( WmtpConnectionSpecification_t *ConnectionSpecification ) {
        return SUCCESS;
    }

    event error_t WmtpSendMsg.ClearToSend( WmtpConnectionSpecification_t *ConnectionSpecification ) {
        if ( TOS_NODE_ID != 0 ) {
            static WmtpPayload_t PL;
            static uint8_t c = 1;
            call Leds.led0Toggle();
            dbg( "TESTWMTP", "TestWmtpP: Sending message (c = %d).\n", c );
            PL.Data[0] = c++;
            return call WmtpSendMsg.Send( ConnectionID, 1, &PL );
        } else return SUCCESS;
    }

    event WmtpPayload_t *WmtpReceiveMsg.Receive( WmtpConnectionSpecification_t *ConnectionSpecification, uint8_t Length, WmtpPayload_t *Msg ) {
        static uint8_t c = 255;
        call Leds.led1Toggle();
        dbg( "TESTWMTP", "TestWmtpP: Received message (c = %d).\n", Msg->Data[0] );

        if ( Msg->Data[0] == c ) {
            dbg( "TESTWMTP", "TestWmtpP: Duplicate message.\n" );
        } else if ( Msg->Data[0] != ((c + 1) & 0xFF) ) {
            dbg( "TESTWMTP", "TestWmtpP: Message out of order.\n" );
        }
        c = Msg->Data[0];

        return Msg;
    }
}
