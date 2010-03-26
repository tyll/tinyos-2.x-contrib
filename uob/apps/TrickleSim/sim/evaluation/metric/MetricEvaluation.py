
from sim.evaluation.metric.PacketMetric import *

from sim.utils.helper import *

class MetricEvaluation:
    def __init__(self):
        pass

    def execute(self,
                sqr_nodes,
                connectivity,
                randomize_boot,
                sec_before_inject,
                sec_after_inject,
                inject_node,
                distance,
                filenamebase):

        logfilename = filenamebase + ".log"
        print "="*40
        print "Executing MetricEvaluation:"
        print "SQR(nodes)\t\t", sqr_nodes
        print "connectivity\t\t", connectivity
        print "randomize_boot\t\t", randomize_boot
        print "sec_before_inject\t", sec_before_inject
        print "sec_after_inject\t", sec_after_inject
        print "inject_node\t\t", inject_node
        print "distance\t\t", distance
        print "logfilename\t\t", logfilename
        print "="*40


        pm = PacketMetric()
        pm.execute(sqr_nodes,
                   connectivity,
                   randomize_boot,
                   sec_before_inject,
                   sec_after_inject,
                   inject_node,
                   distance,
                   filenamebase)
