#! /usr/bin/python

import os

from optparse import OptionParser

from sim.run.SimulationRun import *
from sim.evaluation.graph.GraphEvaluation import *
from sim.evaluation.metric.MetricEvaluation import *

class SimulationSuite:
    def __init__(self):
        self.sec_before_inject = 10
        self.sec_after_inject  = 300
        self.inject_node       = 1

        #self.sqr_nodes_list    = [2, 5]
        #self.sqr_nodes_list    = [2]
        #self.sqr_nodes_list    = [5]
        #self.sqr_nodes_list    = [20]
        #self.sqr_nodes_list    = [2, 3, 4, 5, 6, 7, 8, 9, 10]
        self.sqr_nodes_list    = [2, 5, 10, 20]

        #self.connectivity_list = [1]
        #self.connectivity_list = [1, 2, 3]
        #self.connectivity_list = [1, 1.5, 2, 3]
        #self.connectivity_list = [1, 1.5, 2, 3, 4, 5, 6]
        #self.connectivity_list = []

        #self.distance_list     = [1, 2, 5, 10]
        #self.distance_list     = [20, 50, 100]
        #self.distance_list     = [1, 2.5, 5, 7.5, 10, 25, 50, 75, 100]
        self.distance_list     = [105, 110, 115, 120, 125]

        self.randomize_boot    = True
        self.randomize_seed    = True

        #self.k                 = 0 # NEEDS to BE SETTED MANUALLY
        self.k                 = 1 # NEEDS to BE SETTED MANUALLY

    def createfilenamebase(self,
                           sqr_nodes,
                           connectivity,
                           randomize_boot,
                           sec_before_inject,
                           sec_after_inject,
                           inject_node,
                           distance):
        return "sim/output/trickle_"\
            + str(sqr_nodes) + "_" \
            + str(sqr_nodes) + "_d" \
            + str(distance)
#            + str(connectivity)

    def execute(self):
        for sqr_nodes in self.sqr_nodes_list:
            #for connectivity in self.connectivity_list:
            for distance in self.distance_list:

                cmd = "python sim/run/SimulationRun.py" + \
                    " -s " + str(sqr_nodes) + \
                    " -d " + str(distance)
#                    " -c " + str(connectivity)

                if self.randomize_boot:
                    cmd = cmd + " -b"

                if self.randomize_seed:
                    cmd = cmd + " -r"

                cmd = cmd + \
                    " -i " + str(self.sec_before_inject) + \
                    " -a " + str(self.sec_after_inject) + \
                    " -n " + str(self.inject_node) + \
                    " -f " + self.createfilenamebase(sqr_nodes,
                                                     "XXX",
                                                     self.randomize_boot,
                                                     self.sec_before_inject,
                                                     self.sec_after_inject,
                                                     self.inject_node,
                                                     distance)
                print "Executing:", cmd
                os.system(cmd)

    #FIXME: evaluate could run in another thread
    def evaluate(self):
        for sqr_nodes in self.sqr_nodes_list:
            #for connectivity in self.connectivity_list:
            for distance in self.distance_list:

                me = MetricEvaluation()
                me.execute(sqr_nodes,
                           "XXX",
                           self.randomize_boot,
                           self.sec_before_inject,
                           self.sec_after_inject,
                           self.inject_node, # FIXME: add self.k
                           distance,
                           self.createfilenamebase(sqr_nodes,
                                                   "XXX",
                                                   self.randomize_boot,
                                                   self.sec_before_inject,
                                                   self.sec_after_inject,
                                                   self.inject_node,
                                                   distance))

                ge = GraphEvaluation()
                ge.execute(sqr_nodes,
                           "XXX",
                           self.randomize_boot,
                           self.sec_before_inject,
                           self.sec_after_inject,
                           self.inject_node,
                           self.k,
                           distance,
                           self.createfilenamebase(sqr_nodes,
                                                   "XXX",
                                                   self.randomize_boot,
                                                   self.sec_before_inject,
                                                   self.sec_after_inject,
                                                   self.inject_node,
                                                   distance))


if __name__ == "__main__":
    optparser = OptionParser()
    optparser.add_option("-s",
                         "--simulation",
                         action="store_true",
                         default=False,
                         help="Just do simulation")
    optparser.add_option("-e",
                         "--evaluation",
                         action="store_true",
                         default=False,
                         help="Just do the evaluation (based on data from previous run)")

    (optionsp, argsp) = optparser.parse_args()

    ss = SimulationSuite()

    if not optionsp.evaluation:
        print "!"*40
        print "Starting Simulations"
        print "!"*40
        ss.execute()
        print "!"*40
        print "Finished Simulations"
        print "!"*40

    if not optionsp.simulation:
        print "!"*40
        print "Starting Evaluation"
        print "!"*40
        ss.evaluate()
        print "!"*40
        print "Finished Evaluation"
        print "!"*40

