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
 * Basic interface for handling Routing Data.
 *
 * This interface allows the WMTP core to interact with a multi-hop router that
 * provides the next hop for a received packet, provided its routing data.
 *
 * @author Luis D. Pedrosa <luis.pedrosa@tagus.ist.utl.pt>
 * @author Hugo Freire <hugo.freire@ist.utl.pt> (port to TinyOS 2.x)
**/

#include "Wmtp.h"

interface WmtpMultihopRouter {
    /**
     * Calculates a data packet's next hop from the associated routing data.
     *
     * Additionaly, if the packet was locally generated
     * (i.e. SourceAddress == TOS_NODE_ID), the routing header should be
     * generated, instead of interpreted. In this case, ConnecionSpecification
     * should be read, instead of filled in.
     *
     * @param SourceAddress The address of the previous hop.
     * @param RoutingData Pointer to the RoutingData.
     * @param RoutingDataSize Variable to fill in with the data's size.
     * @param Address Variable to fill in with the next hop's address.
     * @param ConnectionSpecification Variable to with the associated connection
     *                                specification (either to fill in or to
     *                                read).
     *
     * @return An error code indicating the status of the operation.
    **/
    command error_t GetNextHop( uint16_t SourceAddress, void *RoutingData, uint8_t *RoutingDataSize, uint16_t *Address, WmtpConnectionSpecification_t **ConnectionSpecification );
}
