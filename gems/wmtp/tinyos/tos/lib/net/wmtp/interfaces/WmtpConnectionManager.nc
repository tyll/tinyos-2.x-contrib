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
 * Basic interface for managing WMTP connections.
 *
 * This interface lets the application manage and configure its connections.
 * Typically, an application will either be a connection receiver or initiater.
 * The receiving application will use the RegisterService and CancelService
 * commands while the initiating end will use the OpenConnection command. All
 * remaining commands and events will be used by both ends.
 *
 * @author Luis D. Pedrosa <luis.pedrosa@tagus.ist.utl.pt>
 * @author Hugo Freire <hugo.freire@ist.utl.pt> (port to TinyOS 2.x)
**/

#include "Wmtp.h"

interface WmtpConnectionManager {
    /**
     * Registers a service, enabling new incoming connections.
     *
     * @param ServiceSpecification The specification that incoming connections
     *                             must match to be accepted.
     * @param Handle A handle variable (passed by reference), that will filled
     *               in with a new handle that kept for further reference to
     *               this service.
     *
     * @return An error code indicating the status of the operation.
    **/
    command error_t RegisterService( WmtpServiceSpecification_t *ServiceSpecification );


    /**
     * Cancels a previously registered service, disabling any new connections.
     *
     * @param Handle The handle that identifies the specific service to cancel.
     *
     * @return An error code indicating the status of the operation.
    **/
    command error_t CancelService( WmtpServiceSpecification_t *ServiceSpecification );


    /**
     * Gets a new empty connection specification object.
     *
     * @param ConnectionSpecification Filled in with a pointer to the connection
     *                                specification object.
     *
     * @return An error code indicating the status of the operation.
    **/
    command error_t GetNewConnectionSpecification( WmtpConnectionSpecification_t **ConnectionSpecification );


    /**
     * Destroys an old connection specification object.
     *
     * @param ConnectionSpecification The connection specification object.
     *
     * @return An error code indicating the status of the operation.
    **/
    command error_t DestroyConnectionSpecification( WmtpConnectionSpecification_t *ConnectionSpecification );


    /**
     * Initiates one or more connections.
     *
     * @param ConnectionSpecification The specification of the connections to
     *                                establish.
     *
     * @return An error code indicating the status of the operation.
    **/
    command error_t OpenConnection( WmtpConnectionSpecification_t *ConnectionSpecification );


    /**
     * Notifies the application that a new connection has been established.
     *
     * @param ConnectionSpecification The specification that identifies this
     *                                connection.
     *
     * @return Indicates if the event was properly handled (currently ignored).
    **/
    event error_t ConnectionOpened( WmtpConnectionSpecification_t *ConnectionSpecification );


    /**
     * Reconfigures a previously established connection.
     *
     * @param ConnectionSpecification The specification that identifies the
     *                                reconfigured connection.
     *
     * @return An error code indicating the status of the operation.
    **/
    command error_t ReconfigureConnection( WmtpConnectionSpecification_t *ConnectionSpecification );


    /**
     * Notifies the application that the connection has been reconfigured.
     *
     * @param ConnectionSpecification The specification that identifies the
     *                                reconfigured connection.
     *
     * @return Indicates if the event was properly handled (currently ignored).
    **/
    event error_t ConnectionReconfigured( WmtpConnectionSpecification_t *ConnectionSpecification );


    /**
     * Closes a previously established connection.
     *
     * @param ConnectionSpecification The specification that identifies this
     *                                connection.
     *
     * @return An error code indicating the status of the operation.
    **/
    command error_t CloseConnection( WmtpConnectionSpecification_t *ConnectionSpecification );


    /**
     * Notifies the application that the connection has been closed. The
     * application will not be notified of the connection has been closed by its
     * request.
     *
     * @param ConnectionSpecification The specification that identifies this
     *                                connection.
     *
     * @return Indicates if the event was properly handled (currently ignored).
    **/
    event error_t ConnectionClosed( WmtpConnectionSpecification_t *ConnectionSpecification );
}
