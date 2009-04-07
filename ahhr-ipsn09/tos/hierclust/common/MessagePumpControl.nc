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
 * The control interface of a message pump.
 *
 * @author Konrad Iwanicki &lt;iwanicki@few.vu.nl&gt;
 */
interface MessagePumpControl {

    /**
     * Returns the number of messages in the pump queue.
     * @return the number of messages in the pump queue
     */
    command uint8_t getNumMessages();

    /**
     * Returns the maximal pump queue size.
     * @return the maximal allowed number of messages in the pump queue
     */
    command uint8_t getMaxMessages();

    /**
     * Empties the pump queue.
     *
     * For each message in the queue, the <code>AMSend.sendDone()</code>
     * event handler is invoked with the error code <code>ECANCEL</code>.
     * This way the user of the interface can do some cleanup, such as
     * freeing the message buffers.
     *
     * <b>ATTENTION</b>: The event handlers are invoked directly
     * from this command, thus it is important to keep them short.
     */
    command void emptyQueue();

    /**
     * Returns the maximal backoff period for messages, that is, the
     * maximal period a message can be in the pump queue.
     * @return the maximal backoff period in milliseconds
     */
    command uint32_t getMaxMessageBackoffPeriod();

    /**
     * Sets the maximal backoff period for messages, that is, the maximal
     * period a message can spend in the pump queue.
     * The new value will be used for messages that are sent after the
     * value was set. The messages already in the queue are unaffected.
     * @param t the maximal backoff period in milliseconds
     */
    command void setMaxMessageBackoffPeriod(uint32_t t);
    
    /**
     * Returns the number of times a message will be resent.
     * @return the number of times a message will be resent
     */
    command uint8_t getMaxResendCount();

    /**
     * Sets the number of times a message will be resent.
     * @param n the number of times a message will be resent
     */
    command void setMaxResendCount(uint8_t n);
}
