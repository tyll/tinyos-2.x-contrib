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
 * Basic interface for handling Connection Management Data.
 *
 * This interface allows WMTP plugins to interact with the core by handling
 * Connection Management Data.
 *
 * @author Luis D. Pedrosa <luis.pedrosa@tagus.ist.utl.pt>
 * @author Hugo Freire <hugo.freire@ist.utl.pt> (port to TinyOS 2.x)
**/

#include "Wmtp.h"

interface WmtpConnectionManagementDataHandler {
    /**
     * Generates a header to attach to a freshly generated data packet.
     *
     * @param ConnectionSpecification The connection specification that
     *                                identifies the connection to which this
     *                                packet is associated;
     * @param Packet The packets queue element;
     * @param HeaderData Buffer to write the header's data to;
     * @param HeaderDataSize Variable to fill in with the header's size.
     *
     * @return An error code indicating the status of the operation.
    **/
    event error_t GenerateHeader( WmtpConnectionSpecification_t *ConnectionSpecification, WmtpQueueElement_t *Packet, void *HeaderData, uint8_t *HeaderDataSize );

    /**
     * Handles a header attached to a received data packet.
     *
     * @param PreviousHop The address of the previous hop.
     * @param ConnectionSpecification The connection specification that
     *                                identifies the connection to which this
     *                                packet is associated;
     * @param Packet The packets queue element;
     * @param HeaderData Pointer to the header's data;
     * @param HeaderDataSize Variable to fill in with the header's size.
     *
     * @return An error code indicating the status of the operation.
    **/
    event error_t HandleHeader( uint16_t PreviousHop, WmtpConnectionSpecification_t *ConnectionSpecification, WmtpQueueElement_t *Packet, void *HeaderData, uint8_t *HeaderDataSize );

    /**
     * Extracts a header from within a packet's queue element.
     *
     * @param Packet The packets queue element;
     * @param HeaderData Variable to be filled in with a pointer to the header's
     *                   data;
     *
     * @return An error code indicating the status of the operation.
    **/
    command error_t GetHeader( WmtpQueueElement_t *Packet, void **HeaderData );
}
