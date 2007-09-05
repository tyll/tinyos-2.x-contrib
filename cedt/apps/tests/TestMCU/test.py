from TOSSIM import *
from random import *
import sys

t = Tossim([])
r = t.radio()
em = t.newEnergyEstimator();
f = open("topo.txt", "r")

lines = f.readlines()
for line in lines:
  s = line.split()
  if (len(s) > 0):
    print " ", s[0], " ", s[1], " ", s[2];
    r.add(int(s[0]), int(s[1]), float(s[2]))

for i in range(0, 2):
  m = t.getNode(i);
  time = randint(t.ticksPerSecond()/16,t.ticksPerSecond()/8)
  m.bootAtTime(time)
  print "Booting ", i, " at time ", time


noise = open("rssi-log-mica2.txt", "r")
lines = noise.readlines()
for line in lines:
	str = line.strip()
	if (str != ""):
		val = float(str)
		for i in range(0, 2):
			t.getNode(i).addNoiseTraceReading(int(val))

for i in range(0, 2):
	print "Creating noise model for ",i;
	t.getNode(i).createNoiseModel()

t.addChannel("LedsC",sys.stdout);
t.addChannel("McuSleepC",sys.stdout);
#t.addChannel("HplCC1000P",sys.stdout);
#t.addChannel("HplCC1KSpiWrite",sys.stdout);
#t.addChannel("HplCC1KSpiRead",sys.stdout);
#t.addChannel("HplCC1000Spi",sys.stdout);
#t.addChannel("HplCC1000SpiP",sys.stdout);
#t.addChannel("CC1000SendReceiveP",sys.stdout);
#t.addChannel("HplAtm128AdcP",sys.stdout);
#t.addChannel("CC1000CsmaP",sys.stdout);

t.runNextEvent();
time = t.time();

print t.ticksPerSecond();
#simulate for Min * Sec * ticksPerSecond  seconds 

while(time+2*60*t.ticksPerSecond() > t.time()) :
    t.runNextEvent()

for i in range(0,2):
	em.getNodeEnergy(i);

print "Completed simulation for",t.time()/t.ticksPerSecond(),"sec.",t.time(); 


