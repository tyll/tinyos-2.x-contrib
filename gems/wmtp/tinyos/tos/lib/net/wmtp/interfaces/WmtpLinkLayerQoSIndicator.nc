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
 * Basic interface used by the WMTP core to obtain the assured
 * Quality-of-Service (QoS) levels, provided by the link layer protocol in use.
 *
 * This interface provides the WMTP core with assured QoS parameters that it, in
 * turn, may use to guarantee its own QoS levels.
 *
 * @author Luis D. Pedrosa <luis.pedrosa@tagus.ist.utl.pt>
 * @author Hugo Freire <hugo.freire@ist.utl.pt> (port to TinyOS 2.x)
**/

#include "Wmtp.h"

interface WmtpLinkLayerQoSIndicator {
    /**
     * Obtains the maximum delay that the MAC protocol in use needs to send a
     * packet. Measured as the time between the moment the send command is
     * called and the sendDone event is signaled.
     *
     * @return The maximum delay (ms) the MAC protocol needs to send a packet.
     * Returning 0 indicates that no QoS levels can be assured by this protocol.
    **/
    command uint16_t GetMaxSendDelay();
}
