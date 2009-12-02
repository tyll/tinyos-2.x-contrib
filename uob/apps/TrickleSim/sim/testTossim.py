import sys

from TOSSIM import *

from sim.TrickleSimMsg import *
from sim.scenarios.RegularScenario import Scenario

class SimulationRun:
    def __init__(self):
        print "\n"
        print "="*50
        print "New simulation run"
        self.t = Tossim([])
        self.t.setTime(0)
        self.t.init()
        print "init time", self.t.timeStr()

    def execute(self, sqr_nodes, connectivity, randomize_boot):

        self.t.addChannel("Boot", sys.stdout)
        #self.t.addChannel("Queue", sys.stdout)
        #self.t.addChannel("Tossim", sys.stdout)
        #self.t.addChannel("SimMoteP", sys.stdout)

        #scenario setup
        s = Scenario(self.t, sqr_nodes)
        s.setup_radio(connectivity)
        s.setup_boot(randomize=randomize_boot)

        #run
        print "start time", self.t.timeStr()
        for i in range(1, 10):
            print ".",
            self.t.runNextEvent()

        print "time", self.t.timeStr()
        for i in range(1, sqr_nodes*sqr_nodes+1):
            self.t.getNode(i).turnOff()
        print "Finished SimulationRun."

    # def __del__(self):
    #     print "Deleting TOSSIM object 2"
    #     del(self.t)
    #     #del(Tossim)
    #     #print dir(Tossim)
    #     print "Deleting TOSSIM object 3"

if __name__ == "__main__":

    sr1 = SimulationRun()
    sr1.execute(2, 1, False)
    #del(sr1)

    sr2 = SimulationRun()
    sr2.execute(2, 1, False)
    #del(sr2)
