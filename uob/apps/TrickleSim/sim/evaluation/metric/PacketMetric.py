#!/usr/bin/env python

import numpy as np
import re

from sim.utils.helper import *

class PacketMetric:
    def __init__(self):
        pass

    def execute(self,
                sqr_nodes,
                connectivity,
                randomize_boot,
                sec_before_inject,
                sec_after_inject,
                inject_node,
                filenamebase):

        print "="*40
        print "Executing PacketMetric:"
        print "filenamebase\t\t", filenamebase
        print "="*40

        node_re = 'DEBUG \((\d+)\):'
        node_re_c = re.compile(node_re)
        time_re = '(\d+):(\d+):(\d+.\d+)'
        time_re_c = re.compile(time_re)

        packets = np.zeros((sqr_nodes*sqr_nodes+1))

        f = open(filenamebase+".log", "r")
        for line in f:
            if line.find("TrickleSimC: sending packet") >= 0:
                #print line,

                node_obj = node_re_c.search(line)
                node = int(node_obj.group(1))

                time_obj = time_re_c.search(line)
                #print "\t", time_obj.group(0),
                t = Time(time_obj.group(1),
                         time_obj.group(2),
                         time_obj.group(3))
                #print t.in_second()

                #print "id", node,
                (x, y) = id2xy(node, sqr_nodes)
                #print "->", x, y

                packets[node] += 1

        f.close()
        of = open(filenamebase+"_packet.txt", "w")

        print >> of, "Packets per Node"
        print >> of, packets

        print >> of, "\n\nAverage Packets per Node"
        print >> of, np.mean(packets)

        of.close()
