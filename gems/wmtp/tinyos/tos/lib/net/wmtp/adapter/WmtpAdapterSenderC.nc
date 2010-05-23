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
 * WMTP Protocol.
 *
 * This component implements an adaptation layer for traditional TinyOS
 * applications which enables them to use WMTP features without modifying
 * their implementation.
 *
 * @author Luis D. Pedrosa <luis.pedrosa@tagus.ist.utl.pt>
 * @author Hugo Freire <hugo.freire@ist.utl.pt> (port to TinyOS 2.x)
**/

#include "AM.h"

generic configuration WmtpAdapterSenderC(am_id_t AMId) {
    provides {
        interface AMSend;
        interface Packet;
        interface AMPacket;
    }
}

implementation {
    components new AMQueueEntryP(AMId) as AMQueueEntryP;

    //components AMQueueP, ActiveMessageC;
    components WmtpAdapterQueueP, WmtpAdapterC;

    //AMQueueEntryP.Send -> AMQueueP.Send[unique(UQ_AMQUEUE_SEND)];
    //AMQueueEntryP.AMPacket -> ActiveMessageC;
    AMQueueEntryP.Send -> WmtpAdapterQueueP.Send[unique(UQ_AMQUEUE_SEND)];
    AMQueueEntryP.AMPacket -> WmtpAdapterC;

    AMSend = AMQueueEntryP;
    Packet = WmtpAdapterC;
    AMPacket = WmtpAdapterC;
}
