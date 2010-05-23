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
 * Basic interface for handling connection establishment.
 *
 * This interface bridges between the WMTP core and the connection establishment
 * logic. When the application requests a new connection the request is rerouted
 * to the appropriate handler through this interface. Likewise, when a handler
 * needs to verify if a service matches or to configure the connection, it also
 * uses this interface to go through the WMTP core.
 * A special note must be made for QoS enabled connections. Since the QoS
 * reservation process may be similar, in many aspects, to a transaction, it is
 * often desirable to reserve and/or cancel QoS resources before actually
 * opening the connection. Hence the WMTP core requires the following procedure
 * for these connections:
 *    - The handler may request that the core calculate the shortest available
 *      delay at any time by using the GetQoSShortestDelay command. The request
 *      itself does not reserve any resources and its answer is only valid
 *      during the current context (i.e. until the handler returns). Note that
 *      the WMTP core may enact arbitrary policies that limit the minimum delay
 *      calculated by this function. This means that a QoS reservation with a
 *      delay that is smaller than the one calculated by this function may still
 *      be accepted;
 *    - Connections without QoS enabled may be opened directly with the
 *      AddLocalConnection and AddNonLocalConnection commands;
 *    - Connections with local delivery do not need to reserve any resources
 *      since they can reach their destination without any delay;
 *    - QoS enabled connections MUST FIRST reserve their associated resources
 *      through the ReserveQoSResources command. Once the QoS resources have
 *      been reserved, the connection may be opened at a later time using the
 *      AddLocalConnection or AddNonLocalConnection commands, as usual;
 *    - The FreeQoSResources command MUST ONLY be used to free the resources on
 *      unopened connections. The resources of an open connection are
 *      automatically freed when the connection is closed.
 *
 * @author Luis D. Pedrosa <luis.pedrosa@tagus.ist.utl.pt>
 * @author Hugo Freire <hugo.freire@ist.utl.pt> (port to TinyOS 2.x)
**/

#include "Wmtp.h"

interface WmtpConnectionEstablishmentHandler {
    /**
     * Initiates one or more connections.
     *
     * Additionaly, the function should fill in the router type field within the
     * router specificationof the connection specification.
     *
     * @param ConnectionSpecification The specification of the service to
     *                                discover.
     *
     * @return An error code indicating the status of the operation.
    **/
    event error_t OpenConnection( WmtpConnectionSpecification_t *ConnectionSpecification );


    /**
     * Notifies that a connection has been closed and that any associated
     * resources shoulf be freed.
     *
     * @param ConnectionSpecification Pointer to the connection specification
     *                                that identifies the connection.
     *
     * @return An error code indicating the status of the operation.
    **/
    event error_t ConnectionClosed( WmtpConnectionSpecification_t *ConnectionSpecification );


    /**
     * Generates service specification data suitable to be sent over the
     * network and matched against remote services.
     *
     * @param ServiceSpecification Pointer to the service specification object.
     * @param Data Buffer to fill in with the service specification data.
     * @param DataSize Variable to fill in with the service specification data's
     *                 size.
     *
     * @return An error code indicating the status of the operation.
    **/
    command error_t GenerateServiceSpecificationData( WmtpServiceSpecification_t *ServiceSpecification, void *Data, uint8_t *DataSize );


    /**
     * Checks if the specified service specification data matches a local
     * service specification object.
     *
     * @param LocalService Pointer to the local service specification object.
     * @param ConnectionOriented Set to TRUE to match only connection-oriented
     *                           services and FALSE to match only
     *                           connection-less services.
     * @param RemoteData Pointer to the remote service specification data.
     * @param RemoteDataSize Variable that will be filled in with the remote
     *                       service specification data's size.
     * @param Match Boolean variable that is set to true if the service
     *              specifications match and false otherwise.
     *
     * @return An error code indicating the status of the operation.
    **/
    command error_t CheckServiceMatch( WmtpServiceSpecification_t *LocalService, uint8_t ConnectionOriented, void *RemoteData, uint8_t *RemoteDataSize, uint8_t *Match );


    /**
     * Calculates the size of a service specification's data.
     *
     * @param Data Pointer to the service specification data.
     * @param DataSize Variable to fill in with the service specification data's
     *                 size.
     *
     * @return An error code indicating the status of the operation.
    **/
    command error_t GetServiceDataSize( void *Data, uint8_t *DataSize );


    /**
     * Gets a matching service specification.
     *
     * @param ConnectionOriented Set to TRUE to match only connection-oriented
     *                           services and FALSE to match only
     *                           connection-less services.
     * @param RemoteData Pointer to the remote service specification data.
     * @param RemoteDataSize Variable to fill in with the remote service
     *                       specification data's size.
     * @param LocalService Variable that will be filled in with the pointer to
     *                     the matching local service specification object.
     *
     * @return An error code indicating the status of the operation.
    **/
    command error_t GetMatchingService( uint8_t ConnectionOriented, void *RemoteData, uint8_t *RemoteDataSize, WmtpServiceSpecification_t **LocalService );


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
     * Generates the configuration data from the connections current
     * configuration.
     *
     * @param ConnectionSpecification The connection specification that holds
     *                                the configuration;
     * @param ConfigurationData Buffer to write the configuration data to;
     * @param ConfigurationDataSize Variable to fill in with the data's size.
     *
     * @return An error code indicating the status of the operation.
    **/
    command error_t GenerateConnectionConfiguration( WmtpConnectionSpecification_t *ConnectionSpecification, void *ConfigurationData, uint8_t *ConfigurationDataSize );


    /**
     * Calculates the size of the provided configuration data.
     *
     * @param ConfigurationData Pointer to the configuration data;
     * @param ConfigurationDataSize Variable that will be filled in with the
     *                              data's size.
     *
     * @return An error code indicating the status of the operation.
    **/
    command error_t ConfigureConnection( void *ConfigurationData, uint8_t *ConfigurationDataSize, WmtpConnectionSpecification_t *ConnectionSpecification );


    /**
     * (Re)Configures a connection using the provided configuration data.
     *
     * @param ConfigurationData Pointer to the configuration data;
     * @param ConfigurationDataSize Variable that will be filled in with the
     *                              data's size.
     * @param ConnectionSpecification The connection specification to update
     *                                with the configuration;
     *
     * @return An error code indicating the status of the operation.
    **/
    command error_t GetConfigurationSize( void *ConfigurationData, uint8_t *ConfigurationDataSize );


    /**
     * Signals the application and other modules with the new connection and
     * saves the new connection specification that will be used for further
     * communication.
     *
     * @param ConnectionSpecification Pointer to the connection specification
     *                                that identifies the connection.
     *
     * @return An error code indicating the status of the operation.
    **/
    command error_t AddLocalConnection( WmtpConnectionSpecification_t *ConnectionSpecification );


    /**
     * Signals other modules with the new connection and saves the new
     * connection specification for future reference.
     *
     * @param ConnectionSpecification Pointer to the connection specification
     *                                that identifies the connection.
     *
     * @return An error code indicating the status of the operation.
    **/
    command error_t AddNonLocalConnection( WmtpConnectionSpecification_t *ConnectionSpecification );


    /**
     * Signals other modules with the closed connection and releases any
     * associated resources.
     *
     * @param ConnectionSpecification Pointer to the connection specification
     *                                that identifies the connection.
     *
     * @return An error code indicating the status of the operation.
    **/
    command error_t CloseConnection( WmtpConnectionSpecification_t *ConnectionSpecification );


    /**
     * Sends an empty packet towards the other endpoint of the connection.
     *
     * @param ConnectionSpecification Pointer to the connection specification
     *                                that identifies the connection.
     *
     * @return An error code indicating the status of the operation.
    **/
    command error_t SendKeepAlive( WmtpConnectionSpecification_t *ConnectionSpecification );


    /**
     * Calculates the the shortest delay that the QoS reservation system can
     * dispense that is larger than or equal to the provided minimum. This
     * command does not reserve any resources.
     *
     * @param MinDelay The minimum required delay.
     * @param CalculatedDelay Variable to fill in with the calculated delay.
     *
     * @return An error code indicating the status of the operation.
    **/
    command error_t GetQoSShortestDelay( uint16_t MinDelay, uint16_t *CalculatedDelay );


    /**
     * Reserves the QoS resources associated with a connection, without opening
     * the connection. Later on, the resoures may be freed with the
     * FreeQoSResources command or the connection may be opened with the
     * AddLocalConnection or AddNonLocalConnection commands.
     *
     * @param ConnectionSpecification Pointer to the connection specification
     *                                that identifies the connection.
     * @param Delay The maximum delay to associate to this connection.
     *
     * @return An error code indicating the status of the operation.
    **/
    command error_t ReserveQoSResources( WmtpConnectionSpecification_t *ConnectionSpecification, uint16_t Delay );


    /**
     * Canceles a previous reservation of the QoS resources associated with a
     * connection that has not been opened yet.
     *
     * @param ConnectionSpecification Pointer to the connection specification
     *                                that identifies the connection.
     *
     * @return An error code indicating the status of the operation.
    **/
    command error_t FreeQoSResources( WmtpConnectionSpecification_t *ConnectionSpecification );
}
