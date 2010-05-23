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
 * WMTP queue availability traffic shaper.
 *
 * This component implements a simple queue availability traffic shaper. This
 * traffic shaper ensures that the ClearToSend event is only signalled if there
 * is queue memory available for a new packet.
 *
 * @author Luis D. Pedrosa <luis.pedrosa@tagus.ist.utl.pt>
 * @author Hugo Freire <hugo.freire@ist.utl.pt> (port to TinyOS 2.x)
**/

#include "Wmtp.h"

module WmtpQueueAvailabilityShaperP {
    provides {
        interface Init;
        interface WmtpFeatureConfigurationHandler;
    }
    uses {
        interface WmtpTrafficShaper;
        interface WmtpCoreMonitor;

        interface Queue<WmtpConnectionSpecification_t *> as OpenConnectionsQueue;
    }
} implementation {
    uint8_t ProcessingLocalConnections;


    /**
     * Initializes the module.
    **/

    command error_t Init.init() {
        ProcessingLocalConnections = FALSE;

        return SUCCESS;
    }


    command error_t WmtpFeatureConfigurationHandler.InitializeConfiguration( WmtpConnectionSpecification_t *ConnectionSpecification ) {
        ConnectionSpecification->FeatureSpecification.QueueAvailabilityShaper.Active = FALSE;

        return SUCCESS;
    }


    command error_t WmtpFeatureConfigurationHandler.GenerateConfigurationData( WmtpConnectionSpecification_t *ConnectionSpecification, void *ConfigurationData, uint8_t *ConfigurationDataSize ) {
        return FAIL;
    }


    command error_t WmtpFeatureConfigurationHandler.HandleConfigurationData( void *ConfigurationData, uint8_t *ConfigurationDataSize, WmtpConnectionSpecification_t *ConnectionSpecification ) {
        return FAIL;
    }


    command error_t WmtpFeatureConfigurationHandler.GetConfigurationDataSize( void *ConfigurationData, uint8_t *ConfigurationDataSize ) {
        return FAIL;
    }


    uint8_t isQueueAvailable() {
        dbg( "WMTP",
             "WmtpQueueAvailabilityShaperP: Checking queue availability (%d -> %s).\n",
             call WmtpCoreMonitor.GetCoreQueueAvailability(),
             (call WmtpCoreMonitor.GetCoreQueueAvailability() > 0) ? "OK" : "FULL" );

        return (call WmtpCoreMonitor.GetCoreQueueAvailability() > 0) ? TRUE : FALSE;
    }


    void processLocalConnections() {
        WmtpConnectionSpecification_t *i;
        uint8_t newState, oldState;
        uint8_t e = 0;

        if ( ProcessingLocalConnections )
            return;
        ProcessingLocalConnections = TRUE;

        // Iterate through all open connections.

        if ( ! call OpenConnectionsQueue.empty() ) {
            oldState = newState = isQueueAvailable();
            do {
                i = call OpenConnectionsQueue.element( e++ );
                while ( TRUE ) {
                    // Check if the connection uses this shaper and is local.
                    if ( i->FeatureSpecification.QueueAvailabilityShaper.Active &&
                            i->IsLocal ) {
                        if ( newState )
                            call WmtpTrafficShaper.StartConnection( i );
                        else
                            call WmtpTrafficShaper.StopConnection( i );
                        newState = isQueueAvailable();
                        if ( oldState != newState ) {
                            oldState = newState;
                            e = 0;
                            continue;
                        }
                    }
                    break;
                }
            } while ( e < call OpenConnectionsQueue.size() );
        }

        ProcessingLocalConnections = FALSE;
    }


    event error_t WmtpTrafficShaper.NewPacket( WmtpQueueElement_t *Packet ) {
        processLocalConnections();

        return SUCCESS;
    }


    event error_t WmtpTrafficShaper.SendingPacket( WmtpQueueElement_t *Packet ) {
        return SUCCESS;
    }


    event error_t WmtpTrafficShaper.DroppingPacket( WmtpQueueElement_t *Packet ) {
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
