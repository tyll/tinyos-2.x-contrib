import TOSSIM
import sys

t = TOSSIM.Tossim([])
m = t.mac();
r = t.radio();
ff = t.newFireEstimator();
t.init()

t.addChannel("FireSim",sys.stdout);

print (dir(TOSSIM.Tossim))

f=open("ignitionTimes","r")
lines=f.readlines()
for line in lines:
  s=line.split()
  if(len(s)>0):
    for i in range(0,13):
      ff.setIgnition(int(s[i]));


f=open("grid13x13","r")
lines=f.readlines()
for line in lines:
  s=line.split()
  if(len(s)>0):
    for i in range(0,13):
      ff.setGrid(int(s[i]));


f = open("fire-gain.out", "r")
lines = f.readlines()
for line in lines:
  s = line.split()
  if (len(s) > 0):
    if (s[0] == "gain"):
      r.add(int(s[1]), int(s[2]), float(s[3]))
    elif (s[0] == "noise"):
      r.setNoise(int(s[1]), float(s[2]), float(s[3]))


for i in range(1, 100): 
  m = t.getNode(i);
  m.bootAtTime(0);

time_val=t.time()
while (time_val+1*3600*t.ticksPerSecond() > t.time()):
  t.runNextEvent()

print "Completed simulation for",t.time()/t.ticksPerSecond(),"sec."
