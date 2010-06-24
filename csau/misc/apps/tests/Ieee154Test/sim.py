import sys
import time

from TOSSIM import *
# make sure that $(TOSCONTRIB)/csau/misc/support/sdk/python
# is in your PYTHONPATH
from TossimHelp import *

t = Tossim([])
#sf = SerialForwarder(9002)
#throttle = Throttle(t, 10)
link = 0
nodes = loadLinkModel(t, "linkgain.out")
loadNoiseModel(t, "meyer.txt", nodes)

# Set debug channels
print "Setting debug channels..."
#t.addChannel("LI", sys.stdout);
t.addChannel("printf", sys.stdout);
#t.addChannel("Ieee154", sys.stdout);

initializeNodes(t, nodes)
#sf.process();
#throttle.initialize();

print "Running simulation (press Ctrl-c to stop)..."
try:
    for i in range(0,500):
        t.runNextEvent();
except KeyboardInterrupt:
  print "Closing down simulation!"
  #throttle.printStatistics() 
