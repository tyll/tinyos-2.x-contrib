from tosvis import *
from random import random

###############################
class MyNode(Node):
    def animateAmSend(self,time,amtype,amlen,amdst):
        if amtype in MONITORED_AM:
            Node.animateAmSend(self,time,amtype,amlen,amdst)

    def animateAmRecv(self,time,amtype,amlen):
        if amtype in MONITORED_AM:
            Node.animateAmRecv(self,time,amtype,amlen)

###############################
tv = TosVis(100, showDebug=False)
MONITORED_AM = [0x71]

for x in range(4):
    for y in range(4):
        pos = (100+80*x+random()*40,100+80*y+random()*40)
        node = MyNode(pos, txRange=100)
        node.monitoredAm = MONITORED_AM
        tv.addNode(node)

tv.run()
