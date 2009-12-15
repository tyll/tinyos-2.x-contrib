import matplotlib
import matplotlib.pyplot as plt
from matplotlib.lines import Line2D
import numpy as np
import re

from sim.utils.helper import *

class PacketGraph:
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
                filenamebase):

        print "="*40
        print "Executing PacketGraph:"
        print "filenamebase\t\t", filenamebase
        print "="*40

        node_re = 'DEBUG \((\d+)\):'
        node_re_c = re.compile(node_re)
        time_re = '(\d+):(\d+):(\d+.\d+)'
        time_re_c = re.compile(time_re)

        consist = np.zeros((sqr_nodes, sqr_nodes))

        packs = []

        f = open(filenamebase+".log", "r")
        for line in f:
            #print line,
            if line.find("booted") >= 0:
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

                packs.append(
                    Line2D([t.in_second(), t.in_second()],
                           [node+.3, node+.7],
                           color='b',
                           linewidth=2)
                    )

            if line.find("consistent") >= 0:
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

                if line.find("inconsistent") >= 0:
                    if line.find("inconsistent newer") >= 0:
                        packs.append(
                            Line2D([t.in_second(), t.in_second()],
                                   [node+.3, node+.7],
                                   color='r',
                                   linewidth=2)
                            )
                    elif line.find("inconsistent older") >= 0:
                        packs.append(
                            Line2D([t.in_second(), t.in_second()],
                                   [node+.3, node+.7],
                                   color='y',
                                   linewidth=2)
                            )
                else:
                     packs.append(
                         Line2D([t.in_second(), t.in_second()],
                                [node+.3, node+.7],
                                color='g',
                                linewidth=2)
                         )

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

                packs.append(
                    Line2D([t.in_second(), t.in_second()],
                           [node, node+1],
                           color='k',
                           linewidth=2)
                    )

        f.close()

        fig = plt.figure(figsize=(10, 8))
        ax = fig.add_subplot(111)

        for p in packs:
            ax.add_artist(p)
            p.set_clip_box(ax.bbox)

        ax.set_xlim(0,
                    sec_before_inject+
                    sec_after_inject+5)
        ax.set_ylim(1, sqr_nodes*sqr_nodes+1)

        if sqr_nodes < 10:
            ax.set_yticks(range(sqr_nodes*sqr_nodes+1))
        else:
            ax.set_yticks(range(0, sqr_nodes*sqr_nodes+1, 10))

        ax.set_xlabel('Model time [s]')
        ax.set_ylabel('Node ID')

        plt.title('Packet Scatter')
        text = str(sqr_nodes) + "x" + str(sqr_nodes) + "\n" + \
            "Connectivity: " + str(connectivity) + "\n" + \
            "K: " + str(k)
        plt.text(.5, .1, text,
                 horizontalalignment='center',
                 verticalalignment='center',
                 transform = ax.transAxes,
                 bbox=dict(facecolor='red', alpha=0.2))

        boot_line = Line2D([0, 1],
                           [0, 1],
                           color='b',
                           linewidth=2)

        incons_new_line = Line2D([0, 1],
                                 [0, 1],
                                 color='r',
                                 linewidth=2)
        incons_old_line = Line2D([0, 1],
                                 [0, 1],
                                 color='y',
                                 linewidth=2)

        cons_line = Line2D([0, 1],
                           [0, 1],
                           color='g',
                           linewidth=2)

        packet_line = Line2D([0, 1],
                             [0, 1],
                             color='k',
                             linewidth=2)

        plt.figlegend( (boot_line, incons_new_line, incons_old_line, cons_line, packet_line),
                       ('Boot', 'Inconsistency (New)', 'Inconsistency (Old)', 'Consistency', 'Packet Sent'),
                       'upper right' )

        plt.savefig(filenamebase+"_packet.png")
