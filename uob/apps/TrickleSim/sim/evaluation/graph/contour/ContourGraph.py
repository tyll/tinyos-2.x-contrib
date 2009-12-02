#!/usr/bin/env python

import matplotlib
import matplotlib.pyplot as plt
import numpy as np
import re

from sim.utils.helper import *

class ContourGraph:
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
        print "Executing ContourGraph:"
        print "filenamebase\t\t", filenamebase
        print "="*40

        node_re = 'DEBUG \((\d+)\):'
        node_re_c = re.compile(node_re)
        time_re = '(\d+):(\d+):(\d+.\d+)'
        time_re_c = re.compile(time_re)

        consist = np.zeros((sqr_nodes, sqr_nodes))

        f = open(filenamebase+".log", "r")
        for line in f:
            #print line,
            if line.find("inconsistent") >= 0:
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

                consist[x][y] = t.in_second()

        f.close()

        plt.figure(figsize=(10, 8))
        #CS = plt.contour(consist, 20)
        #CS = plt.contour(consist, sqr_nodes)
        CS = plt.contourf(consist, sqr_nodes)
        #plt.clabel(CS, inline=1, fontsize=10)
        plt.colorbar()
        plt.grid()
        plt.title('Time to consistency [s]')
        if sqr_nodes < 10:
            plt.yticks(range(sqr_nodes))
            plt.xticks(range(sqr_nodes))
        else:
            plt.yticks(range(0, sqr_nodes, 2))
            plt.xticks(range(0, sqr_nodes, 2))

        plt.xlabel("x")
        plt.ylabel("y")

        plt.savefig(filenamebase+"_contour.png")
