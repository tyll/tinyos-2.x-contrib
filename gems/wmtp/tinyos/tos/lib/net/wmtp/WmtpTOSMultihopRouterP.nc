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
 * WMTP TinyOS Multihop router.
 *
 * This component implements the TinyOS multihop router, a simple connectionless
 * router based on TinyOS's native multihop routing.
 *
 * @author Luis D. Pedrosa <luis.pedrosa@tagus.ist.utl.pt>
 * @author Hugo Freire <hugo.freire@ist.utl.pt> (port to TinyOS 2.x)
**/

#include "Wmtp.h"

module WmtpTOSMultihopRouterP {
    provides {
        interface StdControl;
        interface WmtpMultihopRouter;
    }
    uses {
        interface WmtpConnectionEstablishmentHandler;
        interface StdControl as MultiHopRouterControl;
        interface RouteControl;
    }
} implementation {
    uint8_t maintenanceProcessPosted = FALSE;
    WmtpConnectionSpecification_t *incomingConnectionSpecification;
    LinkedLists_LinkedList_t pendingConnectionRequests;


    /**
     * Initializes the module.
    **/

    command error_t StdControl.init() {
        LinkedLists_init( &pendingConnectionRequests );

        if ( call WmtpConnectionEstablishmentHandler.GetNewConnectionSpecification( &incomingConnectionSpecification ) == SUCCESS ) {
            incomingConnectionSpecification->PathSpecification.PathType = WMTP_PATHTYPE_TOSMULTIHOP;
            incomingConnectionSpecification->RouterSpecification.RouterType = WMTP_ROUTERTYPE_TOSMULTIHOP;
            incomingConnectionSpecification->IsConnectionOriented = FALSE;

            return call MultiHopRouterControl.init();
        } else {
            incomingConnectionSpecification = NULL;

            return FAIL;
        }
    }


    command error_t StdControl.start() {
        return call MultiHopRouterControl.start();
    }


    command error_t StdControl.stop() {
        return call MultiHopRouterControl.stop();
    }


    task void maintenanceProcess() {
        WmtpConnectionSpecification_t *i;

        // Iterate through all pending connection requests.
        i = LinkedLists_removeFirstElement( &pendingConnectionRequests );
        while ( i != NULL ) {
            // Open the local connection.
            if ( call WmtpConnectionEstablishmentHandler.AddLocalConnection( i ) != SUCCESS )
                call WmtpConnectionEstablishmentHandler.DestroyConnectionSpecification( i );

            i = LinkedLists_removeFirstElement( &pendingConnectionRequests );
        }

        maintenanceProcessPosted = FALSE;
    }


    event error_t WmtpConnectionEstablishmentHandler.OpenConnection( WmtpConnectionSpecification_t *ConnectionSpecification ) {
        // Specify the router type.
        ConnectionSpecification->RouterSpecification.RouterType = WMTP_ROUTERTYPE_TOSMULTIHOP;
        ConnectionSpecification->IsConnectionOriented = FALSE;
        // Add the connection request to the pending linked list.
        LinkedLists_insertElementBeginning( &pendingConnectionRequests, &(ConnectionSpecification->element) );

        // Post the maintenance process.
        if ( ! maintenanceProcessPosted )
            if ( post maintenanceProcess() == SUCCESS )
                maintenanceProcessPosted = TRUE;

        return SUCCESS;
    }


    event error_t WmtpConnectionEstablishmentHandler.ConnectionClosed( WmtpConnectionSpecification_t *ConnectionSpecification ) {
        return SUCCESS;
    }


    command error_t WmtpMultihopRouter.GetNextHop( uint16_t SourceAddress, void *RoutingData, uint8_t *RoutingDataSize, uint16_t *Address, WmtpConnectionSpecification_t **ConnectionSpecification ) {
        uint16_t parentAddr = call RouteControl.getParent();

        *RoutingDataSize = 0;
        // No need to generate routing header if packet locally generated.

        if ( parentAddr == TOS_UART_ADDR ) { // Check if we are the receiving node.
            WmtpServiceSpecification_t *i, *firstSS;

            // Get registered services.
            firstSS = i = LinkedLists_getFirstElement( call WmtpConnectionEstablishmentHandler.GetRegisteredServices() );

            // Check if there were any registered services and that a connection
            // specification object was reserved for local delivery.
            if ( i != NULL && incomingConnectionSpecification != NULL ) {
                // Iterate through all services.
                do {
                    // Check if we found a connectionless packet sink.
                    if ( i->Connectionless &&
                            i->ServiceType == WMTP_SERVICETYPE_PACKETSINK ) {
                        // Get the connection parameters.
                        *Address = TOS_NODE_ID;
                        *ConnectionSpecification = incomingConnectionSpecification;
                        incomingConnectionSpecification->ApplicationID = i->ApplicationID;

                        return SUCCESS;
                    }

                    i = LinkedLists_getNextElement( &(i->element) );
                } while ( i != firstSS );

                return FAIL;
            } else { // No registered services or no connection specification.
                return FAIL;
            }
        } else if ( parentAddr == AM_BROADCAST_ADDR ) { // Check if route is invalid.
            return FAIL;
        } else { // Forwarding node.
            *Address = parentAddr;
            if ( SourceAddress != TOS_NODE_ID )
                *ConnectionSpecification = NULL;

            return SUCCESS;
        }
    }
}
