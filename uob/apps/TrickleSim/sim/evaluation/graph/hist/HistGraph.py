#!/usr/bin/env python

import matplotlib
import matplotlib.pyplot as plt
import numpy as np
import scipy.stats as stats
import re

from sim.utils.helper import *

class HistGraph:
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
        print "Executing HistGraph:"
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

                consist[x][y] = t.in_second() - sec_before_inject

        f.close()

        LOW_TIME = 0
        HIGH_TIME = 50
        BINS = 100

        #print consist.flatten()
        cdf = stats.cumfreq(consist.flatten(), BINS, (LOW_TIME, HIGH_TIME))
        #print cdf #, max(cdf[0]), cdf[0]/max(cdf[0])
        #print floatRange(LOW_TIME, HIGH_TIME, cdf[2])

        plt.figure(figsize=(10, 8))

        plt.plot(floatRange(LOW_TIME, HIGH_TIME, cdf[2]),
                 cdf[0]/max(cdf[0]),
                 ls='steps')
        # plt.hist(consist.flatten(),
        #          bins = 100,
        #          cumulative=True,
        #          normed=True,
        #          histtype='step')
        plt.grid()
        plt.title('Model Time to Consistency (cdf)')

        plt.ylim(0,
                 1)
        #plt.xlim(0,
        #         50)

        plt.xlabel("Model Time [s]")
        plt.ylabel("Nodes consistent [%]")

        plt.savefig(filenamebase+"_hist.png")
