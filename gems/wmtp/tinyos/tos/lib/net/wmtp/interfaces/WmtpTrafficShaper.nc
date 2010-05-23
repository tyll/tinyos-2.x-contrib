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
 * Basic interface provided to Traffic Shapers.
 *
 * This interface allows WMTP plugins to interact with the core by delaying the
 * transmission of individual packets or the generation of application data for
 * specific connections.
 *
 * @author Luis D. Pedrosa <luis.pedrosa@tagus.ist.utl.pt>
 * @author Hugo Freire <hugo.freire@ist.utl.pt> (port to TinyOS 2.x)
**/

#include "Wmtp.h"

interface WmtpTrafficShaper {
    /**
     * Notifies the traffic shaper that a new packet was generated or received.
     *
     * @param Packet The packet's queue element.
     *
     * @return An error code indicating the status of the operation.
    **/
    event error_t NewPacket( WmtpQueueElement_t *Packet );


    /**
     * Notifies the traffic shaper that a packet is being sent.
     *
     * @param Packet The packet's queue element.
     *
     * @return An error code indicating the status of the operation.
    **/
    event error_t SendingPacket( WmtpQueueElement_t *Packet );


    /**
     * Notifies the traffic shaper that a packet is being removed from the core
     * queue. If the packet doesn't have reliability, this event is similar to
     * the SendingPacket event, but otherwise it is not.
     *
     * @param Packet The packet's queue element.
     *
     * @return An error code indicating the status of the operation.
    **/
    event error_t DroppingPacket( WmtpQueueElement_t *Packet );


    /**
     * Notifies the traffic shaper that a new connection was opened.
     *
     * @param ConnectionSpecification The connection specification that
     *                                identifies the new connection.
     *
     * @return An error code indicating the status of the operation.
    **/
    event error_t ConnectionOpened( WmtpConnectionSpecification_t *ConnectionSpecification );


    /**
     * Notifies the traffic shaper that a connection was closed.
     *
     * @param ConnectionSpecification The connection specification that
     *                                identified the closed connection.
     *
     * @return An error code indicating the status of the operation.
    **/
    event error_t ConnectionClosed( WmtpConnectionSpecification_t *ConnectionSpecification );


    /**
     * Notifies the traffic shaper that a connection was reconfigured.
     *
     * @param ConnectionSpecification The connection specification that
     *                                identified the reconfigured connection.
     *
     * @return An error code indicating the status of the operation.
    **/
    event error_t ConnectionReconfigured( WmtpConnectionSpecification_t *ConnectionSpecification );


    /**
     * Re-enables a packet's transmission.
     *
     * @param Packet The packet's queue element.
     *
     * @return An error code indicating the status of the operation.
    **/
    command error_t StartPacket( WmtpQueueElement_t *Packet );


    /**
     * Re-enables a connections's transmission.
     *
     * @param ConnectionSpecification The connection specification that
     *                                identifies the connection to start.
     *
     * @return An error code indicating the status of the operation.
    **/
    command error_t StartConnection( WmtpConnectionSpecification_t *ConnectionSpecification );


    /**
     * Disables a packet's transmission until a StartPacket is issued.
     *
     * @param Packet The packet's queue element.
     *
     * @return An error code indicating the status of the operation.
    **/
    command error_t StopPacket( WmtpQueueElement_t *Packet );


    /**
     * Disables a connection's transmission until a StartConnection is issued.
     *
     * @param ConnectionSpecification The connection specification that
     *                                identifies the connection to stop.
     *
     * @return An error code indicating the status of the operation.
    **/
    command error_t StopConnection( WmtpConnectionSpecification_t *ConnectionSpecification );


    /**
     * Gets a packet's current traffic shaping state for this particular
     * handler.
     *
     * @param Packet The packet's queue element.
     * @param State Variable filled in with TRUE if the packet is active
     *              (a StartConnection was issued) and FALSE otherwise.
     *
     * @return An error code indicating the status of the operation.
    **/
    command error_t GetPacketState( WmtpQueueElement_t *Packet, uint8_t *State );


    /**
     * Gets a connection's current traffic shaping state for this particular
     * handler.
     *
     * @param ConnectionSpecification The connection specification that
     *                                identifies the connection.
     * @param State Variable filled in with TRUE if the connection is active
     *              (a StartConnection was issued) and FALSE otherwise.
     *
     * @return An error code indicating the status of the operation.
    **/
    command error_t GetConnectionState( WmtpConnectionSpecification_t *ConnectionSpecification, uint8_t *State );

}
