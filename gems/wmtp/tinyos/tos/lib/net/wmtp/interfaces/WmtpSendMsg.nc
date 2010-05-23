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
 * Basic interface for sending data using WMTP.
 *
 * In order to provide its functionality, WMTP must regulate the rate at which
 * applications generate their data. To enable this traffic shaping,
 * applications must discipline themselves and use the ClearToSend event to
 * regulate the rate at which they generate data. If data may be generated
 * quickly, and on-demand, this event may be used to generate the data and
 * immediately dispatch it. If, on the other hand, this is not possible, a
 * certain amount of queueing is allowed, but any specified connection
 * guarantees (e.g. QOS) may not be reliable.
 *
 * @author Luis D. Pedrosa <luis.pedrosa@tagus.ist.utl.pt>
 * @author Hugo Freire <hugo.freire@ist.utl.pt> (port to TinyOS 2.x)
**/

#include "Wmtp.h"

interface WmtpSendMsg {
    /**
     * Sends data using the WMTP transport protocol.
     *
     * @param ConnectionSpecification The connection specification that
     *                                identifies the connection to send the data
     *                                through.
     * @param DataLength The length of the data buffer.
     * @param Data A pointer to the data buffer.
     *
     * @return An error code indicating the status of the operation.
    **/
    command error_t Send( WmtpConnectionSpecification_t *ConnectionSpecification, uint8_t DataLength, WmtpPayload_t *Data );

    /**
     * Notifies the application that it may send its data.
     *
     * @param ConnectionSpecification The connection specification that
     *                                identifies the connection to send the data
     *                                through.
     *
     * @return Indicates if the event was properly handled (currently ignored).
    **/
    event error_t ClearToSend( WmtpConnectionSpecification_t *ConnectionSpecification );

    /**
     * Checks if the application may send its data.
     *
     * @param ConnectionSpecification The connection specification that
     *                                identifies the connection to send the data
     *                                through.
     *
     * @return Returns TRUE if the application may send data through this
     *         connection, and FALSE otherwise.
    **/
    command uint8_t IsClearToSend( WmtpConnectionSpecification_t *ConnectionSpecification );
}
