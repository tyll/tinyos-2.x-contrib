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
 * The container for the traffic stats. Stores the actual statistics.
 *
 * @author Konrad Iwanicki &lt;iwanicki@few.vu.nl&gt;
 */
generic module TrafficStatsContainerC() {
    provides {
        interface Statistics<traffic_stats_outgoing_stats_t> as OutgoingTrafficStats;
        interface Statistics<traffic_stats_incoming_stats_t> as IncomingTrafficStats;
    }
}
implementation {

    // ------------------------- Private members --------------------------
    /** the statistics for the outgoing traffic */
    traffic_stats_outgoing_stats_t    statsOutgoing = {
        schedMessages : 0,
        schedBytes : 0,
        txedMessages : 0,
        txedBytes : 0,
    };


    /** the statistics for the incoming traffic */
    traffic_stats_incoming_stats_t    statsIncomming = {
        rxedMessages : 0,
        rxedBytes : 0,
    };



    // ----------------- Interface OutgoingTrafficStats -------------------
    command inline traffic_stats_outgoing_stats_t * OutgoingTrafficStats.getStats() {
        return &statsOutgoing;
    }



    command inline void OutgoingTrafficStats.clearStats() {
        statsOutgoing.schedMessages = 0;
        statsOutgoing.schedBytes = 0;
        statsOutgoing.txedMessages = 0;
        statsOutgoing.txedBytes = 0;
    }



    command inline traffic_stats_outgoing_stats_t * OutgoingTrafficStats.copyAndClearStats(
            traffic_stats_outgoing_stats_t * res) {
        memcpy(res, &statsOutgoing, sizeof(traffic_stats_outgoing_stats_t));
        call OutgoingTrafficStats.clearStats();
    }



    // ----------------- Interface IncomingTrafficStats -------------------
    command inline traffic_stats_incoming_stats_t * IncomingTrafficStats.getStats() {
        return &statsIncomming;
    }



    command inline void IncomingTrafficStats.clearStats() {
        statsIncomming.rxedMessages = 0;
        statsIncomming.rxedBytes = 0;
    }



    command inline traffic_stats_incoming_stats_t * IncomingTrafficStats.copyAndClearStats(
            traffic_stats_incoming_stats_t * res) {
        memcpy(res, &statsIncomming, sizeof(traffic_stats_incoming_stats_t));
        call IncomingTrafficStats.clearStats();
    }

}
