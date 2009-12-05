from TOSSIM import *
t = Tossim([])

from SimxPushback import Pushback 

def power_change (mote, power):
    print "Mote %d changed power to %d" % (mote, power)

def power_inspect (mote):
    print "Mote %d inspected power" % mote
    return 12

tx = Pushback();
tx.addPythonPushback("txpower.set(ll)l", "(ll)", power_change);
tx.addPythonPushback("txpower.get(l)l", "(l)", power_inspect);

n = t.getNode(0)
n.bootAtTime(0)

n = t.getNode(1)
n.bootAtTime(250)

r = range(0,500)
for z in r:
    t.runNextEvent()
