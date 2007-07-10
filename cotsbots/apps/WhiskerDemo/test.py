#!/usr/bin/python2.4
from TOSSIM import *
import sys

t = Tossim([])
m = t.getNode(999)
m.bootAtTime(0)
t.addChannel("WhiskerDemo", sys.stdout)

t.runNextEvent()
t.runNextEvent()
t.runNextEvent()
t.runNextEvent()
m.trig(10)
t.runNextEvent()
t.runNextEvent()
t.runNextEvent()
t.runNextEvent()
