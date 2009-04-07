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
#include "LinkEstimator.h"


/**
 * The configuration for the link estimator component of the networking
 * stack.
 *
 * This component can be plugged to whatever number of stacks is
 * appropriate. The only requirement is that all packets send by nodes
 * must be received by all other nodes within the range. In other words,
 * the link estimator component must be either plugged to a snooping
 * receiver, or all packets in the stack must be send to a broadcast
 * address.
 *
 * @author Konrad Iwanicki &lt;iwanicki@few.vu.nl&gt;
 */
configuration LinkEstimatorC {
    provides {
        interface Init;

        interface LinkEstimatorConfig as Config;
        interface NeighborTable;
        interface Iterator<neighbor_iter_t, neighbor_t>
            as NeighborTableIter;
        interface LinkEstimatorControl;

        interface Packet;
        interface AMPacket;
        interface AMSend;
        interface Receive as SnoopAndReceive;

        interface TOSSIMStats;
    }
    uses {
        interface Packet as SubPacket;
        interface AMPacket as SubAMPacket;
        interface AMSend as SubAMSend;
        interface Receive as SubSnoopAndReceive;
        interface Sequencing as SubSequencing;
        interface SequencingPacket as SubSequencingPacket;
    }
}
implementation {
    components LinkEstimatorP;

    Init = LinkEstimatorP.Init;
    Config = LinkEstimatorP.Config;
    NeighborTable = LinkEstimatorP.NeighborTable;
    NeighborTableIter = LinkEstimatorP.NeighborTableIter;
    LinkEstimatorControl = LinkEstimatorP.LinkEstimatorControl;
    Packet = LinkEstimatorP.Packet;
    AMPacket = SubAMPacket;
    AMSend = LinkEstimatorP.AMSend;
    SnoopAndReceive = LinkEstimatorP.SnoopAndReceive;
    TOSSIMStats = LinkEstimatorP.TOSSIMStats;

    LinkEstimatorP.SubPacket = SubPacket;
    LinkEstimatorP.SubAMPacket = SubAMPacket;
    LinkEstimatorP.SubAMSend = SubAMSend;
    LinkEstimatorP.SubSnoopAndReceive = SubSnoopAndReceive;
    LinkEstimatorP.SubSequencing = SubSequencing;
    LinkEstimatorP.SubSequencingPacket = SubSequencingPacket;

}

