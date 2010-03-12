#!/usr/bin/env python

"""
Startup Runner for Simx Act/React.

@author Paul Stickney - Oct 2008
"""

import sys

from TOSSIM import Tossim
import SimxProbe

from simx.probe import Loader, Probe

tossim = Tossim([])
loader = Loader('app.xml', SimxProbe)

#tossim.addChannel("Tossim", sys.stdout)
#tossim.addChannel("TossimPacketModelC", sys.stdout)
#tossim.addChannel("SimMoteP", sys.stdout)
#tossim.addChannel("Gain", sys.stdout)
#tossim.addChannel("AM", sys.stdout)
#tossim.addChannel("Acks", sys.stdout)
#tossim.addChannel("Packet", sys.stdout)
#tossim.addChannel("Scheduler", sys.stdout)
#tossim.addChannel("Insert", sys.stdout)
#tossim.addChannel("HASH", sys.stdout)
#tossim.addChannel("NoiseAudit", sys.stdout)
#tossim.addChannel("Noise_c", sys.stdout)
#tossim.addChannel("Noise", sys.stdout)
#tossim.addChannel("Noise_output", sys.stdout)
#tossim.addChannel("HashZeroBug", sys.stdout)
#tossim.addChannel("SimMainP", sys.stdout)
#tossim.addChannel("Queue", sys.stdout)
#tossim.addChannel("CpmModelC", sys.stdout)
#tossim.addChannel("PlatformC", sys.stdout)
#tossim.addChannel("Serial", sys.stdout)
#tossim.addChannel("CpmModelC,SNRLoss", sys.stdout)
#tossim.addChannel("Gain,SNRLoss", sys.stdout)
#tossim.addChannel("Binary", sys.stdout)


# init
nodes = []
probes = []
COUNT = 10
for n in xrange(0, COUNT):
    node = tossim.getNode(n)
    # boot evenly across one second
    node.bootAtTime(0 + (float(n) / (COUNT + 1)) * tossim.ticksPerSecond())
    probe = loader.lookup("ProbeTestC$nx_struct_data",
                          ["", "nx_varied_struct_t"]).bind(n)
    probe.memo().event_count = 0

    nodes.append(node)
    probes.append(probe)


def check_update(probe):
    # keep in-sync with updates..
    memo = probe.memo()
    memo.event_count += 1
    # only odd probes update!
    assert probe.node % 2, "odd node (but was %s)" % probe.node
    # and check update value
    assert probe["uint16"] == memo.event_count * probe.node


def test_live_batch():
    end_time = tossim.time() + 5 * tossim.ticksPerSecond()

    while tossim.time() < end_time:
        # ensure simulation is run in some form of batches so that
        # sync_shadows can queue multiple buffers, as long as the
        # batches are less than a second it won't skip writes in the
        # ProbeTest code.
        target = tossim.time() + (0.8 * tossim.ticksPerSecond())
        while tossim.time() < target:
            tossim.runNextEvent()

        dirty = Probe.synchronize_all(probes)
#        assert len(dirty) > 1, "len(dirty) > 1, was %d" % len(dirty)
        for probe in dirty:
            check_update(probe)
 

def test_live_single():
    end_time = tossim.time() + 5 * tossim.ticksPerSecond()

    while tossim.time() < end_time:
        tossim.runNextEvent()

        # this approach will only ever yield a list of zero or one
        # items because only a single event runs at a time under the
        # TOSSIM model
        dirty = Probe.synchronize_all(probes)
        assert len(dirty) <= 1
        for probe in dirty:
            check_update(probe)
