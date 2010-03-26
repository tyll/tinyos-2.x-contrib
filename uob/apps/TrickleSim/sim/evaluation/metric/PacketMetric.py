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
                distance,
                filenamebase):

        print "="*40
        print "Executing PacketMetric:"
        print "filenamebase\t\t", filenamebase
        print "="*40

        node_re = 'DEBUG \((\d+)\):'
        node_re_c = re.compile(node_re)
        time_re = '(\d+):(\d+):(\d+.\d+)'
        time_re_c = re.compile(time_re)

        rec_node_re = 'from node (\d+).'
        rec_node_re_c = re.compile(rec_node_re) 
        #packets = np.zeros((sqr_nodes*sqr_nodes+1))
        #sent_packets = np.zeros((sqr_nodes, sqr_nodes))
        sent_packets = np.zeros(sqr_nodes*sqr_nodes+1)
        #rec_packets  = np.zeros((sqr_nodes, sqr_nodes, sqr_nodes*sqr_nodes+1))
        rec_packets  = np.zeros((sqr_nodes*sqr_nodes+1, sqr_nodes*sqr_nodes+1))
        prr_rate     = np.zeros((sqr_nodes*sqr_nodes+1, sqr_nodes*sqr_nodes+1))

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
                #(x, y) = id2xy(node, sqr_nodes)
                #print "->", x, y

                #sent_packets[x][y] += 1
                sent_packets[node] += 1

            if line.find("TrickleSimC: Received packet of length") >= 0:
                node_obj = node_re_c.search(line)
                rx_node = int(node_obj.group(1))

                rec_node_obj = rec_node_re_c.search(line)
                tx_node = int(rec_node_obj.group(1))

                #(x, y) = id2xy(rx_node, sqr_nodes)

                rec_packets[rx_node][tx_node] += 1

        f.close()

        for x in range(0, sqr_nodes):
            for y in range(0, sqr_nodes):
                id1 = xy2id(x, y, sqr_nodes)

                for x2 in range(0, sqr_nodes):
                    for y2 in range(0, sqr_nodes):
                        id2 = xy2id(x2, y2, sqr_nodes)

                        prr_rate[id1][id2] = rec_packets[id1][id2] / float(sent_packets[id2])

        of = open(filenamebase+"_packet.txt", "w")

        print >> of, "Total number of Sent Packets"
        print >> of, np.sum(sent_packets)

        print >> of, "Sent Packets per Node"
        print >> of, sent_packets

        print >> of, "Average Sent Packets per Node"
        print >> of, np.sum(sent_packets)/float(sqr_nodes*sqr_nodes)

        print >> of, "\nTotal number of Received Packets"
        print >> of, np.sum(rec_packets)-1

        print >> of, "Received Packets per Node"
        print >> of, rec_packets

        print >> of, "Average Received Packets per Node"
        print >> of, ((np.sum(rec_packets)-1)/float(sqr_nodes*sqr_nodes))

        np.set_printoptions(threshold=np.nan)
        print >> of, "\nPRR"
        print >> of, prr_rate

        print >> of, "Received/Sent Ratio"
        print >> of, (np.sum(rec_packets)-1)/float(np.sum(sent_packets))

        #print >> of, "\n\nPackets per Inner Node"
        #print >> of, packets[connectivity:-connectivity,connectivity:-connectivity]

        #print >> of, "\nAverage Packets per Inner Nodes"
        #print >> of, np.mean(packets[connectivity:-connectivity,connectivity:-connectivity])

        of.close()
