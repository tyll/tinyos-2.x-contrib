#! /usr/bin/python
from TOSSIM import *
import sys
import os
import random
# The number of nodes to use in the simulation
NUM = 9
# the duration that the simulation runs in seconds
DURATION = 100.0
# time at beginning of simulation to boot up the nodes
# the actual boot time is taken randomly within this duration
BOOT_TIME = DURATION / 10

t = Tossim([])
r = t.radio ()

f = open("../linkgain.out", "r")

lines = f.readlines()
for line in lines:
  s = line.split()
  if (len(s) > 0):
    if (s[0] == "gain"):
      r.add(int(s[1]), int(s[2]), float(s[3]))
    elif s[0] == "noise":
      r.setNoise(int(s[1]), float(s[2]), float(s[3]))

noise = open(os.environ["TOSDIR"] + "/lib/tossim/noise/meyer-heavy.txt", "r")
lines = noise.readlines()
for line in lines:
  str = line.strip()
  if (str != ""):
    val = int(str)
    for i in range(1, NUM):
      t.getNode(i).addNoiseTraceReading(val)

for i in range(1, NUM):
  print "Creating noise model for ",i;
  t.getNode(i).createNoiseModel()

for i in range(1, NUM):
    t.getNode(i).bootAtTime(random.random() * BOOT_TIME * t.ticksPerSecond())
    print "Booting ", i, " at time ", t.time()

t.addChannel("SensorSchemeC", sys.stdout)
t.addChannel("Boot", sys.stdout)

# do something interesting with a newly created SerialPacket
# note: this only works when tossim is compiled with sin-sf
sp = t.newSerialPacket()

th = Throttle(t, 1000)
th.initialize()
sf = SerialForwarder(9009)

while (DURATION  > t.time() / t.ticksPerSecond()):
  th.checkThrottle()
  sf.process()
  t.runNextEvent()

th.printStatistics()

print "Completed simulation."
