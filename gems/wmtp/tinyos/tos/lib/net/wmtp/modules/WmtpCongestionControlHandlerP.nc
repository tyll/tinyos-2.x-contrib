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
 * WMTP Congestion Control handler.
 *
 * This component implements the congestion control feature. This features uses local management data to
 * announce the nodes congestion status then uses a traffic shaper to halts packet forwarding towards
 * congested nodes.
 *
 * @author Luis D. Pedrosa <luis.pedrosa@tagus.ist.utl.pt>
 * @author Hugo Freire <hugo.freire@ist.utl.pt> (port to TinyOS 2.x)
**/

#include "Wmtp.h"

#define CONGESTION_AVAILABILITY_MIN_THRESHOLD_PERCENTAGE 50
#define CONGESTION_AVAILABILITY_MAX_THRESHOLD_PERCENTAGE 70
#define CONGESTED_NEIGHBOR_TABLE_SIZE 5

module WmtpCongestionControlHandlerP {
    provides {
        interface Init;
        interface StdControl;
        interface WmtpFeatureConfigurationHandler;
    }
    uses {
        interface WmtpLocalManagementDataHandler;
        interface WmtpTrafficShaper;
        interface WmtpCoreMonitor;
        //interface Time;
        //interface TimeUtil;
        interface LocalTime<TMilli>;

        interface Queue<WmtpConnectionSpecification_t *> as OpenConnectionsQueue;
        interface Queue<WmtpQueueElement_t *> as CoreQueue;
    }
} implementation {
    WmtpCongCtrlLocalPart_t CongCtrlLocalPart;
    uint8_t PreviouslyCongested;
    uint8_t ProcessingLocalConnections;
    struct {
        uint16_t address;
        uint32_t timestamp;
    } congestedNeighborTable[CONGESTED_NEIGHBOR_TABLE_SIZE];


    /**
     * Initializes the module.
    **/

    command error_t Init.init() {
        unsigned char i;

        CongCtrlLocalPart.Reserved = 0;
        CongCtrlLocalPart.CNBit = 0;

        PreviouslyCongested = FALSE;
        ProcessingLocalConnections = FALSE;

        for ( i = 0; i < CONGESTED_NEIGHBOR_TABLE_SIZE; i++ ) {
            congestedNeighborTable[i].address = AM_BROADCAST_ADDR;
            congestedNeighborTable[i].timestamp = call LocalTime.get();
        }

        return SUCCESS;
    }


    command error_t StdControl.start() {
        call WmtpLocalManagementDataHandler.GenerateHeader( &CongCtrlLocalPart, sizeof( WmtpCongCtrlLocalPart_t ), FALSE );

        return SUCCESS;
    }


    command error_t StdControl.stop() {
        call WmtpLocalManagementDataHandler.GenerateHeader( NULL, 0, FALSE );

        return SUCCESS;
    }


    command error_t WmtpFeatureConfigurationHandler.InitializeConfiguration( WmtpConnectionSpecification_t *ConnectionSpecification ) {
        ConnectionSpecification->FeatureSpecification.CongestionControl.Active = FALSE;

        return SUCCESS;
    }


    command error_t WmtpFeatureConfigurationHandler.GenerateConfigurationData( WmtpConnectionSpecification_t *ConnectionSpecification, void *ConfigurationData, uint8_t *ConfigurationDataSize ) {
        if ( ConnectionSpecification &&
                ConnectionSpecification->FeatureSpecification.CongestionControl.Active ) {
            *ConfigurationDataSize = 0;

            return SUCCESS;
        } else {
            return FAIL;
        }
    }


    command error_t WmtpFeatureConfigurationHandler.HandleConfigurationData( void *ConfigurationData, uint8_t *ConfigurationDataSize, WmtpConnectionSpecification_t *ConnectionSpecification ) {
        ConnectionSpecification->FeatureSpecification.CongestionControl.Active = TRUE;

        *ConfigurationDataSize = 0;

        return SUCCESS;
    }


    command error_t WmtpFeatureConfigurationHandler.GetConfigurationDataSize( void *ConfigurationData, uint8_t *ConfigurationDataSize ) {
        *ConfigurationDataSize = 0;

        return SUCCESS;
    }


    uint8_t isLocalNodeCongested() {
        if ( PreviouslyCongested ) {
            if ( call WmtpCoreMonitor.GetCoreQueueAvailability() > (((long) call WmtpCoreMonitor.GetCoreQueueMaxSize()) * CONGESTION_AVAILABILITY_MAX_THRESHOLD_PERCENTAGE / 100) ) {
                dbg( "WMTP", "WmtpCongestionControlHandlerP: Checking current node congestion status (%d / %d, Previous Congested = TRUE -> NOT CONGESTED).\n", call WmtpCoreMonitor.GetCoreQueueAvailability(), call WmtpCoreMonitor.GetCoreQueueMaxSize() );
                PreviouslyCongested = FALSE;
                return FALSE;
            } else {
                dbg( "WMTP", "WmtpCongestionControlHandlerP: Checking current node congestion status (%d / %d, Previous Congested = TRUE -> CONGESTED).\n", call WmtpCoreMonitor.GetCoreQueueAvailability(), call WmtpCoreMonitor.GetCoreQueueMaxSize() );
                return TRUE;
            }
        } else {
            if ( call WmtpCoreMonitor.GetCoreQueueAvailability() <= (((long) call WmtpCoreMonitor.GetCoreQueueMaxSize()) * CONGESTION_AVAILABILITY_MIN_THRESHOLD_PERCENTAGE / 100) ) {
                dbg( "WMTP", "WmtpCongestionControlHandlerP: Checking current node congestion status (%d / %d, Previous Congested = FALSE -> CONGESTED).\n", call WmtpCoreMonitor.GetCoreQueueAvailability(), call WmtpCoreMonitor.GetCoreQueueMaxSize() );
                PreviouslyCongested = TRUE;
                return TRUE;
            } else {
                dbg( "WMTP", "WmtpCongestionControlHandlerP: Checking current node congestion status (%d / %d, Previous Congested = FALSE -> NOT CONGESTED).\n", call WmtpCoreMonitor.GetCoreQueueAvailability(), call WmtpCoreMonitor.GetCoreQueueMaxSize() );
                return FALSE;
            }
        }
    }


    uint8_t isNeighborCongested( uint16_t address ) {
        unsigned char i;

        for ( i = 0; i < CONGESTED_NEIGHBOR_TABLE_SIZE; i++ )
            if ( congestedNeighborTable[i].address == address )
                return TRUE;

        return FALSE;
    }


    void setNeighborCongestionState( uint16_t address, uint8_t congested ) {
        unsigned char i, oldestNeighbor = 0;
        uint32_t curTime = call LocalTime.get();

        if ( congested ) {
            // Iterate through the neighbor table.
            for ( i = 0; i < CONGESTED_NEIGHBOR_TABLE_SIZE; i++ ) {
                // Check if we've found the neighbor.
                if ( congestedNeighborTable[i].address == address ) {
                    congestedNeighborTable[i].timestamp = curTime;
                    return;
                }
                // Check if we've found an empty position.
                if ( congestedNeighborTable[i].address == AM_BROADCAST_ADDR ) {
                    congestedNeighborTable[i].address = address;
                    congestedNeighborTable[i].timestamp = curTime;
                    return;
                }
                // Find the oldest, least recently updated neighbor.
                if ( congestedNeighborTable[i].timestamp < congestedNeighborTable[oldestNeighbor].timestamp )
                    oldestNeighbor = i;
            }

            // Neighbor not found, overwriting oldest neighbor.
            congestedNeighborTable[oldestNeighbor].address = address;
            congestedNeighborTable[oldestNeighbor].timestamp = curTime;
        } else {
            // Iterate through the neighbor table.
            for ( i = 0; i < CONGESTED_NEIGHBOR_TABLE_SIZE; i++ ) {
                // Check if we've found the neighbor.
                if ( congestedNeighborTable[i].address == address ) {
                    // Vacate the position.
                    congestedNeighborTable[i].address = AM_BROADCAST_ADDR;
                    return;
                }
            }
        }
    }


    void generateLocalManagementData() {
        uint8_t localNodeCongested = isLocalNodeCongested();
        uint8_t sendNow = (localNodeCongested && CongCtrlLocalPart.CNBit == 0) ? TRUE : FALSE;

        call WmtpLocalManagementDataHandler.GenerateHeader( NULL, 0, FALSE );
        CongCtrlLocalPart.Reserved = 0;
        CongCtrlLocalPart.CNBit = localNodeCongested ? 1 : 0;
        call WmtpLocalManagementDataHandler.GenerateHeader( &CongCtrlLocalPart, sizeof( WmtpCongCtrlLocalPart_t ), sendNow );
    }


    event error_t WmtpLocalManagementDataHandler.HeaderBroadcasted() {
        return SUCCESS;
    }


    event error_t WmtpLocalManagementDataHandler.HandleHeader( uint16_t SourceAddress, void *HeaderData, uint8_t *HeaderDataSize ) {
        WmtpCongCtrlLocalPart_t *rcvdCongCtrlLocalPart = HeaderData;
        WmtpQueueElement_t *i;
        uint8_t e = 0;

        dbg( "WMTP", "WmtpCongestionControlHandlerP: Neighbor %d is %s.\n", SourceAddress, (rcvdCongCtrlLocalPart->CNBit != 0) ? "congested" : "not congested" );
        setNeighborCongestionState( SourceAddress, (rcvdCongCtrlLocalPart->CNBit != 0) ? TRUE : FALSE );

        // Iterate through the core queue.

        if ( ! call CoreQueue.empty() ) {
            do {
                i = call CoreQueue.element( e++ );
                // Check if the packet has congestion control and has the source node as its destination.
                if ( i->ConnectionSpecification != NULL &&
                        i->ConnectionSpecification->FeatureSpecification.CongestionControl.Active &&
                        i->NextHop == SourceAddress ) {
                    if ( rcvdCongCtrlLocalPart->CNBit == 0 )
                        call WmtpTrafficShaper.StartPacket( i );
                    else
                        call WmtpTrafficShaper.StopPacket( i );
                }
            } while ( e < call CoreQueue.size() );
        }

        *HeaderDataSize = sizeof( WmtpCongCtrlLocalPart_t );
        return SUCCESS;
    }


    void processLocalConnections() {
        WmtpConnectionSpecification_t *i;
        uint8_t e = 0;

        if ( ProcessingLocalConnections )
            return;
        ProcessingLocalConnections = TRUE;

        // Iterate through all open connections.

        if ( ! call OpenConnectionsQueue.empty() ) {
            do {
                i = call OpenConnectionsQueue.element( e++ );
                // Check if the connection has congestion control and is local.
                if ( i->FeatureSpecification.CongestionControl.Active &&
                        i->IsLocal ) {
                    if ( isLocalNodeCongested() )
                        call WmtpTrafficShaper.StopConnection( i );
                    else
                        call WmtpTrafficShaper.StartConnection( i );
                }

            } while ( e < call OpenConnectionsQueue.size() );
        }

        ProcessingLocalConnections = FALSE;
    }


    event error_t WmtpTrafficShaper.NewPacket( WmtpQueueElement_t *Packet ) {
        // Check if the packet has congestion control and if its next hop is congested.
        if ( Packet != NULL &&
                Packet->ConnectionSpecification != NULL &&
                Packet->ConnectionSpecification->FeatureSpecification.CongestionControl.Active &&
                isNeighborCongested( Packet->NextHop ) )
            call WmtpTrafficShaper.StopPacket( Packet );

        generateLocalManagementData();

        processLocalConnections();

        return SUCCESS;
    }


    event error_t WmtpTrafficShaper.SendingPacket( WmtpQueueElement_t *Packet ) {
        return SUCCESS;
    }


    event error_t WmtpTrafficShaper.DroppingPacket( WmtpQueueElement_t *Packet ) {
        generateLocalManagementData();

        processLocalConnections();

        return SUCCESS;
    }


    event error_t WmtpTrafficShaper.ConnectionOpened( WmtpConnectionSpecification_t *ConnectionSpecification ) {
        return SUCCESS;
    }
    event error_t WmtpTrafficShaper.ConnectionClosed( WmtpConnectionSpecification_t *ConnectionSpecification ) {
        return SUCCESS;
    }
    event error_t WmtpTrafficShaper.ConnectionReconfigured( WmtpConnectionSpecification_t *ConnectionSpecification ) {
        return SUCCESS;
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
        return SUCCESS;
    }
    event error_t WmtpCoreMonitor.DeliveringPacket( WmtpQueueElement_t *Packet ) {
        return SUCCESS;
    }
    event error_t WmtpCoreMonitor.SendingPacket( WmtpQueueElement_t *Packet ) {
        return SUCCESS;
    }
    event error_t WmtpCoreMonitor.DroppingPacket( WmtpQueueElement_t *Packet ) {
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
}
