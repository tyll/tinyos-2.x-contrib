#! /usr/bin/python
from TOSSIM import *
from random import *
import sys
import time

# Simulation variables
SIM_TIME = 300 # Simulation time in seconds
SIM_NODES = 6 # Number of nodes, named from 0 to SIM_NODES-1
SIM_TYPE = "lab" # Level of simulation fidelity (available: lab, outdoor)
TEST_DEBUG_CHANNEL = ["TESTWMTP"] # Debug channels: "TESTWMTP", "REPORTER", "WMTP"
TEST_TOPOLOGY_FILE = "tossim/topologies/" + str(SIM_NODES) + "-all-" + SIM_TYPE + ".txt"
TEST_NOISE_FILE = "tossim/noise/meyer-short.txt"

# Load TOSSIM and activate radio
t = Tossim([])
r = t.radio()

# Add debugging channels
for i in range(0, len(TEST_DEBUG_CHANNEL)):
	t.addChannel(TEST_DEBUG_CHANNEL[i], sys.stdout)

# Create network topology by linking nodes
f = open(TEST_TOPOLOGY_FILE, "r")
print "Creating network topology"
lines = f.readlines()
for line in lines:
  s = line.split()
  if (len(s) > 0):
    print " node", s[0], "-> node", s[1], "(Path gain:", s[2], "dBm)";
    r.add(int(s[0]), int(s[1]), float(s[2]))

# CPM
print "Creating noise model"
noise = open(TEST_NOISE_FILE, "r")
lines = noise.readlines()
for line in lines:
  str = line.strip()
  if (str != ""):
    val = int(str)
    for i in range(0, SIM_NODES):
      t.getNode(i).addNoiseTraceReading(val)

# Create noise model
for i in range(0, SIM_NODES):
  t.getNode(i).createNoiseModel()
  print " Noise model created for node",i;

# Boot nodes
print "Booting nodes"
for i in range(0, SIM_NODES):
	timeToBoot = i * t.ticksPerSecond()
	t.getNode(i).bootAtTime(timeToBoot)
	print " Booted node", i, "at time", i, "s";

# Run for a while
print "Starting simulation (Duration:", SIM_TIME, "s)";
end = t.time() + SIM_TIME * t.ticksPerSecond()
while (t.time() < end):
  t.runNextEvent()

print "Completed simulation."
