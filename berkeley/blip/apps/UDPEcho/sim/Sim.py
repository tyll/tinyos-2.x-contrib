#!/usr/bin/env python

import sys
import time

sys.path.append("..")

if sys.version < '2.5':
     print "Python version 2.5 required (for some reason).  You have", sys.version
     sys.exit(1)

from TOSSIM import *

t = Tossim([])
m = t.mac()
r = t.radio()
sf = SerialForwarder(9001)
# throttle = Throttle(t, 1)

# t.addChannel("Serial", sys.stdout)
# t.addChannel("Packet", sys.stdout)
# t.addChannel("printf", sys.stdout)
# t.addChannel("base", sys.stdout)
# t.addChannel("AM", sys.stdout)
t.addChannel("SNRLoss", sys.stdout)

motes = {}

if len(sys.argv) < 2:
     print "Usage: %s <topology>" % sys.argv[0]
     sys.exit(1)
     
topo = open(sys.argv[1], "r")
lines = topo.readlines()
for line in lines:
     s = line.split()
     if s[0] == 'gain':
          r.add(int(s[1]), int(s[2]), float(s[3]))
          motes[int(s[1])] = 1
          motes[int(s[2])] = 1

noise = open("meyer-heavy.txt", "r")
lines = noise.readlines()
for line in lines[0:10000]:
    str = line.strip()
    if (str != ""):
        val = int(str)
        for i in motes.keys():
            t.getNode(i).addNoiseTraceReading(val)
noise.close()

for i in motes.keys():
    print "Creating noise model for ",i;
    t.getNode(i).createNoiseModel()

for i in motes.keys():
    print "Adding mote", i
    m = t.getNode(i);
    m.bootAtTime((31 + t.ticksPerSecond() / 10) * i + 1)

sf.process()
# throttle.initialize()

while True:
    # throttle.checkThrottle()
    t.runNextEvent()
    sf.process()
