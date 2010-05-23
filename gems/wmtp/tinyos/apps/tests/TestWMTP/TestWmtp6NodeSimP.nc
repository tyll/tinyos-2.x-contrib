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
 * Wmtp 6 Node Simulation Test.
 *
 * This component tests the Wmtp in a 6 node simulation.
 *
 * @author Luis D. Pedrosa <luis.pedrosa@tagus.ist.utl.pt>
 * @author Hugo Freire <hugo.freire@ist.utl.pt> (port to TinyOS 2.x)
**/

#include "Wmtp.h"
#include "TestWmtp.h"
#include "printf.h"

module TestWmtp6NodeSimP {
    uses {
        interface Boot;
        interface StdControl as WmtpControl;
        interface WmtpConnectionManager;
        interface WmtpSendMsg;
        interface WmtpReceiveMsg;
        interface Timer<TMilli>;
        interface Leds;
//#if (TEST_PERFORMANCE == 1)
        interface WmtpCoreMonitor;
//#elif (TEST_PERFORMANCE == 2) // #if (TEST_PERFORMANCE == 1)
//        interface StdControl as LoggerControl;
//#endif // #elif (TEST_PERFORMANCE == 2)
    }
} implementation {
    WmtpConnectionSpecification_t *ConnectionID = NULL;
    WmtpConnectionSpecification_t *CS;
    WmtpServiceSpecification_t SS;

    error_t startTest();

    event void Boot.booted() {
#if (TEST_PERFORMANCE == 2)
        call WmtpControl.start();
        if ( TOS_NODE_ID == 0 )
            startTest();
        call LoggerControl.start();
        call Timer.startPeriodic( 10240 );
#else
        call WmtpControl.start();
        if ( TOS_NODE_ID == 0 )
            startTest();
        else {
            if ( TOS_NODE_ID >= 3 )
                call Timer.startPeriodic( 10240 );
        }
#endif // (TEST_PERFORMANCE == 2)  
    }

    error_t startTest() {
        if ( TOS_NODE_ID == 0 ) {
            dbg( "TESTWMTP", "TestWmtpP: Starting test case 9 - 6 node simulation.\n" );
            SS.Connectionless = FALSE;
            SS.ConnectionOriented = TRUE;
            SS.ServiceType = WMTP_SERVICETYPE_SINKID;
            SS.ServiceData.SinkID.Value = 0;
            dbg( "TESTWMTP", "TestWmtpP: Registering service.\n" );
            call WmtpConnectionManager.RegisterService( &SS );
        } else if ( TOS_NODE_ID >= 3 ) {
            if ( call WmtpConnectionManager.GetNewConnectionSpecification( &CS ) != SUCCESS )
                return FAIL;
            dbg( "TESTWMTP", "TestWmtpP: Starting test case 9 - 6 node simulation.\n" );
            CS->PathSpecification.PathType = WMTP_PATHTYPE_SOURCEROUTEDCONNECTION;
            CS->PathSpecification.PathData.SourceRoutedConnection.ServiceSpecification.ServiceType = WMTP_SERVICETYPE_SINKID;
            CS->PathSpecification.PathData.SourceRoutedConnection.ServiceSpecification.ServiceData.SinkID.Value = 0;
            CS->FeatureSpecification.QueueAvailabilityShaper.Active = TRUE;
            CS->FeatureSpecification.Throttling.Period = 1 * 1024;
            CS->FeatureSpecification.CongestionControl.Active = TRUE;
            CS->FeatureSpecification.Fairness.SinkID = 0;
            CS->FeatureSpecification.Fairness.Weight = 1;//TOS_NODE_ID2;
            CS->FeatureSpecification.ReliabilityHandlerID = WMTP_RELIABILITYHANDLER_WMTPRELIABILITY;
            if ( TOS_NODE_ID == 3 ) {
                CS->PathSpecification.PathData.SourceRoutedConnection.NumHops = 1;
                CS->PathSpecification.PathData.SourceRoutedConnection.Hops[0] = 0;
            } else if ( TOS_NODE_ID == 4 ) {
                CS->PathSpecification.PathData.SourceRoutedConnection.NumHops = 2;
                CS->PathSpecification.PathData.SourceRoutedConnection.Hops[0] = 1;
                CS->PathSpecification.PathData.SourceRoutedConnection.Hops[1] = 0;
            } else if ( TOS_NODE_ID == 5 ) {
                //CS->FeatureSpecification.Throttling.Period = 200;
                //CS->QoSSpecification.MaxPeriod = 200;
                //CS->QoSSpecification.PreferredPeriod = 200;
                CS->FeatureSpecification.Fairness.Weight = 2;//TOS_NODE_ID2;
                CS->PathSpecification.PathData.SourceRoutedConnection.NumHops = 3;
                CS->PathSpecification.PathData.SourceRoutedConnection.Hops[0] = 2;
                CS->PathSpecification.PathData.SourceRoutedConnection.Hops[1] = 1;
                CS->PathSpecification.PathData.SourceRoutedConnection.Hops[2] = 0;
            }
            //printf("TestWmtpP: Opening connection.\n");
            dbg( "TESTWMTP", "TestWmtpP: Opening connection.\n" );
            call WmtpConnectionManager.OpenConnection( CS );
        }
        return SUCCESS;
    }

    event void Timer.fired() {
#if (TEST_PERFORMANCE == 2)
        static unsigned char n = 0;
#endif // #elif (TEST_PERFORMANCE == 2)        	

        if ( ConnectionID == NULL ) startTest();

#if (TEST_PERFORMANCE == 2)
        if ( ++n >= LOGGER_DURATION / 10 ) {
            call Timer.stop();
            call WmtpConnectionManager.CloseConnection( ConnectionID );
            if ( TOS_NODE_ID == 0 )
                call WmtpConnectionManager.CancelService( &SS );
            if ( TOS_NODE_ID >= 3 )
                call WmtpConnectionManager.DestroyConnectionSpecification( CS );
            call LoggerControl.stop();
        }
#endif // #elif (TEST_PERFORMANCE == 2)         
    }

    event error_t WmtpConnectionManager.ConnectionOpened( WmtpConnectionSpecification_t *ConnectionSpecification ) {
        if ( ConnectionSpecification->PathSpecification.PathType == WMTP_PATHTYPE_SOURCEROUTEDCONNECTION ) {
            ConnectionID = ConnectionSpecification;

            //printf("TestWmtpP: Connection opened.\n");
            //printfflush();
            dbg( "TESTWMTP", "TestWmtpP: Connection opened.\n" );

            if ( TOS_NODE_ID != 0 ) {
                static WmtpPayload_t PL;
                call Leds.led0Toggle();
                //printf("TestWmtpP: Sending message (c = 0).\n");
                //printfflush();
                dbg( "TESTWMTP", "TestWmtpP: Sending message (c = 0).\n" );
                PL.Data[0] = 0;
                PL.Data[1] = TOS_NODE_ID;
                return call WmtpSendMsg.Send( ConnectionID, 2, &PL );
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
            //printf("TestWmtpP: Sending message (c = %d).\n", c );
            //printfflush();
            dbg( "TESTWMTP", "TestWmtpP: Sending message (c = %d).\n", c );
            PL.Data[0] = c++;
            PL.Data[1] = TOS_NODE_ID;
            return call WmtpSendMsg.Send( ConnectionID, 2, &PL );
        } else return SUCCESS;
    }

    event WmtpPayload_t *WmtpReceiveMsg.Receive( WmtpConnectionSpecification_t *ConnectionSpecification, uint8_t Length, WmtpPayload_t *Msg ) {
        call Leds.led1Toggle();
        dbg( "TESTWMTP", "TestWmtpP: Received message (c = %d) from node %d.\n", Msg->Data[0], Msg->Data[1]);
        printf("Received message (c = %d) from node %d.\n", Msg->Data[0], Msg->Data[1]);
        printfflush();
        return Msg;
    }

//#if (TEST_PERFORMANCE == 1)
    void checkCongestion() {
        uint8_t CoreQueueMaxSize = call WmtpCoreMonitor.GetCoreQueueMaxSize();
        uint8_t CoreQueueAvailability = call WmtpCoreMonitor.GetCoreQueueAvailability();

        printf("Core Queue Availability: %d/%d.\n", CoreQueueAvailability, CoreQueueMaxSize);
        printfflush();

        if (CoreQueueAvailability < CoreQueueMaxSize/3) {
        	printf("Core Queue Availability below 1/3: Congestion detected!\n");
        	printfflush();
        	call Leds.led2On();
        }
        else {      	
        	call Leds.led2Off();
        }
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
        return SUCCESS;
    }
    event error_t WmtpCoreMonitor.ReceivedPacket( WmtpQueueElement_t *Packet ) {
    		checkCongestion();
        return SUCCESS;
    }
    event error_t WmtpCoreMonitor.DeliveringPacket( WmtpQueueElement_t *Packet ) {
        return SUCCESS;
    }
    event error_t WmtpCoreMonitor.SendingPacket( WmtpQueueElement_t *Packet ) {
        return SUCCESS;
    }
    event error_t WmtpCoreMonitor.DroppingPacket( WmtpQueueElement_t *Packet ) {
        checkCongestion();
        return SUCCESS;
    }
    event error_t WmtpCoreMonitor.ReceivedWmtpMsg() {
        return SUCCESS;
    }
    event error_t WmtpCoreMonitor.SendingWmtpMsg() {
        return SUCCESS;
    }
    event error_t WmtpCoreMonitor.SentWmtpMsg() {
        return SUCCESS;
    }
//#endif // (TEST_PERFORMANCE == 1)   	
}
