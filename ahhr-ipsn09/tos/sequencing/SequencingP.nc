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
#include <message.h>
#include <AM.h>
#include "Sequencing.h"

/**
 * The sequencinging functionality. This functionality should
 * be wired in the lowest part of the networking stack.
 *
 * @author Konrad Iwanicki &lt;iwanicki@few.vu.nl&gt;
 */
generic module SequencingP() {
    provides {
        interface Init;
        interface Sequencing;
        interface SequencingPacket;
        interface Packet;
        interface AMSend;
        interface Receive as Receive;
    }
    uses {
        interface Packet as SubPacket;
        interface AMSend as SubAMSend;
        interface Receive as SubReceive;
    }
}
implementation {

    // ------------------------- Private members --------------------------
    /** the generator for the sequencing sequence numbers */
    sequencing_seqno_t  seqNoGenerator;



    /**
     * A task executed when the overflow of the sequence
     * generator was pending.
     */
    task void taskSeqNoOverflow() {
        dbg("Sequencing", "Sequence generator has overflown.\n");
        signal Sequencing.seqNoOverflow();
    }



    /**
     * Augments a message to be sent with a sequence number.
     * @param msg the message to be augmented
     * @param len the length of the message
     * @return the new length of the message
     */
    inline uint8_t augmentMessageWithSequencingInfo(
            message_t * msg, uint8_t len) {
        nx_sequencing_header_t * hdr;

        dbg("Sequencing", "Augmenting a %hhu-byte message with " \
            "sequencinging data.\n", len);

        hdr = (nx_sequencing_header_t *)call SubPacket.getPayload(msg, NULL);
        hdr->seqNo = seqNoGenerator++;

        dbg("Sequencing", "  - seqNo: %d\n", (int)hdr->seqNo);

        if (seqNoGenerator == 0) {
            post taskSeqNoOverflow();
        }

        len += sizeof(nx_sequencing_header_t);

        dbg("Sequencing", "Message extended with sequencinging data " \
            "to %hhu bytes.\n", len);

        return len;
    }



    /**
     * Extracts the sequencinging info from a received message
     * and updates the local structures.
     * @param msg the received message
     * @param payload the payload of the received message
     * @param len the length of the received message
     * @return the new length of the message (after choping the
     *         sequencingning information), or 0xff denoting that
     *         the message was invalid
     */
    inline uint8_t extractSequencingInfoFromAMessage(
            message_t * msg, uint8_t * payload, uint8_t len) {

        nx_sequencing_header_t * hdr;

        dbg("Sequencing", "Extracting sequencinging data from a %hhu-byte " \
            "message.\n", len);

        if (len < sizeof(nx_sequencing_header_t)) {
            dbgerror("Sequencing", "The length of the message %hhu is smaller " \
                "than the minimal length %hhu!\n", len, \
                sizeof(nx_sequencing_header_t));
            return 0xff;
        }

        len -= sizeof(nx_sequencing_header_t);
        hdr = (nx_sequencing_header_t *)payload;

        dbg("Sequencing", "  - seqNo: %d\n", (int)hdr->seqNo);

        return len;
    }



    /**
     * Prints a raw message.
     * @param msg the message to be printed
     * @param len the length of the message
     */
    void printRawMessage(message_t * msg, uint8_t len) {
#ifdef TOSSIM
#ifndef TOSSIM_NO_DEBUG
        uint8_t * d;
        uint8_t   i;

        d = (uint8_t *)msg->data;
        dbg("Sequencing", "Raw message:");
        for (i = 0; i < len; ++i) {
            dbg_clear("Sequencing", " %hhx", d[i]);
        }
        dbg_clear("Sequencing", ".\n");
#endif
#endif
    }



    // ------------------------- Interface Init ---------------------------
    command inline error_t Init.init() {
        dbg("Sequencing", "Initializing the sequencinging functionality.\n");

        seqNoGenerator = 0;

        return SUCCESS;
    }



    // ----------------------- Interface Sequencing ------------------------
    command inline void Sequencing.resetSeqNo() {
        seqNoGenerator = 0;
    }



    command inline sequencing_seqno_t Sequencing.getSeqNo() {
        return seqNoGenerator;
    }



    default event inline void Sequencing.seqNoOverflow() {
        // Do nothing.
    }



    // -------------------- Interface SequencingPacket ---------------------
    command inline sequencing_seqno_t SequencingPacket.getSeqNo(
            message_t * msg) {
        nx_sequencing_header_t * hdr =
            (nx_sequencing_header_t *)call SubPacket.getPayload(msg, NULL);
        return hdr->seqNo;
    }



    // ------------------------ Interface Packet --------------------------
    command inline void Packet.clear(message_t * msg) {
        call SubPacket.clear(msg);
    }



    command inline uint8_t Packet.payloadLength(message_t * msg) {
        return call SubPacket.payloadLength(msg)
            - sizeof(nx_sequencing_header_t);
    }



    command inline void Packet.setPayloadLength(message_t * msg, uint8_t len) {
        call SubPacket.setPayloadLength(
            msg, len + sizeof(nx_sequencing_header_t));
    }



    command inline uint8_t Packet.maxPayloadLength() {
        return call SubPacket.maxPayloadLength()
            - sizeof(nx_sequencing_header_t);
    }



    command inline void * Packet.getPayload(message_t * msg, uint8_t * len) {
        uint8_t * payload =
            (uint8_t *)(call SubPacket.getPayload(msg, len));
        if (len != NULL) {
            *len -= sizeof(nx_sequencing_header_t);
        }
        return payload + sizeof(nx_sequencing_header_t);
    }



    // ------------------------ Interface AMSend --------------------------
    command inline error_t AMSend.send(
            am_addr_t addr, message_t * msg, uint8_t len) {
        dbg("Sequencing", "Packet to send %x enters the sequencinging " \
            "layer [%s].\n", msg, __FUNCTION__);

        len = augmentMessageWithSequencingInfo(msg, len);

        printRawMessage(msg, len);

        return call SubAMSend.send(addr, msg, len);
    }



    command inline error_t AMSend.cancel(message_t * msg) {
        return call SubAMSend.cancel(msg);
    }



    event inline void SubAMSend.sendDone(message_t * msg, error_t error) {
        dbg("Sequencing", "Packet to send %x leaves the sequencinging " \
            "layer [%s].\n", msg, __FUNCTION__);

        signal AMSend.sendDone(msg, error);
    }



    command inline uint8_t AMSend.maxPayloadLength() {
        return call Packet.maxPayloadLength();
    }



    command inline void * AMSend.getPayload(message_t * msg) {
        return call Packet.getPayload(msg, NULL);
    }



    // ----------------------- Interface Receive --------------------------
    event inline message_t * SubReceive.receive(
            message_t * msg, void * payload, uint8_t len) {

        dbg("Sequencing", "Packet received %x enters the sequencinging " \
            "layer [%s].\n", msg, __FUNCTION__);

        printRawMessage(msg, len);

        len =
            extractSequencingInfoFromAMessage(
                msg, (uint8_t *)payload, len);

        if (len == 0xff) {

            dbg("Sequencing", "Packet %x dropped by the sequencinging " \
                "layer [%s].\n", msg, __FUNCTION__);

            return msg;
        } else {
            payload = (uint8_t *)payload + sizeof(nx_sequencing_header_t);

            dbg("Sequencing", "Packet received %x leaves the sequencinging "
                "layer [%s].\n", msg, __FUNCTION__);

            return signal Receive.receive(msg, payload, len);
        }

    }



    default event inline message_t * Receive.receive(
            message_t * msg, void * payload, uint8_t len) {
        // Do nothing.
        return msg;
    }



    command inline void * Receive.getPayload(
            message_t * msg, uint8_t * len) {
        return call Packet.getPayload(msg, len);
    }



    command inline uint8_t Receive.payloadLength(message_t * msg) {
        return call Packet.payloadLength(msg);
    }

}
