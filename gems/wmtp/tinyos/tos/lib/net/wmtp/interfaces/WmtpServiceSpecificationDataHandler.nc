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
 * Basic interface for handling Service Specification Data.
 *
 * This interface allows the WMTP core to know whether or not to accept a
 * connection, based on the Local and Remote Service Specifications.
 *
 * @author Luis D. Pedrosa <luis.pedrosa@tagus.ist.utl.pt>
 * @author Hugo Freire <hugo.freire@ist.utl.pt> (port to TinyOS 2.x)
**/

#include "Wmtp.h"

interface WmtpServiceSpecificationDataHandler {
    /**
     * Checks if a local and a remote service specification match.
     *
     * @param LocalService Pointer to the local service specification object.
     * @param RemoteData Pointer to the remote service specification data.
     * @param RemoteDataSize Variable to fill in with the remote service
     *                       specification data's size.
     * @param Match Boolean variable to set to true if the service
     *              specifications match and false otherwise.
     *
     * @return An error code indicating the status of the operation.
    **/
    command error_t CheckServiceMatch( WmtpServiceSpecification_t *LocalService, void *RemoteData, uint8_t *RemoteDataSize, uint8_t *Match );

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
}
