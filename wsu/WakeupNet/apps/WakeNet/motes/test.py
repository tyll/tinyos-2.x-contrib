#! /usr/bin/python
from TOSSIM import *
from TOSSIM import SerialForwarder
import sys

t = Tossim([])
r = t.radio()
f = open("topo_8.txt", "r")
nodeNum = 9
lines = f.readlines()
for line in lines:
  s = line.split()
  if (len(s) > 0):
    print " ", s[0], " ", s[1], " ", s[2];
    r.add(int(s[0]), int(s[1]), float(0.0))

#t.addChannel("TreeRouting", sys.stdout)
#t.addChannel("Error",sys.stdout)
#t.addChannel("Ack",sys.stdout)
t.addChannel("CDS",sys.stdout)
t.addChannel("function",sys.stdout)
if(0):
	t.addChannel("function",sys.stdout)
	f1= open("./result/transmission.txt","w")
	f2= open("./result/receive.txt","w")
	f3= open("./result/lossratio.txt","w")
	f4= open("./result/repeat.txt","w")
	f5= open("./result/time.txt","w")
	result= open("./result/resutl.txt","w")
	nodeP=open("./result/nodeP.txt","w");
	setupCost=open("./result/setupCost.txt","w");
	dataCost=open("./result/dataCost.txt","w");
	t.addChannel("Result",result)
	t.addChannel("f2",f2)
	t.addChannel("f3",f3)
	t.addChannel("f4",f4)
	t.addChannel("f5",f5)
	t.addChannel("nodeP",nodeP)
	t.addChannel("setupCost",setupCost)
	t.addChannel("dataCost",dataCost)
	t.addChannel("Boot", sys.stdout)
#t.addChannel("Neighbor", sys.stdout)
noise = open("meyer-heavy.txt", "r")
lines = noise.readlines()
for line in lines:
  str = line.strip()
  if (str != ""):
    val = int(str)
    for i in range(0, nodeNum):
      t.getNode(i).addNoiseTraceReading(-115)

for i in range(0, nodeNum):
  print "Creating noise model for ",i;
  t.getNode(i).createNoiseModel()

#t.getNode(0).bootAtTime(200001);

for i in range(0, nodeNum):
	t.getNode(i).bootAtTime(1000+10*i%3+10*i%5);

sf = SerialForwarder(9002)

while (t.time() < 900000 * t.ticksPerSecond()) :
#for i in range(0, 100000000):
  t.runNextEvent()
  sf.process()
print "Terminate at" + t.timeStr() 


