import sys
import time

from TOSSIM import *
from TossimHelp import *

t = Tossim([])
sf = SerialForwarder(9002)
throttle = Throttle(t, 10)
nodecount = loadLinkModel(t, "linkgain.out")
loadNoiseModel(t, "meyer.txt", nodecount)

# Set debug channels
print "Setting debug channels..."
t.addChannel("printf", sys.stdout);
t.addChannel("UB.debug", sys.stdout);
t.addChannel("UB.error", sys.stdout);

t.addChannel("DebugSender.error", sys.stdout)

initializeNodes(t, nodecount)
sf.process();
throttle.initialize();

print "Running simulation (press Ctrl-c to stop)..."
try:
    while True:
        throttle.checkThrottle();
        t.runNextEvent();
        sf.process();
except KeyboardInterrupt:
  print "Closing down simulation!"
  #throttle.printStatistics() 
