import sys

from TOSSIM import *
# make sure that $(TOSCONTRIB)/csau/misc/support/sdk/python
# is in your PYTHONPATH
from TossimHelp import *

t = Tossim([])
#sf = SerialForwarder(9002)
#throttle = Throttle(t, 10)

nodes = loadLinkModel(t, "topo.txt")
loadNoiseModel(t, "meyer.txt", nodes)

# Set debug channels
print "Setting debug channels..."
t.addChannel("App", sys.stdout);
#t.addChannel("LplTest", sys.stdout);
#t.addChannel("Cpm", sys.stdout);

#t.addChannel("CC2420Transmit", sys.stdout);
#t.addChannel("PowerCycle", sys.stdout);
#t.addChannel("CC2420Receive", sys.stdout);
#t.addChannel("CC2420Csma", sys.stdout);
#t.addChannel("CpmModelC", sys.stdout);


initializeNodes(t, nodes)
#sf.process();
#throttle.initialize();

print "Running simulation (press Ctrl-c to stop)..."
try:    
    while True:
#    for i in range(400):
#        throttle.checkThrottle();
        t.runNextEvent();
#        sf.process();

except KeyboardInterrupt:
  print "Closing down simulation!"
#  throttle.printStatistics() 
