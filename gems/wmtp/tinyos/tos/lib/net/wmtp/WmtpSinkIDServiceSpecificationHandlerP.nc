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
 * WMTP Sink ID Service Specification Handler.
 *
 * This component handles Sink ID Service Specifications. This service
 * specification provides a simple data sink identifier which can be used with
 * the fairness feature to identify multiple convergent flows.
 *
 * @author Luis D. Pedrosa <luis.pedrosa@tagus.ist.utl.pt>
 * @author Hugo Freire <hugo.freire@ist.utl.pt> (port to TinyOS 2.x)
**/

#include "Wmtp.h"

module WmtpSinkIDServiceSpecificationHandlerP {
    provides {
        interface WmtpServiceSpecificationDataHandler;
    }
} implementation {
    command error_t WmtpServiceSpecificationDataHandler.CheckServiceMatch( WmtpServiceSpecification_t *LocalService, void *RemoteData, uint8_t *RemoteDataSize, uint8_t *Match ) {
        WmtpSinkIDServiceSpecificationData_t *ServiceData = RemoteData;

        *Match = (ServiceData->SinkID == LocalService->ServiceData.SinkID.Value) ? TRUE : FALSE;

        *RemoteDataSize = sizeof( WmtpSinkIDServiceSpecificationData_t );

        return SUCCESS;
    }


    command error_t WmtpServiceSpecificationDataHandler.GetServiceDataSize( void *Data, uint8_t *DataSize ) {
        *DataSize = sizeof( WmtpSinkIDServiceSpecificationData_t );

        return SUCCESS;
    }


    command error_t WmtpServiceSpecificationDataHandler.GenerateServiceSpecificationData( WmtpServiceSpecification_t *ServiceSpecification, void *Data, uint8_t *DataSize ) {
        WmtpSinkIDServiceSpecificationData_t *ServiceData = Data;

        ServiceData->Reserved = 0;
        ServiceData->SinkID = ServiceSpecification->ServiceData.SinkID.Value;

        *DataSize = sizeof( WmtpSinkIDServiceSpecificationData_t );

        return SUCCESS;
    }
}
