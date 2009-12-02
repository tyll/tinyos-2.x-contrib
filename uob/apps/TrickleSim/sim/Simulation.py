#! /usr/bin/python

from optparse import OptionParser

from sim.run.SimulationRun import *
from sim.evaluation.graph.GraphEvaluation import *
from sim.evaluation.metric.MetricEvaluation import *

class SimulationSuite:
    def __init__(self):
        self.sec_before_inject = 10
        self.sec_after_inject  = 300
        self.inject_node       = 1
        #self.sqr_nodes_list    = [2, 3, 4, 5, 6, 7, 8, 9, 10]
        self.sqr_nodes_list    = [2, 5, 10, 20]
        #self.sqr_nodes_list    = [2, 5]
        self.connectivity_list = [1, 2]
        self.randomize_boot    = True

    def createfilenamebase(self,
                           sqr_nodes,
                           connectivity,
                           randomize_boot,
                           sec_before_inject,
                           sec_after_inject,
                           inject_node):
        return "sim/output/trickle_"\
            + str(sqr_nodes) + "_" \
            + str(sqr_nodes) + "_" \
            + str(connectivity)

    def execute(self):
        for sqr_nodes in self.sqr_nodes_list:
            for connectivity in self.connectivity_list:
                # FIXME: use connectivity to show scaling with denseness
                sr = SimulationRun()
                sr.execute(sqr_nodes,
                           connectivity,
                           self.randomize_boot,
                           self.sec_before_inject,
                           self.sec_after_inject,
                           self.inject_node,
                           self.createfilenamebase(sqr_nodes,
                                                   connectivity,
                                                   self.randomize_boot,
                                                   self.sec_before_inject,
                                                   self.sec_after_inject,
                                                   self.inject_node))

                del(sr)

    def evaluate(self):
        for sqr_nodes in self.sqr_nodes_list:
            for connectivity in self.connectivity_list:

                me = MetricEvaluation()
                me.execute(sqr_nodes,
                           connectivity,
                           self.randomize_boot,
                           self.sec_before_inject,
                           self.sec_after_inject,
                           self.inject_node,
                           self.createfilenamebase(sqr_nodes,
                                                   connectivity,
                                                   self.randomize_boot,
                                                   self.sec_before_inject,
                                                   self.sec_after_inject,
                                                   self.inject_node))

                ge = GraphEvaluation()
                ge.execute(sqr_nodes,
                           connectivity,
                           self.randomize_boot,
                           self.sec_before_inject,
                           self.sec_after_inject,
                           self.inject_node,
                           self.createfilenamebase(sqr_nodes,
                                                   connectivity,
                                                   self.randomize_boot,
                                                   self.sec_before_inject,
                                                   self.sec_after_inject,
                                                   self.inject_node))


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

