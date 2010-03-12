from TOSSIM import *
t = Tossim([])

from SimxTxPower import TxPower

def power_change (mote, power):
    print "Mote %d changed power to %d" % (mote, power)

def power_inspect (mote):
    print "Mote %d inspected power" % mote

tx = TxPower();
tx.setChangeFunction(power_change);
tx.setInspectFunction(power_inspect);

n = t.getNode(0)
n.bootAtTime(0)

#n = t.getNode(1)
#n.bootAtTime(250)

r = range(0,100)
for z in r:
    t.runNextEvent()
