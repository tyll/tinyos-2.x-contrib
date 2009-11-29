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
#include "HierarchicalClusteringDemo.h"


/**
 * An arbiter for the serial messaging access.
 *
 * @author Konrad Iwanicki &lt;iwanicki@few.vu.nl&gt;
 */
module HierarchicalClusteringDemoSerialMediatorP {
    provides {
        interface AMSend as AMSend[am_id_t];
    }
    uses {
        interface AMSend as SubAMSend[am_id_t];
        interface GenericQueue<hcdemo_serial_queue_entry_t> as MsgQueue;
    }
}
implementation {
    // ------------------------ Private members ----------------------------
    /** indicates whether anything is being sent over the serial port */
    bool            sending = FALSE;

    /**
     * The task for emptying the queue.
     */
    task void taskPushQueue();



    // ------------------------ Interface AMSend ---------------------------
    command inline error_t AMSend.send[am_id_t amId](
            am_addr_t addr, message_t * msg, uint8_t len) {
        hcdemo_serial_queue_entry_t * qentry;

        qentry = call MsgQueue.enqueue();
        if (qentry == NULL) {
            return EBUSY;
        }

        qentry->msg = msg;
        qentry->len = len;
        qentry->amId = amId;

        post taskPushQueue();
        
        return SUCCESS;
    }



    command inline error_t AMSend.cancel[am_id_t amId](message_t * msg) {
        return FAIL;
    }



    command inline uint8_t AMSend.maxPayloadLength[am_id_t amId]() {
        return call SubAMSend.maxPayloadLength[amId]();
    }



    command inline void * AMSend.getPayload[am_id_t amId](message_t * m) {
        return call SubAMSend.getPayload[amId](m);
    }



    event inline void SubAMSend.sendDone[am_id_t amId](
            message_t * msg, error_t result) {
        hcdemo_serial_queue_entry_t *  qentry;

        qentry = call MsgQueue.head();

        if (!sending || qentry == NULL) {
            // some internal error has occurred
            return;
        }

        if (qentry->msg != msg) {
            // another error.
            return;
        }

        sending = FALSE;

        signal AMSend.sendDone[amId](msg, result);

        call MsgQueue.dequeue();
        
        post taskPushQueue();
    }



    default event inline void AMSend.sendDone[am_id_t amId](
            message_t * msg, error_t result) {
        // Do nothing.
    }



    // ----------------------- Task implementations ------------------------
    task void taskPushQueue() {
        hcdemo_serial_queue_entry_t *  qentry;
        error_t                        error;

        if (sending) {
            return;
        }

        qentry = call MsgQueue.head();
        if (qentry == NULL) {
            return;
        }

        error =
            call SubAMSend.send[qentry->amId](
                AM_BROADCAST_ADDR, qentry->msg, qentry->len);

        if (error != SUCCESS) {

            signal AMSend.sendDone[qentry->amId](qentry->msg, error);

            call MsgQueue.dequeue();

            post taskPushQueue();

        } else {
            sending = TRUE;
        }
    }
}
