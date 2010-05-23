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
 * Basic interface for handling Local Management Data.
 *
 * This interface allows WMTP plugins to interact with the core by handling
 * Local Management Data.
 *
 * @author Luis D. Pedrosa <luis.pedrosa@tagus.ist.utl.pt>
 * @author Hugo Freire <hugo.freire@ist.utl.pt> (port to TinyOS 2.x)
**/

#include "Wmtp.h"

interface WmtpLocalManagementDataHandler {
    /**
     * Provides a header to broadcast locally.
     *
     * @param HeaderData Pointer to the header's data.
     * @param HeaderDataSize Header's size.
     * @param SendNow Set to TRUE if the data is important and must be
     *                broadcasted ASAP.
     *
     * @return Returns the pointer to the previously held data.
    **/
    command void *GenerateHeader( void *HeaderData, uint8_t HeaderDataSize, uint8_t SendNow );

    /**
     * Notifies that the header is being locally broadcasted.
     *
     * @return An error code indicating the status of the operation.
    **/
    event error_t HeaderBroadcasted();

    /**
     * Handles a header received from a local broadcast.
     *
     * @param SourceAddress The address of the node that generated the header.
     * @param HeaderData Pointer to the header's data.
     * @param HeaderDataSize Variable to fill in with the header's size.
     *
     * @return An error code indicating the status of the operation.
    **/
    event error_t HandleHeader( uint16_t SourceAddress, void *HeaderData, uint8_t *HeaderDataSize );
}
