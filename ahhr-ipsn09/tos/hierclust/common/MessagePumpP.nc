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
 * A pump for outgoing messages.
 *
 * When sending each message, the pump draws a random transmission time
 * up to the current value of the maximal message backoff period.
 * Sending the message is then delayed for that amount of time.
 * All delayed messages are stored in a queue.
 *
 * @param QUEUE_SIZE              the size of the queue for messages
 * @param INITIAL_BACKOFF_TIME    the initial maximal message backoff time
 *
 * @author Konrad Iwanicki &lt;iwanicki@few.vu.nl&gt;
 */
generic module MessagePumpP(
        uint8_t QUEUE_SIZE, uint32_t INITIAL_BACKOFF_TIME) {
    provides {
        interface MessagePumpControl as Control;
        interface AMSend;
    }
    uses {
        interface AMSend as SubAMSend;
        interface Timer<TMilli> as PumpTimer;
        interface Random;
    }
}
implementation {

    // ------------------------ Private members ---------------------------
    /**
     * A single queue entry.
     */
    typedef struct {
        uint32_t     t0;            // the time when the message was enqueued
        uint32_t     tb;            // message backoff time
        uint32_t     dt;            // the time after which the message should
                                    // be transmitted
        am_addr_t    addr;          // the address for the message
        message_t *  msg;           // the pointer to the message
        uint8_t      len;           // the length of the message
        uint8_t      timeOverflow;  // indicates if the new time is in
                                    // a different time scale
        uint8_t      maxResend;     // the maximal number of times a message
                                    // is resent
        uint8_t      numResend;     // the number of times a message is
                                    // resent
    } queue_entry_t;


    uint32_t          maxMessageBackoffTime = INITIAL_BACKOFF_TIME;

    queue_entry_t     entries[QUEUE_SIZE];
    uint8_t           firstIdx = 0;
    uint8_t           numEntries = 0;

    bool              sending = FALSE;
    
    uint8_t           maxResendCount = 1;


    /**
     * A task that sends messages.
     */
    task void taskSendMessages();
    /**
     * Prints the contents of a message queue.
     */
    void dbgPrintMsgQueue();
    /**
     * Enqueues an entry.
     * @return the pointer to the enqueued entry or <code>NULL</code>
     *         if the queue is full
     */
    queue_entry_t * enqueueMsg();
    /**
     * Returns an entry from the top of the queue
     * but does NOT dequeue it.
     * @return the pointer to the entry or <code>NULL</code>
     *         if the queue is empty
     */
    queue_entry_t * peekFirstMsg();
    /**
     * Dequeues an entry.
     * @return the pointer to the dequeued entry or <code>NULL</code>
     *         if the queue is empty
     */
    queue_entry_t * dequeueMsg();
    /**
     * Requeues an entry. Removes the entry from the end of the queue.
     * and puts it at the beginning of the queue.
     * @return the pointer to the requeued entry or <code>NULL</code>
     *         if the queue is empty
     */
    queue_entry_t * requeueMsg();




    // ------------------------ Interface AMSend --------------------------
    command error_t AMSend.send(
            am_addr_t addr, message_t * msg, uint8_t len) {
        queue_entry_t *   qentry;

        dbg("MessagePump|1", \
            "Trying to enqueue message %x for transmission. [%s]\n", \
            msg, __FUNCTION__);

        dbgPrintMsgQueue();


        // Try to allocate a queue entry.
        qentry = enqueueMsg();
        if (qentry == NULL) {
            // The queue is full, sending the message failed.
            dbg("MessagePump|1", \
                "Unable to enqueue message %x for transmission. " \
                "Message queue is full. [%s]\n", msg, __FUNCTION__);
            return EBUSY;
        }


        // Fill in message fields
        qentry->t0 = call PumpTimer.getNow();
        qentry->tb = call Control.getMaxMessageBackoffPeriod();
        qentry->addr = addr;
        qentry->msg = msg;
        qentry->len = len;
        qentry->maxResend = call Control.getMaxResendCount();
        qentry->numResend = 0;
        // NOTICE: A constant backoff of half the backoff period
        //         minimizes the probability of a message with higher
        //         hop count to be received before the same message,
        //         but with a lower hop count value.
        if (qentry->tb < 2) {
            qentry->dt = 0;
        } else {
            qentry->dt = qentry->tb >> 1;
            qentry->dt +=
                call Random.rand32() % (qentry->tb / qentry->maxResend);
        }

        dbg("MessagePump|1", \
            "Message %x enqueued for transmission in " \
            "%u milliseconds starting from %u. [%s]\n", \
            qentry->msg, qentry->dt, qentry->t0, __FUNCTION__);

        dbgPrintMsgQueue();


        post taskSendMessages();


        return SUCCESS;
    }



    command error_t AMSend.cancel(message_t * msg) {
        // NOTICE: Since we do not use this method, we
        //         will not implement it.
        dbgerror("MessagePump|ERROR", \
            "Internal error: Function %s NOT IMPLEMENTED! [%s]\n", \
            __FUNCTION__, __FUNCTION__);
        return FAIL;
    }



    event void SubAMSend.sendDone(message_t * msg, error_t error) {
        queue_entry_t *   qentry;

        // Get the message from the queue.
        qentry = peekFirstMsg();

        // Assess the situation.
        if (qentry == NULL) {
            // Some error occurred.
            dbg("MessagePump|1", \
                "Error: Send done invoked for some non-existing " \
                "message %x. Perhaps the message queue was " \
                "cleaned before? [%s]\n", msg, __FUNCTION__);
            return;

        } else if (qentry->msg != msg) {
            // Another error.
            dbg("MessagePump|1", \
                "Error: Send done invoked for some message %x " \
                "different from the enqueued message %x [%s]. " \
                "Perhaps the message queue was cleaned before? [%s]\n", \
                msg, qentry->msg, __FUNCTION__);
            return;

        } else {
            // Everything is ok.
            dbg("MessagePump|1", \
                "Sending of message %x completed %s. [%s]\n", \
                msg, error == SUCCESS ? "successfully" : "UNSUCCESSFULLY", \
                __FUNCTION__);

            // Mark that we are no longer sending anything.
            sending = FALSE;

            // Check what to do with the message.
            ++qentry->numResend;
            if (qentry->numResend >= qentry->maxResend) {
                // Dequeue the message.
                dequeueMsg();
                // Signal message transmission.
                signal AMSend.sendDone(msg, error);
            } else {
                if (qentry->tb > 0) {
                    qentry->dt +=
                        call Random.rand32() % (qentry->tb / qentry->maxResend);
                }
                requeueMsg();
            }

            // Post the message transmission task.
            post taskSendMessages();
        }
    }



    command inline uint8_t AMSend.maxPayloadLength() {
        return call SubAMSend.maxPayloadLength();

    }


    command inline void * AMSend.getPayload(message_t * msg) {
        return call SubAMSend.getPayload(msg);
    }



    // ----------------------- Interface PumpTimer ------------------------
    event inline void PumpTimer.fired() {
        queue_entry_t *   qentry;
        error_t           error;

        dbg("MessagePump|1", \
            "Message transmission timer of a pump has fired. [%s]\n", \
            __FUNCTION__);

        // Get the message from the queue.
        qentry = peekFirstMsg();
        if (qentry == NULL) {
            // Nope.
            dbg("MessagePump|1", \
                "No message to be sent. [%s]\n", \
                __FUNCTION__);
            return;
        }

        // Check if we are sending anything.
        if (sending) {
            dbgerror("MessagePump|ERROR", \
                "Internal error! Sending a message, yet " \
                "the pump timer event has been invoked! [%s]\n", \
                __FUNCTION__);
            return;
        }

        // Try to transmit the message.
        error =
            call SubAMSend.send(
                qentry->addr, qentry->msg, qentry->len);

        if (error == SUCCESS) {
            // The message has been enqueued for
            // transmission by the lower layers,
            // so we wait till the send done even is invoked.

            dbg("MessagePump|1", \
                "Advert message %x passed to the lower layers. [%s]\n", \
                qentry->msg, __FUNCTION__);

            sending = TRUE;

        } else {
            // We were unable to enqueue the message
            // for transmission by lower layers.

            dbg("MessagePump|1", \
                "Failed to pass message %x to the lower layers " \
                "for transmission. [%s]\n", \
                qentry->msg, __FUNCTION__);

            ++qentry->numResend;
            if (qentry->numResend >= qentry->maxResend) {
                // Dequeue the message.
                dequeueMsg();
                // Signal an error to the users.
                signal AMSend.sendDone(qentry->msg, error);
            } else {
                if (qentry->tb > 0) {
                    qentry->dt +=
                        call Random.rand32() % (qentry->tb / qentry->maxResend);
                }
                requeueMsg();
            }

            // Post the message transmission task.
            post taskSendMessages();
        }
    }



    // ------------------------ Interface Control -------------------------
    command inline uint8_t Control.getNumMessages() {
        return numEntries;
    }



    command inline uint8_t Control.getMaxMessages() {
        return QUEUE_SIZE;
    }



    command inline void Control.emptyQueue() {
        queue_entry_t *   qentry;

        dbg("MessagePump|1", \
            "Emptying the pump queue for outgoing messages. [%s]\n", \
            __FUNCTION__);

        call PumpTimer.stop();

        qentry = dequeueMsg();
        while (qentry != NULL) {
            signal AMSend.sendDone(qentry->msg, ECANCEL);
            qentry = dequeueMsg();
        }

        sending = FALSE;

        dbg("MessagePump|1", \
            "The pump queue for outgoing messages " \
            "has been emptied. [%s]\n", \
            __FUNCTION__);
    }



    command uint32_t Control.getMaxMessageBackoffPeriod() {
        return maxMessageBackoffTime;
    }



    command void Control.setMaxMessageBackoffPeriod(uint32_t t) {
        dbg("MessagePump|1", \
            "Changing the maximal message backoff time from %u to " \
            "%u milliseconds. [%s]\n", \
            maxMessageBackoffTime, t, __FUNCTION__);
        maxMessageBackoffTime = t;
    }



    command uint8_t Control.getMaxResendCount() {
        return maxResendCount;
    }



    command void Control.setMaxResendCount(uint8_t n) {
        dbg("MessagePump|1", \
            "Changing the maximal resend count from %hhu to %hhu. [%s]\n", \
            maxResendCount, n, __FUNCTION__);
        maxResendCount = n;
    }



    // ------------------------------- Tasks ------------------------------
    task void taskSendMessages() {
        uint32_t   now;
        uint32_t   minRemainingTime;
        uint8_t    minRemainingIdx;
        uint8_t    i, j;

        // NOTICE: This task can be actually posted
        //         multiple times, but we do not care.
        //         We will always schedule our timer from
        //         the last task added to the queue.

        dbg("MessagePump|1", \
            "Scheduling transmission of a message. [%s]\n", \
            __FUNCTION__);

        // Check if we are sending anything.
        if (sending) {
            // Yes, so let's wait until sending is done.
            dbg("MessagePump|1", \
                "Currently sending a message. Scheduling " \
                "interrupted. [%s]\n", \
                __FUNCTION__);
            return;
        }

        // Check if there is anything to send.
        if (numEntries == 0) {
            // Nope.
            dbg("MessagePump|1", \
                "No message to be sent. Scheduling " \
                "interrupted. [%s]\n", \
                __FUNCTION__);
            return;
        }

        // Get the current time.
        now = call PumpTimer.getNow();

        dbg("MessagePump|2", \
            "  - Current time is %u.\n", now);

        dbgPrintMsgQueue();

        // Get the minimal value for the timer.
        i = firstIdx;
        minRemainingTime = 0xffffffff;
        minRemainingIdx = QUEUE_SIZE;
        for (j = 0; j < numEntries; ++j) {
	        uint32_t elapsed = now - entries[i].t0;
            if (elapsed >= entries[i].dt) {
                minRemainingTime = 0;
                minRemainingIdx = i;
                break;
            } else {
                uint32_t remaining = entries[i].dt - elapsed;
                if (remaining < minRemainingTime) {
                    minRemainingTime = remaining;
                    minRemainingIdx = i;
                }
            }
            i = (i + 1) % QUEUE_SIZE;
        }

        // ASSUMPTION: minRemainingIdx < QUEUE_SIZE

        dbg("MessagePump|2", \
            "  - Minimal remaining time is %u for entry index %hhu " \
            "(first index %hhu) with message %x.\n", \
            minRemainingTime, minRemainingIdx, firstIdx, \
            entries[minRemainingIdx].msg);

        // Move the minimal remaining time to the first entry
        // such that when dequeueing this entry, the minimal
        // remaining time will not longer be present in the queue.
        if (firstIdx != minRemainingIdx) {
            uint32_t t0 = entries[minRemainingIdx].t0;
            uint32_t dt = entries[minRemainingIdx].dt;
            entries[minRemainingIdx].t0 = entries[firstIdx].t0;
            entries[minRemainingIdx].dt = entries[firstIdx].dt;
            entries[firstIdx].t0 = t0;
            entries[firstIdx].dt = dt;
        }

        // (Re)start the timer.
        call PumpTimer.startOneShot(minRemainingTime);

        dbg("MessagePump|1", \
            "The transmission timer was (re)set to %u ms. [%s]\n", \
            minRemainingTime, __FUNCTION__);

        dbgPrintMsgQueue();
    }



    // ---------------------- Function implementations --------------------
    inline void dbgPrintMsgQueue() {
#ifdef TOSSIM
#ifndef TOSSIM_NO_DEBUG
        uint8_t i, j;

        dbg("MessagePump|1", "TX_QUEUE:");
        i = firstIdx;
        for (j = 0; j < numEntries; ++j) {
            uint32_t txTime = entries[i].t0 + entries[i].dt;
            dbg_clear("MessagePump|1", \
                " <i:%hhu,addr:%hu,len:%hhu,msg:%x,t0:%u,dt:%u,TX_TIME:%u>", \
                j, entries[i].addr, entries[i].len, entries[i].msg, \
                entries[i].t0, entries[i].dt, txTime);
            ++i;
            if (i >= QUEUE_SIZE) {
                i = 0;
            }
        }
        dbg_clear("MessagePump|1", "\n");
#endif
#endif
    }



    inline queue_entry_t * enqueueMsg() {
        queue_entry_t *  qentry;

        // Check if there is enough queue space.
        if (numEntries >= QUEUE_SIZE) {
            return NULL;
        }

        // Insert the message at the end of the queue.
        qentry = &(entries[(firstIdx + numEntries) % QUEUE_SIZE]);

        ++numEntries;

        return qentry;
    }



    inline queue_entry_t * peekFirstMsg() {
        if (numEntries == 0) {
            return NULL;
        }
        return &(entries[firstIdx]);
    }



    inline queue_entry_t * dequeueMsg() {
        queue_entry_t *  res;

        if (numEntries == 0) {
            return NULL;
        }

        res = &(entries[firstIdx]);

        ++firstIdx;
        if (firstIdx >= QUEUE_SIZE) {
            firstIdx = 0;
        }
        --numEntries;

        return res;
    }



    inline queue_entry_t * requeueMsg() {

        if (numEntries == 0) {
            return NULL;

        } else if (numEntries == 1) {
            return &(entries[firstIdx]);

        } else if (numEntries == QUEUE_SIZE) {
            // The queue is full, so we simply move
            // the first element to the back.
            queue_entry_t *  res;

            res = &(entries[firstIdx]);

            ++firstIdx;
            if (firstIdx >= QUEUE_SIZE) {
                firstIdx = 0;
            }

            return res;

        } else {
            // The queue is not full so we have to rewrite the entry.
            queue_entry_t *  res;
            queue_entry_t *  old;

            res = enqueueMsg();
            old = dequeueMsg();

            memcpy(res, old, sizeof(queue_entry_t));

            return res;
        }
    }

}
