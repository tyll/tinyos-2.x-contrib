import sys

from TOSSIM import *

from sim.TrickleSimMsg import *
from sim.scenarios.RegularScenario import Scenario
from datetime import datetime

class SimulationRun:
    def __init__(self):
        print "New simulation run"
        self.t = Tossim([])
        self.t.setTime(0)
        self.t.init()
        print "time", self.t.timeStr()

    def execute(self, sqr_nodes, connectivity, randomize_boot,
                sec_before_inject, sec_after_inject,
                inject_node,
                filenamebase):

        starttime = datetime.now()

        logfilename = filenamebase + ".log"
        print "="*40
        print "Executing SimulationRun:"
        print "SQR(nodes)\t\t", sqr_nodes
        print "connectivity\t\t", connectivity
        print "randomize_boot\t\t", randomize_boot
        print "sec_before_inject\t", sec_before_inject
        print "sec_after_inject\t", sec_after_inject
        print "inject_node\t\t", inject_node
        print "logfilename\t\t", logfilename
        print "="*40


        # debug channels
        #self.t.addChannel("TrickleSimC", sys.stdout)
        #self.t.addChannel("Trickle", sys.stdout)
        #self.t.addChannel("TrickleTimes", sys.stdout)
        #self.t.addChannel("Boot", sys.stdout)

        f = open(logfilename, "w")
        self.t.addChannel("TrickleSimC", f)
        self.t.addChannel("Trickle", f)
        self.t.addChannel("TrickleTimes", f)
        self.t.addChannel("Boot", f)

        #scenario setup
        s = Scenario(self.t, sqr_nodes)
        s.setup_radio(connectivity)
        s.setup_boot(randomize=randomize_boot)

        #run
        while True:
            self.t.runNextEvent()
            if self.t.time() > sec_before_inject * self.t.ticksPerSecond():
                break

        msg = TrickleSimMsg()
        msg.set_counter(1);
        pkt = self.t.newPacket();
        pkt.setData(msg.data)
        pkt.setType(msg.get_amType())
        pkt.setDestination(inject_node)
        pkt.deliver(inject_node, self.t.time() + 3)
        print "Injected msg."

        while True:
            self.t.runNextEvent()
            if self.t.time() > (sec_before_inject + sec_after_inject) * self.t.ticksPerSecond():
                break

        f.close()

        # shut the motes off again, otherwise they aren't booted in
        # the next simulation. sic!
        for i in range(1, sqr_nodes*sqr_nodes+1):
            self.t.getNode(i).turnOff()

        print "Finished SimulationRun in", datetime.now()-starttime

#    def __del__(self):
#        print "Deleting TOSSIM object 2"
#        del(self.t)
#        print "Deleting TOSSIM object 3"
