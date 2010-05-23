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
 * WMTP Connectionless Routing Test.
 *
 * This component tests the WMTP connectionless routing.
 *
 * @author Luis D. Pedrosa <luis.pedrosa@tagus.ist.utl.pt>
 * @author Hugo Freire <hugo.freire@ist.utl.pt> (port to TinyOS 2.x)
**/

#include "Wmtp.h"

module TestWmtpConnectionlessRoutingP {
    uses {
        interface Boot;
        interface StdControl as WmtpControl;
        interface WmtpConnectionManager;
        interface WmtpSendMsg;
        interface WmtpReceiveMsg;
        interface Timer<TMilli>;
        interface Leds;
        interface SplitControl as RadioControl;
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
            dbg( "TESTWMTP", "TestWmtpP: Starting connectionless routing test.\n" );
            SS.Connectionless = TRUE;
            SS.ConnectionOriented = FALSE;
            SS.ServiceType = WMTP_SERVICETYPE_PACKETSINK;
            dbg( "TESTWMTP", "TestWmtpP: Registering service.\n" );
            call WmtpConnectionManager.RegisterService( &SS );
        } else if ( TOS_NODE_ID == 4 ) {
            WmtpConnectionSpecification_t *CS;
            if ( call WmtpConnectionManager.GetNewConnectionSpecification( &CS ) != SUCCESS )
                return FAIL;
            dbg( "TESTWMTP", "TestWmtpP: Starting connectionless routing test.\n" );
            CS->PathSpecification.PathType = WMTP_PATHTYPE_DECREMENTADDRESS;
            dbg( "TESTWMTP", "TestWmtpP: Opening connection.\n" );
            call WmtpConnectionManager.OpenConnection( CS );
        }
        return SUCCESS;
    }

    event void Timer.fired() {
        if ( ConnectionID != NULL ) {
            static WmtpPayload_t PL;
            call Leds.led0Toggle();
            dbg( "TESTWMTP", "TestWmtpP: Sending message.\n" );
            call WmtpSendMsg.Send( ConnectionID, 0, &PL );
        } else startTest();
    }

    event error_t WmtpConnectionManager.ConnectionOpened( WmtpConnectionSpecification_t *ConnectionSpecification ) {
        if ( ConnectionSpecification->PathSpecification.PathType == WMTP_PATHTYPE_DECREMENTADDRESS ) {
            ConnectionID = ConnectionSpecification;
            dbg( "TESTWMTP", "TestWmtpP: Connection opened.\n" );
            call Timer.startPeriodic( 2048 );
            return SUCCESS;
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
        static WmtpPayload_t PL;
        static uint8_t c = 1;
        call Leds.led0Toggle();
        dbg( "TESTWMTP", "TestWmtpP: Sending message (c = %d).\n", c );
        PL.Data[0] = c++;
        return call WmtpSendMsg.Send( ConnectionID, 1, &PL );
    }

    event WmtpPayload_t *WmtpReceiveMsg.Receive( WmtpConnectionSpecification_t *ConnectionSpecification, uint8_t Length, WmtpPayload_t *Msg ) {
        static uint8_t c = 255;
        call Leds.led1Toggle();
        dbg( "TESTWMTP", "TestWmtpP: Received message (c = %d).\n", Msg->Data[0] );
        return Msg;
    }
}
