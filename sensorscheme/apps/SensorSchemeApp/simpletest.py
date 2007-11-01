from TOSSIM import *
from random import *
import sys

NUM_NODES = 10

t = Tossim([])
r = t.radio()

#f = open("simpletopo.txt", "r")
#lines = f.readlines()
#for line in lines:
#  s = line.split()
#  if (len(s) > 0):
#    print " ", s[0], " ", s[1], " ", s[2];
#    r.add(int(s[0]), int(s[1]), float(s[2]))
#
for i in range(NUM_NODES):
  for j in range(NUM_NODES):
    if i != j:
      r.add(i, j, uniform(-65, -50))

noise = open("meyer-heavy.txt", "r")
lines = noise.readlines()
for line in lines:
  str = line.strip()
  if (str != ""):
    val = int(str)
    for i in range(NUM_NODES):
      t.getNode(i).addNoiseTraceReading(val)

for i in range(NUM_NODES):
  print "Creating noise model for ",i;
  t.getNode(i).createNoiseModel()


for i in range(NUM_NODES):
  m = t.getNode(i);
  time = randint(t.ticksPerSecond(), 10 * t.ticksPerSecond())
  m.bootAtTime(time)
  print "Booting ", i, " at time ", time

print "Starting simulation."

t.addChannel("Boot", sys.stdout)
#t.addChannel("AM", sys.stdout)
#t.addChannel("Packet", sys.stdout)
#t.addChannel("TossimPacketModelC", sys.stdout)
#t.addChannel("TreeRouting", sys.stdout)
#t.addChannel("TestNetworkC", sys.stdout)
#t.addChannel("Route", sys.stdout)
#t.addChannel("PointerBug", sys.stdout)
#t.addChannel("PoolC", sys.stdout)
#t.addChannel("QueueC", sys.stdout)
#t.addChannel("Gain", sys.stdout)
#t.addChannel("Forwarder", sys.stdout)
#t.addChannel("LedsC", sys.stdout)
#t.addChannel("Traffic", sys.stdout)
#t.addChannel("Acks", sys.stdout)
t.addChannel("SensorSchemeC", sys.stdout)
t.addChannel("SensorSchemeRD", sys.stdout)
t.addChannel("SensorSchemeWR", sys.stdout)

while (t.time() < 1000 * t.ticksPerSecond()):
  t.runNextEvent()

print "Completed simulation."
        