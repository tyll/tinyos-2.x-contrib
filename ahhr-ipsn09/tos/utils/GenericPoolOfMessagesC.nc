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
#include <AM.h>
#include <message.h>

/**
 * The generic implementation of the message pool interface
 * (see <code>PoolOfMessages</code>.
 *
 * @param POOL_SIZE     the number of messages in the pool
 *
 * @author Konrad Iwanicki &lt;iwanicki@few.vu.nl&gt;
 */

generic module GenericPoolOfMessagesC(uint16_t POOL_SIZE) {
    provides {
        interface Init;
        interface PoolOfMessages as Pool;
    }
}
implementation {
    // ------------------------- Private members --------------------------
    /** the message buffers */
    message_t        messageBuffers[POOL_SIZE];
    /** the message pointers based on which we perform the allocation */
    message_t *      messagePointers[POOL_SIZE];
    /** the number of pointers allocated so far */
    uint16_t         numAllocated = POOL_SIZE;



    // -------------------------- Interface Init --------------------------
    command inline error_t Init.init() {
        uint16_t i;

        dbg("MessagePool", \
            "Initializing a %hu-element message pool [%s].\n", \
            POOL_SIZE, __FUNCTION__);

        for (i = 0; i < POOL_SIZE; ++i) {
            messagePointers[i] = &(messageBuffers[i]);
        }
        numAllocated = 0;
        
        return SUCCESS;
    }



    // -------------------------- Interface Pool --------------------------
    command inline message_t * Pool.allocMessage() {
        message_t * res;

        if (numAllocated >= POOL_SIZE) {
            dbg("MessagePool", \
                "No free message buffer to allocate [%s].\n", __FUNCTION__);
            return NULL;
        }

        res = messagePointers[numAllocated];
        ++numAllocated;

        dbg("MessagePool", \
            "Allocated a message buffer %x. Buffers allocated " \
            "so far %hu out of %hu [%s].\n", res, numAllocated, \
            POOL_SIZE, __FUNCTION__);

        return res;
    }



    command inline void Pool.freeMessage(message_t * msg) {
        if (numAllocated == 0) {
            dbgerror("MessagePool", \
                "Unable to free a message buffer %x [%s].\n", \
                msg, __FUNCTION__);
            return;
        }

        --numAllocated;
        messagePointers[numAllocated] = msg;

        dbgerror("MessagePool", \
            "Freed a message buffer %x. Remaining allocated buffers " \
            "%hu out of %hu [%s].\n", msg, numAllocated, \
            POOL_SIZE, __FUNCTION__);
    }

}
