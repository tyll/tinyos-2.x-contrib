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
 * WMTP 6 Node Flow Control Simulation Test.
 *
 * This component tests the WMTP flow control in a 6 node simulation.
 *
 * @author Luis D. Pedrosa <luis.pedrosa@tagus.ist.utl.pt>
 * @author Hugo Freire <hugo.freire@ist.utl.pt> (port to TinyOS 2.x)
**/

#include "Wmtp.h"

module TestWmtp6NodeFlowCtrlSimP {
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
        if ( TOS_NODE_ID != 0 ) {
            call WmtpControl.start();
            startTest();
        } else {
            call WmtpControl.start();
            call Timer.startPeriodic( 10240 );
        }
    }

    error_t startTest() {
        if ( TOS_NODE_ID == 0 ) {
            static unsigned char n = 0;
            WmtpConnectionSpecification_t *CS;
            if ( n <= 2 ) {
                if ( call WmtpConnectionManager.GetNewConnectionSpecification( &CS ) != SUCCESS )
                    return FAIL;
                dbg( "TESTWMTP", "TestWmtpP: Starting test case 10 - 6 node flow control simulation.\n" );
                CS->PathSpecification.PathType = WMTP_PATHTYPE_SOURCEROUTEDCONNECTION;
                CS->PathSpecification.PathData.SourceRoutedConnection.ServiceSpecification.ServiceType = WMTP_SERVICETYPE_PACKETSINK;
                CS->FeatureSpecification.QueueAvailabilityShaper.Active = TRUE;
                CS->FeatureSpecification.FlowControl.RemotePeriod = 512;
                if ( n == 0 ) {
                    CS->PathSpecification.PathData.SourceRoutedConnection.NumHops = 1;
                    CS->PathSpecification.PathData.SourceRoutedConnection.Hops[0] = 3;
                } else if ( n == 1 ) {
                    CS->PathSpecification.PathData.SourceRoutedConnection.NumHops = 2;
                    CS->PathSpecification.PathData.SourceRoutedConnection.Hops[0] = 1;
                    CS->PathSpecification.PathData.SourceRoutedConnection.Hops[1] = 4;
                } else if ( n == 2 ) {
                    CS->PathSpecification.PathData.SourceRoutedConnection.NumHops = 3;
                    CS->PathSpecification.PathData.SourceRoutedConnection.Hops[0] = 1;
                    CS->PathSpecification.PathData.SourceRoutedConnection.Hops[1] = 2;
                    CS->PathSpecification.PathData.SourceRoutedConnection.Hops[2] = 5;
                }
                dbg( "TESTWMTP", "TestWmtpP: Opening connection.\n" );
                call WmtpConnectionManager.OpenConnection( CS );
                n++;
            }
        } else if ( TOS_NODE_ID >= 3 ) {
            static WmtpServiceSpecification_t SS;
            dbg( "TESTWMTP", "TestWmtpP: Starting test case 10 - 6 node flow control simulation.\n" );
            SS.Connectionless = FALSE;
            SS.ConnectionOriented = TRUE;
            SS.ServiceType = WMTP_SERVICETYPE_PACKETSINK;
            dbg( "TESTWMTP", "TestWmtpP: Registering service.\n" );
            call WmtpConnectionManager.RegisterService( &SS );
        }
        return SUCCESS;
    }

    event void Timer.fired() {
        startTest();
    }

    event error_t WmtpConnectionManager.ConnectionOpened( WmtpConnectionSpecification_t *ConnectionSpecification ) {
        if ( ConnectionSpecification->PathSpecification.PathType == WMTP_PATHTYPE_SOURCEROUTEDCONNECTION ) {
            ConnectionID = ConnectionSpecification;

            dbg( "TESTWMTP", "TestWmtpP: Connection opened.\n" );

            if ( TOS_NODE_ID != 0 ) {
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
        return Msg;
    }
}
