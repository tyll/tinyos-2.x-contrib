#! /usr/bin/python

from optparse import OptionParser

import sys

from TOSSIM import *
from tinyos.tossim.TossimApp import *

from sim.TrickleSimMsg import *
#from sim.scenarios.RegularScenario import Scenario
from sim.scenarios.RegularScenarioWithPropagationModel import Scenario
from datetime import datetime

class SimulationRun:
    def __init__(self):
        print "New simulation run"
        self.t = Tossim([])
        self.t.setTime(0)
        self.t.init()
        print "time", self.t.timeStr()

    def execute(self, sqr_nodes, connectivity,
                randomize_boot, randomize_seed,
                sec_before_inject, sec_after_inject,
                inject_node,
                distance,
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
        print "distance\t\t", distance
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
        #s = Scenario(self.t, sqr_nodes)
        s = Scenario(self.t, sqr_nodes, distance)
        #s.setup_radio(connectivity)
        s.setup_radio()
        s.setup_boot(randomize=randomize_boot, randomseed=randomize_seed)

        #print "Max. Neighbors", s.max_neigh
        #print "Ticks per Seconds", self.t.ticksPerSecond()

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

if __name__ == "__main__":
    optparser = OptionParser()

    optparser.add_option("-s",
                         "--sqr_nodes",
                         type="int",
                         default=2,
                         help="Number of nodes in 1 dimension (Square root of 2D)")

    optparser.add_option("-c",
                         "--connectivity",
                         type="float",
                         default=1,
                         help="Maximum Distance to connect to neighbors.")

    optparser.add_option("-b",
                         "--randomize_boot",
                         action="store_true",
                         help="Randomize the boot sequence.")

    optparser.add_option("-r",
                         "--randomize_seed",
                         action="store_true",
                         help="Randomize the seed sequence.")

    optparser.add_option("-i",
                         "--before-inject",
                         type="float",
                         default=10,
                         help="Seconds to wait before injecting the update.")

    optparser.add_option("-a",
                         "--after-inject",
                         type="float",
                         default=300,
                         help="Seconds to wait after injecting the update.")

    optparser.add_option("-n",
                         "--node",
                         type="int",
                         default=1,
                         help="The node to inject the message at.")

    optparser.add_option("-d",
                         "--distance",
                         type="float",
                         default=1,
                         help="Distance between nodes.")

    optparser.add_option("-f",
                         "--filenamebase",
                         action="store",
                         help="The prefix for the output files.")

    (optionsp, argsp) = optparser.parse_args()

    if not optionsp.filenamebase:
        optparser.print_help()
        sys.exit(-1)

    sr = SimulationRun()
    sr.execute(optionsp.sqr_nodes,
               optionsp.connectivity,
               optionsp.randomize_boot,
               optionsp.randomize_seed,
               optionsp.before_inject,
               optionsp.after_inject,
               optionsp.node,
               optionsp.distance,
               optionsp.filenamebase)
