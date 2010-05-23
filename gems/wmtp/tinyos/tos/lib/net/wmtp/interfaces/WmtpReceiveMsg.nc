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
 * Basic interface for receiving data from WMTP.
 *
 * This interface is similar to the TinyOS ReceiveMsg interface.
 *
 * @author Luis D. Pedrosa <luis.pedrosa@tagus.ist.utl.pt>
 * @author Hugo Freire <hugo.freire@ist.utl.pt> (port to TinyOS 2.x)
**/

#include "Wmtp.h"

interface WmtpReceiveMsg {
    /**
     * Data has been received. The data received is passed as a pointer
     * parameter. The event handler should return a pointer to a data buffer for
     * the reception layer to use for the next reception. This allows an
     * application to swap buffers back and forth with the WMTP Core, preventing
     * the need for copying. The signaled component should not maintain a
     * reference to the buffer that it returns. It may return the buffer it was
     * passed.
     * For example:
     * <code><pre>
     * event WmtpPayload_t *WmtpReceiveMsg.receive( WmtpConnectionSpecification_t *ConnectionSpecification, uint8_t DataLength, WmtpPayload_t *Data ) {
     *    return Data;
     * }
     * </pre></code>
     *
     * A more common example:
     * <code><pre>
     * WmtpPayload_t *buffer;
     * event WmtpPayload_t WmtpReceiveMsg.receive( WmtpConnectionSpecification_t *ConnectionSpecification, uint8_t DataLength, WmtpPayload_t *Data ) {
     *    WmtpPayload_t *tmp;
     *    tmp = buffer;
     *    buffer = Data;
     *    post receiveTask();
     *	return tmp;
     * }
     * </pre></code>
     *
     * @param ConnectionSpecification The connection specification that applies
     *                                to this packet.
     * @param DataLength The length of the data received.
     * @param Data A pointer to the buffer with the received data.
     *
     * @return A buffer for WMTP to use for the next packet.
    **/
    event WmtpPayload_t *Receive( WmtpConnectionSpecification_t *ConnectionSpecification, uint8_t DataLength, WmtpPayload_t *Data );
}
