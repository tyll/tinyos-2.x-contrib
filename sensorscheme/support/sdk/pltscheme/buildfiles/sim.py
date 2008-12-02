#! /usr/bin/python
from TOSSIM import *
import sys
import os
import random
from subprocess import *
# The number of nodes to use in the simulation
NUM = 15
# the duration that the simulation runs in seconds
DURATION = 100.0
# time at beginning of simulation to boot up the nodes
# the actual boot time is taken randomly within this duration
BOOT_TIME = DURATION / 10
# how large a noise trace should be used. The first 'NOISETRACE_LENGTH' entries are read
# from a trace file. Has impact on simulation startup speed and memory use
# should be 100 at least
NOISETRACE_LENGTH = 100

t = Tossim([])
r = t.radio ()

#generate the linkgain.out file from linkconfig.txt
os.system("java net.tinyos.sim.LinkLayerModel linkconfig.txt")

f = open("linkgain.out", "r")

lines = f.readlines()
for line in lines:
  s = line.split()
  if (len(s) > 0):
    if (s[0] == "gain"):
      r.add(int(s[1]), int(s[2]), float(s[3]))
#    elif s[0] == "noise":
#      r.setNoise(int(s[1]), float(s[2]), float(s[3]))

noise = open(os.environ["TOSDIR"] + "/lib/tossim/noise/meyer-heavy.txt", "r")
lines = noise.readlines()
n = NOISETRACE_LENGTH
for line in lines:
  str = line.strip()
  if (str != ""):
    val = int(str)
    for i in range(0, NUM - 1):
      t.getNode(i).addNoiseTraceReading(val)
    n-=1
    if n <= 0: break

for i in range(0, NUM - 1):
  print "Creating noise model for ",i;
  t.getNode(i).createNoiseModel()

for i in range(0, NUM - 1):
    tm = int(random.random() * BOOT_TIME * t.ticksPerSecond())
    t.getNode(i).bootAtTime(tm)
    print "Booting ", i, " at time ", tm

p = Popen('java net.tinyos.tools.SensorSchemeSymbolExpander', shell=True, bufsize=1,
	          stdin=PIPE, stdout=sys.stdout, close_fds=True)	
t.addChannel("SensorSchemePrint", p.stdin)

#t.addChannel("SensorSchemeDebug", sys.stdout)
#t.addChannel("SensorSchemeC", sys.stdout)
#t.addChannel("SensorSchemeRD", sys.stdout)
#t.addChannel("SensorSchemeWR", sys.stdout)
#t.addChannel("LedsC", sys.stdout)
#t.addChannel("AM", sys.stdout)
#t.addChannel("TossimPacketModelC", sys.stdout)
#t.addChannel("Packet", sys.stdout)
#t.addChannel("Boot", sys.stdout)
#t.addChannel("CollectionM", sys.stdout)

# do something interesting with a newly created SerialPacket
# note: this only works when tossim is compiled with sim-sf
sp = t.newSerialPacket()

th = Throttle(t, 1000)
th.initialize()
sf = SerialForwarder(9002)

while (DURATION  > t.time() / t.ticksPerSecond()):
  th.checkThrottle()
  sf.process()
  t.runNextEvent()

th.printStatistics()

print "Completed simulation."

