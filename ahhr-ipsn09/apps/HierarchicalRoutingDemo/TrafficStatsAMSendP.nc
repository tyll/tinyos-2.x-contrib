/*
 * IMPORTANT: READ BEFORE DOWNLOADING, COPYING, INSTALLING OR USING.  By
 * downloading, copying, installing or using the software you agree to
 * this license.  If you do not agree to this license, do not download,
 * install, copy or use the software.
 *
 * Copyright (c) 2006-2008 Vrije Universiteit Amsterdam and
 * Development Laboratories (DevLab), Eindhoven, the Netherlands.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * - Redistributions of source code must retain the above copyright
 *   notice, this list of conditions, the author, and the following
 *   disclaimer.
 * - Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions, the author, and the following disclaimer
 *   in the documentation and/or other materials provided with the
 *   distribution.
 * - Neither the name of the Vrije Universiteit Amsterdam, nor the name of
 *   DevLab, nor the names of their contributors may be used to endorse or
 *   promote products derived from this software without specific prior
 *   written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL VRIJE
 * UNIVERSITEIT AMSTERDAM, DEVLAB, OR THEIR CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * Authors: Konrad Iwanicki
 * CVS id: $Id$
 */
#include "TrafficStats.h"


/**
 * A statistics layer on top of the <code>AMSend</code> interface
 * that enables calculating the traffic flowing through the communication
 * stack. More specifically, it counts the number of sent messages and
 * bytes.
 *
 * @author Konrad Iwanicki &lt;iwanicki@few.vu.nl&gt;
 */
generic module TrafficStatsAMSendP() {
    provides {
        interface AMSend;
    }
    uses {
        interface AMSend as SubAMSend;
        interface Packet as SubPacket;
        interface Statistics<traffic_stats_outgoing_stats_t> as Container;
    }
}
implementation {

    // ------------------------ Interface AMSend --------------------------
    command inline error_t AMSend.send(
            am_addr_t addr, message_t * msg, uint8_t len) {
        traffic_stats_outgoing_stats_t * stats;

        stats = call Container.getStats();

        // Update statistics.
        ++(stats->schedMessages);
        stats->schedBytes += len;

        return call SubAMSend.send(addr, msg, len);
    }



    command inline error_t AMSend.cancel(message_t * msg) {
        return call SubAMSend.cancel(msg);
    }



    event inline void SubAMSend.sendDone(message_t * msg, error_t error) {
        if (error == SUCCESS) {
            traffic_stats_outgoing_stats_t * stats;

            stats = call Container.getStats();

            // Update statistics if the transmission succeeded.
            ++(stats->txedMessages);
            stats->txedBytes += call SubPacket.payloadLength(msg);
        }
        signal AMSend.sendDone(msg, error);
    }



    command inline uint8_t AMSend.maxPayloadLength() {
        return call SubAMSend.maxPayloadLength();
    }



    command inline void * AMSend.getPayload(message_t * msg) {
        return call SubAMSend.getPayload(msg);
    }



}
