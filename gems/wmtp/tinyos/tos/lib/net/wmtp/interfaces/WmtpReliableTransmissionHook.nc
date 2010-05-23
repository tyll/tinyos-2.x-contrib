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
 * Basic interface provided to a reliability module.
 *
 * This interface allows a WMTP plugins to interact with the core by controlling
 * whether or not specific packets are dropped from the queue once they have
 * been sent.
 *
 * @author Luis D. Pedrosa <luis.pedrosa@tagus.ist.utl.pt>
 * @author Hugo Freire <hugo.freire@ist.utl.pt> (port to TinyOS 2.x)
**/

#include "Wmtp.h"

interface WmtpReliableTransmissionHook {
    /**
     * Notifies the reliability module that a packet is being sent.
     *
     * @param Packet The packet's queue element;
     * @param DropPacket Variable to fill in with TRUE to drop the packet or
     *                   FALSE to hold it.
     *
     * @return An error code indicating the status of the operation.
    **/
    event error_t SendingPacket( WmtpQueueElement_t *Packet, uint8_t *DropPacket );

    /**
     * Notifies the reliability module that a packet is being delivered to the application.
     *
     * @param Packet The packet's queue element;
     * @param DropPacket Variable to fill in with TRUE to drop the packet or
     *                   FALSE to hold it.
     *
     * @return An error code indicating the status of the operation.
    **/
    event error_t DeliveringPacket( WmtpQueueElement_t *Packet, uint8_t *DropPacket );

    /**
     * Notifies the reliability module that a packet is unroutable.
     *
     * @param Packet The packet's queue element;
     * @param DropPacket Variable to fill in with TRUE to drop the packet or
     *                   FALSE to hold it.
     *
     * @return An error code indicating the status of the operation.
    **/
    event error_t PacketUnroutable( WmtpQueueElement_t *Packet, uint8_t *DropPacket );

    /**
     * Notifies the reliability module that a new packet has been received.
     *
     * @param Packet The packet's queue element;
     * @param DropPacket Variable to fill in with TRUE to drop the packet or
     *                   FALSE to hold it.
     *
     * @return An error code indicating the status of the operation.
    **/
    event uint8_t IsPacketRepeated( WmtpQueueElement_t *Packet );

    /**
     * Drops a packet from the core queue.
     *
     * @param Packet The packet's queue element.
     *
     * @return An error code indicating the status of the operation.
    **/
    command error_t DropPacket( WmtpQueueElement_t *Packet );

}
