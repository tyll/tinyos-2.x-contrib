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
 * WMTP Flow control handler.
 *
 * This component implements the flow control feature feature. This features is a simple traffic shaper
 * that sets a minimum packet generation period on the other end of the connection.
 *
 * @author Luis D. Pedrosa <luis.pedrosa@tagus.ist.utl.pt>
 * @author Hugo Freire <hugo.freire@ist.utl.pt> (port to TinyOS 2.x)
**/

#include "Wmtp.h"

module WmtpFlowControlHandlerP {
    provides {
        interface Init;
        interface WmtpFeatureConfigurationHandler;
    }
    uses {
        interface WmtpTrafficShaper;
        interface WmtpConnectionScratchPadHook;
        //interface Time;
        //interface TimeUtil;
        //interface AbsoluteTimer;
        interface Timer<TMilli>;

        interface Queue<WmtpConnectionSpecification_t *> as OpenConnectionsQueue;
    }
} implementation {
    static uint8_t processingConnections;


    /**
     * Initializes the module.
    **/

    command error_t Init.init() {
        processingConnections = FALSE;

        return SUCCESS;
    }


    command error_t WmtpFeatureConfigurationHandler.InitializeConfiguration( WmtpConnectionSpecification_t *ConnectionSpecification ) {
        ConnectionSpecification->FeatureSpecification.FlowControl.LocalPeriod = 0;
        ConnectionSpecification->FeatureSpecification.FlowControl.RemotePeriod = 0;

        return SUCCESS;
    }


    command error_t WmtpFeatureConfigurationHandler.GenerateConfigurationData( WmtpConnectionSpecification_t *ConnectionSpecification, void *ConfigurationData, uint8_t *ConfigurationDataSize ) {
        if ( ConnectionSpecification &&
                ConnectionSpecification->FeatureSpecification.FlowControl.RemotePeriod > 0 ) {
            WmtpFlowCtrlConfigurationPart_t *FlowCtrlConfigurationPart = ConfigurationData;

            FlowCtrlConfigurationPart->Period = ConnectionSpecification->FeatureSpecification.FlowControl.RemotePeriod;

            *ConfigurationDataSize = sizeof( WmtpFlowCtrlConfigurationPart_t );

            return SUCCESS;
        } else {
            return FAIL;
        }
    }


    command error_t WmtpFeatureConfigurationHandler.HandleConfigurationData( void *ConfigurationData, uint8_t *ConfigurationDataSize, WmtpConnectionSpecification_t *ConnectionSpecification ) {
        if ( ConnectionSpecification->IsLocal ) {
            WmtpFlowCtrlConfigurationPart_t *FlowCtrlConfigurationPart = ConfigurationData;

            ConnectionSpecification->FeatureSpecification.FlowControl.LocalPeriod = FlowCtrlConfigurationPart->Period;
        } else {
            ConnectionSpecification->FeatureSpecification.FlowControl.LocalPeriod = 0;
        }

        *ConfigurationDataSize = sizeof( WmtpFlowCtrlConfigurationPart_t );

        return SUCCESS;
    }


    command error_t WmtpFeatureConfigurationHandler.GetConfigurationDataSize( void *ConfigurationData, uint8_t *ConfigurationDataSize ) {
        *ConfigurationDataSize = sizeof( WmtpFlowCtrlConfigurationPart_t );

        return SUCCESS;
    }


    void processConnections() {
        WmtpConnectionSpecification_t *i;
        uint32_t curTime = call Timer.getNow();
        uint32_t *nextTimer = NULL;
        uint8_t state;
        uint8_t e = 0;

        processingConnections = TRUE;

        // Iterate through all open connections.

        if ( ! call OpenConnectionsQueue.empty() ) {
            do {
                i = call OpenConnectionsQueue.element( e++ );
                // Check if the connection has flow control and is inactive and has an expired wake up timer.
                if ( i->FeatureSpecification.FlowControl.LocalPeriod > 0 &&
                        call WmtpTrafficShaper.GetConnectionState( i, &state ) == SUCCESS &&
                        state == FALSE &&
                        curTime >= (call WmtpConnectionScratchPadHook.GetConnectionScratchPad( i ))->FlowControl.WakeUpTime ) {
                    // Restart the connection.
                    dbg( "WMTP", "WmtpFlowControlHandlerP: Connection wake up timer expired. Starting connection.\n" );
                    call WmtpTrafficShaper.StartConnection( i );
                }

            } while ( e < call OpenConnectionsQueue.size() );
        }

        // Cancel any previous timer.
        call Timer.stop();

        // Iterate through all open connections.

        if ( ! call OpenConnectionsQueue.empty() ) {
            e = 0;
            do {
                i = call OpenConnectionsQueue.element( e++ );
                // Check if the connection has flow control and is inactive and has a pending wake up timer.
                if ( i->FeatureSpecification.FlowControl.LocalPeriod > 0 &&
                        call WmtpTrafficShaper.GetConnectionState( i, &state ) == SUCCESS &&
                        state == FALSE &&
                        curTime < (call WmtpConnectionScratchPadHook.GetConnectionScratchPad( i ))->FlowControl.WakeUpTime ) {
                    // Check if the next timer has already been defined.
                    if ( nextTimer == NULL ) {
                        // Define it.
                        nextTimer = &((call WmtpConnectionScratchPadHook.GetConnectionScratchPad( i ))->FlowControl.WakeUpTime);
                    } else {
                        // Check if we've found a new timer that's earlier.
                        if ( *nextTimer > (call WmtpConnectionScratchPadHook.GetConnectionScratchPad( i ))->Throttling.WakeUpTime )
                            nextTimer = &((call WmtpConnectionScratchPadHook.GetConnectionScratchPad( i ))->FlowControl.WakeUpTime);
                    }
                }

            } while ( e < call OpenConnectionsQueue.size() );

            // Check if a next timer was found.
            if ( nextTimer != NULL )
                call Timer.startOneShot( *nextTimer - call Timer.getNow() );
            else
                dbg( "WMTP", "WmtpFlowControlHandlerP: No wake up timers left.\n" );
        }

        processingConnections = FALSE;
    }


    event error_t WmtpTrafficShaper.NewPacket( WmtpQueueElement_t *Packet ) {
        if ( Packet &&
                Packet->ConnectionSpecification &&
                Packet->ConnectionSpecification->FeatureSpecification.FlowControl.LocalPeriod > 0 ) {
            dbg( "WMTP", "WmtpFlowControlHandlerP: Generated new packet on connection with flow control. Reseting connection timer.\n" );

            call WmtpTrafficShaper.StopConnection( Packet->ConnectionSpecification );

            (call WmtpConnectionScratchPadHook.GetConnectionScratchPad( Packet->ConnectionSpecification ))->FlowControl.WakeUpTime = call Timer.getNow() + Packet->ConnectionSpecification->FeatureSpecification.FlowControl.LocalPeriod;

            if ( ! processingConnections )
                processConnections();

            return SUCCESS;
        } else {
            return FAIL;
        }
    }


    event error_t WmtpTrafficShaper.SendingPacket( WmtpQueueElement_t *Packet ) {
        return SUCCESS;
    }
    event error_t WmtpTrafficShaper.DroppingPacket( WmtpQueueElement_t *Packet ) {
        return SUCCESS;
    }
    event error_t WmtpTrafficShaper.ConnectionClosed( WmtpConnectionSpecification_t *ConnectionSpecification ) {
        return SUCCESS;
    }
    event error_t WmtpTrafficShaper.ConnectionReconfigured( WmtpConnectionSpecification_t *ConnectionSpecification ) {
        return SUCCESS;
    }


    event error_t WmtpTrafficShaper.ConnectionOpened( WmtpConnectionSpecification_t *ConnectionSpecification ) {
        if ( ConnectionSpecification &&
                ConnectionSpecification->FeatureSpecification.FlowControl.LocalPeriod > 0 ) {
            dbg( "WMTP", "WmtpFlowControlHandlerP: Got new connection with flow control. Initializing connection state.\n" );

            (call WmtpConnectionScratchPadHook.GetConnectionScratchPad( ConnectionSpecification ))->FlowControl.WakeUpTime = call Timer.getNow();

            return SUCCESS;
        } else {
            return FAIL;
        }
    }


    event void Timer.fired() {
        dbg( "WMTP", "WmtpFlowControlHandlerP: Timer fired. Processing connections.\n" );

        processConnections();
    }
}
