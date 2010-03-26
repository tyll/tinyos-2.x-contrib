
from sim.evaluation.graph.packet.PacketGraph import *
from sim.evaluation.graph.trickle.TrickleGraph import *
from sim.evaluation.graph.contour.ContourGraph import *
from sim.evaluation.graph.hist.HistGraph import *

from sim.utils.helper import *

class GraphEvaluation:
    def __init__(self):
        pass

    def execute(self,
                sqr_nodes,
                connectivity,
                randomize_boot,
                sec_before_inject,
                sec_after_inject,
                inject_node,
                k,
                distance,
                filenamebase):

        logfilename = filenamebase + ".log"
        print "="*40
        print "Executing GraphEvaluation:"
        print "SQR(nodes)\t\t", sqr_nodes
        print "connectivity\t\t", connectivity
        print "randomize_boot\t\t", randomize_boot
        print "sec_before_inject\t", sec_before_inject
        print "sec_after_inject\t", sec_after_inject
        print "inject_node\t\t", inject_node
        print "k\t\t\t", k
        print "distance\t\t", distance
        print "logfilename\t\t", logfilename
        print "="*40


        # TrickleGraph shows it better
        # pg = PacketGraph()
        # pg.execute(sqr_nodes,
        #            connectivity,
        #            randomize_boot,
        #            sec_before_inject,
        #            sec_after_inject,
        #            inject_node,
        #            k,
        #            filenamebase)

        tg = TrickleGraph()
        tg.execute(sqr_nodes,
                   connectivity,
                   randomize_boot,
                   sec_before_inject,
                   sec_after_inject,
                   inject_node,
                   k,
                   distance,
                   filenamebase)

        cg = ContourGraph()
        cg.execute(sqr_nodes,
                   connectivity,
                   randomize_boot,
                   sec_before_inject,
                   sec_after_inject,
                   inject_node,
                   k,
                   distance,
                   filenamebase)

        hg = HistGraph()
        hg.execute(sqr_nodes,
                   connectivity,
                   randomize_boot,
                   sec_before_inject,
                   sec_after_inject,
                   inject_node,
                   k,
                   distance,
                   filenamebase)
