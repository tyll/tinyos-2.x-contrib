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
 * WMTP Decrement Address Multihop router.
 *
 * This component implements the Decrement Address multihop router, a simple
 * connectionless router used for debugging.
 *
 * @author Luis D. Pedrosa <luis.pedrosa@tagus.ist.utl.pt>
 * @author Hugo Freire <hugo.freire@ist.utl.pt> (port to TinyOS 2.x)
**/

#include "Wmtp.h"

module WmtpDecrementAddressRouterP {
    provides {
        interface Init;
        interface WmtpMultihopRouter;
    }
    uses {
        interface WmtpConnectionEstablishmentHandler;

        interface Queue<WmtpServiceSpecification_t *> as RegisteredServicesQueue;
        interface Queue<WmtpConnectionSpecification_t *> as PendingConnectionRequestsQueue;
    }
} implementation {
    uint8_t maintenanceProcessPosted = FALSE;
    WmtpConnectionSpecification_t *incomingConnectionSpecification;


    /**
     * Initializes the module.
    **/

    command error_t Init.init() {

        if ( call WmtpConnectionEstablishmentHandler.GetNewConnectionSpecification( &incomingConnectionSpecification ) == SUCCESS ) {
            incomingConnectionSpecification->PathSpecification.PathType = WMTP_PATHTYPE_DECREMENTADDRESS;
            incomingConnectionSpecification->RouterSpecification.RouterType = WMTP_ROUTERTYPE_DECREMENTADDRESSROUTER;
            incomingConnectionSpecification->IsConnectionOriented = FALSE;

            return SUCCESS;
        } else {
            incomingConnectionSpecification = NULL;

            return FAIL;
        }
    }

    task void maintenanceProcess() {
        WmtpConnectionSpecification_t *i;

        // Iterate through all pending connection requests.

        while ( ! call PendingConnectionRequestsQueue.empty()) {
            //i = LinkedLists_removeFirstElement( &pendingConnectionRequests );
            i = call PendingConnectionRequestsQueue.dequeue();
            // Open the local connection.
            if ( call WmtpConnectionEstablishmentHandler.AddLocalConnection( i ) != SUCCESS )
                call WmtpConnectionEstablishmentHandler.DestroyConnectionSpecification( i );
        }

        maintenanceProcessPosted = FALSE;
    }


    event error_t WmtpConnectionEstablishmentHandler.OpenConnection( WmtpConnectionSpecification_t *ConnectionSpecification ) {
        // Specify the router type.
        ConnectionSpecification->RouterSpecification.RouterType = WMTP_ROUTERTYPE_DECREMENTADDRESSROUTER;
        ConnectionSpecification->IsConnectionOriented = FALSE;
        // Add the connection request to the pending linked list.
        //LinkedLists_insertElementBeginning( &pendingConnectionRequests, &(ConnectionSpecification->element) );
        call PendingConnectionRequestsQueue.enqueue( ConnectionSpecification );

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
        *RoutingDataSize = 0;
        // No need to generate routing header if packet locally generated.

        // Check if we are the receiving node.
        if ( TOS_NODE_ID == 0 ) { // Yes.
            WmtpServiceSpecification_t *i;
            uint8_t e = 0;

            // Get registered services.

            // Check if there were any registered services and that a connection
            // specification object was reserved for local delivery.
            if ( ! call RegisteredServicesQueue.empty() && incomingConnectionSpecification != NULL ) {
                // Iterate through all services.
                do {
                    i = call RegisteredServicesQueue.element( e++ );
                    // Check if we found a connectionless packet sink.
                    if ( i->Connectionless &&
                            i->ServiceType == WMTP_SERVICETYPE_PACKETSINK ) {
                        // Get the connection parameters.
                        *Address = TOS_NODE_ID;
                        *ConnectionSpecification = incomingConnectionSpecification;
                        incomingConnectionSpecification->ApplicationID = i->ApplicationID;

                        return SUCCESS;
                    }

                } while ( e < call RegisteredServicesQueue.size() );

                return FAIL;
            } else { // No registered services or no connection specification.
                return FAIL;
            }
        } else { // Not receiving node.
            *Address = TOS_NODE_ID - 1;
            if ( SourceAddress != TOS_NODE_ID )
                *ConnectionSpecification = NULL;

            return SUCCESS;
        }
    }
}
