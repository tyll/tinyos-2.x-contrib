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
 * WMTP Source Routed Connection Establishment Handler.
 *
 * This component implements the Source Routed connection
 * establishment logic.
 *
 * @author Luis D. Pedrosa <luis.pedrosa@tagus.ist.utl.pt>
 * @author Hugo Freire <hugo.freire@ist.utl.pt> (port to TinyOS 2.x)
**/

#include "Wmtp.h"

#define CONNECTION_ACTIVATION_TIMEOUT 5000u
#define CONNECTION_USAGE_TIMEOUT 60000u

module WmtpSourceRoutedConnectionEstablishmentHandlerP {
    uses {
        interface WmtpConnectionEstablishmentHandler;
        interface WmtpTagRouter;
        interface WmtpLocalManagementDataHandler;

        interface Queue<WmtpConnectionSpecification_t *> as PendingConnectionRequestsQueue;
    }
} implementation {
    uint8_t SrcRoutedConnLocalPartBuffer[sizeof( WmtpSrcRoutedConnLocalPart_t )
    + WMTP_FEATURECONFIG_MAXSIZE
    + WMTP_SOURCEROUTEDCONNECTION_MAXHOPS * sizeof( uint16_t )];
    uint8_t maintenanceProcessPosted = FALSE;


    task void maintenanceProcess() {
        WmtpSrcRoutedConnLocalPart_t *SrcRoutedConnLocalPart = (WmtpSrcRoutedConnLocalPart_t *) &(SrcRoutedConnLocalPartBuffer[0]);
        WmtpConnectionSpecification_t *ConnectionSpecification;

        // Process a pending connection request.
        //ConnectionSpecification = LinkedLists_removeFirstElement( &pendingConnectionRequests );
        ConnectionSpecification = call PendingConnectionRequestsQueue.dequeue();
        if ( ConnectionSpecification != NULL ) {
            uint8_t ConfigurationDataSize = 0, ServiceSpecificationDataSize = 0, i;
            uint16_t reserveDelay = 0;

            dbg( "WMTP", "WmtpSourceRoutedConnectionEstablishmentHandlerP: Opening connection for application %d.\n", ConnectionSpecification->ApplicationID );

            // Calculate QoS delay to reserve.
            if ( ConnectionSpecification->QoSSpecification.MaxDelay > 0 ) {
                if ( call WmtpConnectionEstablishmentHandler.GetQoSShortestDelay( 0, &reserveDelay ) != SUCCESS )
                    reserveDelay = 0;
            } else if ( ConnectionSpecification->QoSSpecification.MaxPeriod > 0 ) {
                if ( call WmtpConnectionEstablishmentHandler.GetQoSShortestDelay( ConnectionSpecification->QoSSpecification.PreferredPeriod, &reserveDelay ) != SUCCESS )
                    reserveDelay = 0;
            }
            if ( ConnectionSpecification->QoSSpecification.MaxPeriod > 0 &&
                    ConnectionSpecification->QoSSpecification.MaxPeriod < reserveDelay )
                reserveDelay = ConnectionSpecification->QoSSpecification.MaxPeriod;

            if ( reserveDelay > 0 ) {
                dbg( "WMTP", "WmtpSourceRoutedConnectionEstablishmentHandlerP: QoS reservation delay: %d.\n", reserveDelay );
            }

            call WmtpLocalManagementDataHandler.GenerateHeader( NULL, 0, FALSE );
            SrcRoutedConnLocalPart->NextHop = ConnectionSpecification->PathSpecification.PathData.SourceRoutedConnection.Hops[0];
            SrcRoutedConnLocalPart->QoSMaxDelay = ConnectionSpecification->QoSSpecification.MaxDelay;
            SrcRoutedConnLocalPart->QoSMaxPeriod = ConnectionSpecification->QoSSpecification.MaxPeriod;
            SrcRoutedConnLocalPart->QoSPreferredPeriod = ConnectionSpecification->QoSSpecification.PreferredPeriod;
            SrcRoutedConnLocalPart->QoSAccumulatedDelay = reserveDelay;
            SrcRoutedConnLocalPart->NumHops = ConnectionSpecification->PathSpecification.PathData.SourceRoutedConnection.NumHops - 1;
            for ( i = 0; i < ConnectionSpecification->PathSpecification.PathData.SourceRoutedConnection.NumHops - 1; i++ )
                SrcRoutedConnLocalPart->Hops[i] = ConnectionSpecification->PathSpecification.PathData.SourceRoutedConnection.Hops[i + 1];

            // Configure connection.
            // Specify the router type.
            ConnectionSpecification->RouterSpecification.RouterType = WMTP_ROUTERTYPE_TAGROUTER;
            ConnectionSpecification->IsConnectionOriented = TRUE;
            ConnectionSpecification->IsLocal = TRUE;
            // Generate tags, configuration data, and service data, add tag association and reserve QoS resources.
            if ( call WmtpTagRouter.GetNewTag( TOS_NODE_ID, &(ConnectionSpecification->RouterSpecification.RouterData.TagRouter.OutgoingTag) ) != SUCCESS ||
                    call WmtpTagRouter.GetNewTag( SrcRoutedConnLocalPart->NextHop, &(SrcRoutedConnLocalPart->NextTag) ) != SUCCESS ||
                    call WmtpConnectionEstablishmentHandler.GenerateConnectionConfiguration( ConnectionSpecification, &(SrcRoutedConnLocalPart->Hops[SrcRoutedConnLocalPart->NumHops]), &ConfigurationDataSize ) != SUCCESS ||
                    call WmtpConnectionEstablishmentHandler.GenerateServiceSpecificationData( &(ConnectionSpecification->PathSpecification.PathData.SourceRoutedConnection.ServiceSpecification), ((uint8_t *) &(SrcRoutedConnLocalPart->Hops[SrcRoutedConnLocalPart->NumHops])) + ConfigurationDataSize, &ServiceSpecificationDataSize ) != SUCCESS ||
                    call WmtpTagRouter.AddTagAssociation( TOS_NODE_ID, ConnectionSpecification->RouterSpecification.RouterData.TagRouter.OutgoingTag, SrcRoutedConnLocalPart->NextHop, SrcRoutedConnLocalPart->NextTag, ConnectionSpecification, CONNECTION_ACTIVATION_TIMEOUT, CONNECTION_USAGE_TIMEOUT ) != SUCCESS ||
                    (reserveDelay == 0 && (SrcRoutedConnLocalPart->QoSMaxDelay > 0 || SrcRoutedConnLocalPart->QoSMaxPeriod > 0)) ||
                    (SrcRoutedConnLocalPart->QoSMaxDelay > 0 && SrcRoutedConnLocalPart->QoSAccumulatedDelay > SrcRoutedConnLocalPart->QoSMaxDelay) ||
                    (reserveDelay > 0 && call WmtpConnectionEstablishmentHandler.ReserveQoSResources( ConnectionSpecification, reserveDelay ) != SUCCESS) ) {
                call WmtpConnectionEstablishmentHandler.FreeQoSResources( ConnectionSpecification );
                call WmtpConnectionEstablishmentHandler.DestroyConnectionSpecification( ConnectionSpecification );

                dbg( "WMTP", "WmtpSourceRoutedConnectionEstablishmentHandlerP: Failed to open connection.\n" );

                post maintenanceProcess();

                return;
            }

            call WmtpLocalManagementDataHandler.GenerateHeader(
                SrcRoutedConnLocalPart,
                sizeof( WmtpSrcRoutedConnLocalPart_t )
                + (ConnectionSpecification->PathSpecification.PathData.SourceRoutedConnection.NumHops - 1) * sizeof( uint16_t )
                + ConfigurationDataSize
                + ServiceSpecificationDataSize,
                TRUE );
        }

        maintenanceProcessPosted = FALSE;
    }


    event error_t WmtpConnectionEstablishmentHandler.OpenConnection( WmtpConnectionSpecification_t *ConnectionSpecification ) {
        if ( ConnectionSpecification->PathSpecification.PathType == WMTP_PATHTYPE_SOURCEROUTEDCONNECTION &&
                ConnectionSpecification->PathSpecification.PathData.SourceRoutedConnection.NumHops > 0 ) {
            // Add the connection request to the pending linked list.
            //LinkedLists_insertElementBeginning( &pendingConnectionRequests, &(ConnectionSpecification->element) );
            call PendingConnectionRequestsQueue.enqueue( ConnectionSpecification );

            // Post the maintenance process.
            if ( ! maintenanceProcessPosted )
                if ( post maintenanceProcess() == SUCCESS )
                    maintenanceProcessPosted = TRUE;

            return SUCCESS;
        } else {
            return FAIL;
        }
    }


    event error_t WmtpConnectionEstablishmentHandler.ConnectionClosed( WmtpConnectionSpecification_t *ConnectionSpecification ) {
        return call WmtpTagRouter.DropTagAssociation( ConnectionSpecification );
    }


    event error_t WmtpTagRouter.TagAssociationActivated( WmtpConnectionSpecification_t *ConnectionSpecification ) {
        if ( ConnectionSpecification->IsLocal ) {
            call WmtpConnectionEstablishmentHandler.AddLocalConnection( ConnectionSpecification );
        } else {
            call WmtpConnectionEstablishmentHandler.AddNonLocalConnection( ConnectionSpecification );
        }

        return SUCCESS;
    }


    event error_t WmtpTagRouter.TagAssociationTimedOut( WmtpConnectionSpecification_t *ConnectionSpecification ) {
        call WmtpConnectionEstablishmentHandler.FreeQoSResources( ConnectionSpecification );
        call WmtpConnectionEstablishmentHandler.DestroyConnectionSpecification( ConnectionSpecification );

        return SUCCESS;
    }


    event error_t WmtpTagRouter.TagAssociationDropped( WmtpConnectionSpecification_t *ConnectionSpecification ) {
        return call WmtpConnectionEstablishmentHandler.CloseConnection( ConnectionSpecification );
    }


    event error_t WmtpLocalManagementDataHandler.HeaderBroadcasted() {
        call WmtpLocalManagementDataHandler.GenerateHeader( NULL, 0, FALSE );

        // Post the maintenance process.
        if ( ! maintenanceProcessPosted )
            if ( post maintenanceProcess() == SUCCESS )
                maintenanceProcessPosted = TRUE;

        return SUCCESS;
    }


    event error_t WmtpLocalManagementDataHandler.HandleHeader( uint16_t SourceAddress, void *HeaderData, uint8_t *HeaderDataSize ) {
        WmtpSrcRoutedConnLocalPart_t *RcvdSrcRoutedConnLocalPart = HeaderData;
        WmtpSrcRoutedConnLocalPart_t *SrcRoutedConnLocalPart = (WmtpSrcRoutedConnLocalPart_t *) &(SrcRoutedConnLocalPartBuffer[0]);
        WmtpConnectionSpecification_t *ConnectionSpecification = NULL;
        uint8_t ConfigurationDataSize = 0, ServiceSpecificationDataSize = 0;

        if ( (RcvdSrcRoutedConnLocalPart->NextHop == TOS_NODE_ID) &&
                (call WmtpConnectionEstablishmentHandler.GetNewConnectionSpecification( &ConnectionSpecification ) == SUCCESS) ) {
            // Specify the connection establishment handler and router type.
            ConnectionSpecification->PathSpecification.PathType = WMTP_PATHTYPE_SOURCEROUTEDCONNECTION;
            ConnectionSpecification->RouterSpecification.RouterType = WMTP_ROUTERTYPE_TAGROUTER;
            ConnectionSpecification->IsConnectionOriented = TRUE;
            if ( RcvdSrcRoutedConnLocalPart->NumHops == 0 ) {
                ConnectionSpecification->IsLocal = TRUE;
            } else {
                ConnectionSpecification->IsLocal = FALSE;
            }

            if ( call WmtpConnectionEstablishmentHandler.ConfigureConnection( &(RcvdSrcRoutedConnLocalPart->Hops[RcvdSrcRoutedConnLocalPart->NumHops]), &ConfigurationDataSize, ConnectionSpecification ) == SUCCESS ) {
                if ( RcvdSrcRoutedConnLocalPart->NumHops == 0 ) {
                    WmtpServiceSpecification_t *ServiceSpecification = NULL;

                    dbg( "WMTP", "WmtpSourceRoutedConnectionEstablishmentHandlerP: Opening new local connection.\n" );

                    // Get the matching service, generate local tag and add the tag association.
                    if ( call WmtpConnectionEstablishmentHandler.GetMatchingService( TRUE, ((uint8_t *) &(RcvdSrcRoutedConnLocalPart->Hops[RcvdSrcRoutedConnLocalPart->NumHops])) + ConfigurationDataSize, &ServiceSpecificationDataSize, &ServiceSpecification ) != SUCCESS ||
                            call WmtpTagRouter.GetNewTag( TOS_NODE_ID, &(ConnectionSpecification->RouterSpecification.RouterData.TagRouter.OutgoingTag) ) != SUCCESS ||
                            call WmtpTagRouter.AddTagAssociation( SourceAddress, RcvdSrcRoutedConnLocalPart->NextTag, TOS_NODE_ID, ConnectionSpecification->RouterSpecification.RouterData.TagRouter.OutgoingTag, ConnectionSpecification, CONNECTION_ACTIVATION_TIMEOUT, CONNECTION_USAGE_TIMEOUT ) != SUCCESS ) {
                        call WmtpConnectionEstablishmentHandler.DestroyConnectionSpecification( ConnectionSpecification );

                        dbg( "WMTP", "WmtpSourceRoutedConnectionEstablishmentHandlerP: Failed to open connection.\n" );
                    } else {
                        ConnectionSpecification->ApplicationID = ServiceSpecification->ApplicationID;

                        dbg( "WMTP", "WmtpSourceRoutedConnectionEstablishmentHandlerP: Sending keep-alive to confirm connection.\n" );

                        call WmtpConnectionEstablishmentHandler.SendKeepAlive( ConnectionSpecification );
                    }
                } else {
                    uint16_t reserveDelay = 0;

                    dbg( "WMTP", "WmtpSourceRoutedConnectionEstablishmentHandlerP: Opening new non-local connection.\n" );

                    // Calculate QoS delay to reserve.
                    if ( RcvdSrcRoutedConnLocalPart->QoSMaxDelay > 0 ) {
                        if ( call WmtpConnectionEstablishmentHandler.GetQoSShortestDelay( 0, &reserveDelay ) != SUCCESS )
                            reserveDelay = 0;
                    } else if ( RcvdSrcRoutedConnLocalPart->QoSMaxPeriod > 0 ) {
                        if ( call WmtpConnectionEstablishmentHandler.GetQoSShortestDelay( RcvdSrcRoutedConnLocalPart->QoSPreferredPeriod, &reserveDelay ) != SUCCESS )
                            reserveDelay = 0;
                    }
                    if ( RcvdSrcRoutedConnLocalPart->QoSMaxPeriod > 0 &&
                            RcvdSrcRoutedConnLocalPart->QoSMaxPeriod < reserveDelay )
                        reserveDelay = RcvdSrcRoutedConnLocalPart->QoSMaxPeriod;

                    call WmtpLocalManagementDataHandler.GenerateHeader( NULL, 0, FALSE );
                    SrcRoutedConnLocalPart->NextHop = RcvdSrcRoutedConnLocalPart->Hops[0];
                    SrcRoutedConnLocalPart->QoSMaxDelay = RcvdSrcRoutedConnLocalPart->QoSMaxDelay;
                    SrcRoutedConnLocalPart->QoSMaxPeriod = RcvdSrcRoutedConnLocalPart->QoSMaxPeriod;
                    SrcRoutedConnLocalPart->QoSPreferredPeriod = RcvdSrcRoutedConnLocalPart->QoSPreferredPeriod;
                    SrcRoutedConnLocalPart->QoSAccumulatedDelay = RcvdSrcRoutedConnLocalPart->QoSAccumulatedDelay + reserveDelay;
                    SrcRoutedConnLocalPart->NumHops = RcvdSrcRoutedConnLocalPart->NumHops - 1;

                    if ( reserveDelay > 0 ) {
                        dbg( "WMTP", "WmtpSourceRoutedConnectionEstablishmentHandlerP: QoS reservation delay: %d; Accumulated delay: %d.\n", reserveDelay, SrcRoutedConnLocalPart->QoSAccumulatedDelay );
                    }

                    // Calculate the service data size, generate tags and reserve QoS resources.
                    if ( call WmtpConnectionEstablishmentHandler.GetServiceDataSize( ((uint8_t *) &(RcvdSrcRoutedConnLocalPart->Hops[RcvdSrcRoutedConnLocalPart->NumHops])) + ConfigurationDataSize, &ServiceSpecificationDataSize ) != SUCCESS ||
                            call WmtpTagRouter.GetNewTag( SrcRoutedConnLocalPart->NextHop, &(SrcRoutedConnLocalPart->NextTag) ) != SUCCESS ||
                            call WmtpTagRouter.AddTagAssociation( SourceAddress, RcvdSrcRoutedConnLocalPart->NextTag, SrcRoutedConnLocalPart->NextHop, SrcRoutedConnLocalPart->NextTag, ConnectionSpecification, CONNECTION_ACTIVATION_TIMEOUT, CONNECTION_USAGE_TIMEOUT ) != SUCCESS ||
                            (reserveDelay == 0 && (RcvdSrcRoutedConnLocalPart->QoSMaxDelay > 0 || RcvdSrcRoutedConnLocalPart->QoSMaxPeriod > 0)) ||
                            (SrcRoutedConnLocalPart->QoSMaxDelay > 0 && SrcRoutedConnLocalPart->QoSAccumulatedDelay > SrcRoutedConnLocalPart->QoSMaxDelay) ||
                            (reserveDelay > 0 && call WmtpConnectionEstablishmentHandler.ReserveQoSResources( ConnectionSpecification, reserveDelay ) != SUCCESS) ) {
                        call WmtpConnectionEstablishmentHandler.FreeQoSResources( ConnectionSpecification );
                        call WmtpConnectionEstablishmentHandler.DestroyConnectionSpecification( ConnectionSpecification );

                        dbg( "WMTP", "WmtpSourceRoutedConnectionEstablishmentHandlerP: Failed to open connection.\n" );
                    } else {
                        memcpy( &(SrcRoutedConnLocalPart->Hops[0]),
                                &(RcvdSrcRoutedConnLocalPart->Hops[1]),
                                SrcRoutedConnLocalPart->NumHops * sizeof( uint16_t ) );
                        memcpy( &(SrcRoutedConnLocalPart->Hops[SrcRoutedConnLocalPart->NumHops]),
                                &(RcvdSrcRoutedConnLocalPart->Hops[RcvdSrcRoutedConnLocalPart->NumHops]),
                                ConfigurationDataSize );
                        memcpy( ((uint8_t *) &(SrcRoutedConnLocalPart->Hops[SrcRoutedConnLocalPart->NumHops])) + ConfigurationDataSize,
                                ((uint8_t *) &(RcvdSrcRoutedConnLocalPart->Hops[RcvdSrcRoutedConnLocalPart->NumHops])) + ConfigurationDataSize,
                                ServiceSpecificationDataSize );

                        call WmtpLocalManagementDataHandler.GenerateHeader(
                            SrcRoutedConnLocalPart,
                            sizeof( WmtpSrcRoutedConnLocalPart_t )
                            + SrcRoutedConnLocalPart->NumHops * sizeof( uint16_t )
                            + ConfigurationDataSize
                            + ServiceSpecificationDataSize,
                            TRUE );
                    }
                }

                *HeaderDataSize = sizeof( WmtpSrcRoutedConnLocalPart_t )
                                  + RcvdSrcRoutedConnLocalPart->NumHops * sizeof( uint16_t )
                                  + ConfigurationDataSize
                                  + ServiceSpecificationDataSize;

                return SUCCESS;
            } else {
                call WmtpConnectionEstablishmentHandler.DestroyConnectionSpecification( ConnectionSpecification );

                return FAIL;
            }
        } else {
            if ( call WmtpConnectionEstablishmentHandler.GetConfigurationSize( &(RcvdSrcRoutedConnLocalPart->Hops[RcvdSrcRoutedConnLocalPart->NumHops]), &ConfigurationDataSize ) == SUCCESS &&
                    call WmtpConnectionEstablishmentHandler.GetServiceDataSize( ((uint8_t *) &(RcvdSrcRoutedConnLocalPart->Hops[RcvdSrcRoutedConnLocalPart->NumHops])) + ConfigurationDataSize, &ServiceSpecificationDataSize ) == SUCCESS ) {
                *HeaderDataSize = sizeof( WmtpSrcRoutedConnLocalPart_t )
                                  + RcvdSrcRoutedConnLocalPart->NumHops * sizeof( uint16_t )
                                  + ConfigurationDataSize
                                  + ServiceSpecificationDataSize;

                return SUCCESS;
            } else {
                return FAIL;
            }
        }
    }
}
