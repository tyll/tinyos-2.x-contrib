import matplotlib
import matplotlib.pyplot as plt
from matplotlib.lines import Line2D
import numpy as np
import re

from sim.utils.helper import *

class TrickleGraph:
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

        print "="*40
        print "Executing TrickleGraph:"
        print "filenamebase\t\t", filenamebase
        print "="*40

        node_re = 'DEBUG \((\d+)\):'
        node_re_c = re.compile(node_re)
        time_re = '(\d+):(\d+):(\d+.\d+)'
        time_re_c = re.compile(time_re)

        #period_re = 'with period (\d+) \((\d+)\) is (\d+) '
        period_re = 'Scheduling Trickle event in (\d+) \(period (\d+)\)'
        period_re_c = re.compile(period_re)

        trickle_period = np.zeros(sqr_nodes*sqr_nodes + 1)

        packs = []

        f = open(filenamebase+".log", "r")
        for line in f:
            #print line,
            if line.find("Scheduling Trickle event in") >= 0:
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

                TMILLI = 1024

                period_obj = period_re_c.search(line)
                # period_s     = int(period_obj.group(1))
                # period_ticks = int(period_obj.group(2))
                # timer_ms     = int(period_obj.group(3))
                # timer_s      = timer_ms/TMILLI
                timer_ms     = int(period_obj.group(1))
                period_ms    = int(period_obj.group(2))
                timer_s      = timer_ms/TMILLI
                period_s      = period_ms/TMILLI

                trickle_period[node] += 1

                packs.append(
                    Line2D([t.in_second(), t.in_second()+period_s/2],
                           [node+.1*trickle_period[node], node+.1*trickle_period[node]],
                           color='b',
                           linewidth=1,
                           alpha=0.3)
                    )

                packs.append(
                    Line2D([t.in_second()+period_s/2, t.in_second()+period_s],
                           [node+.1*trickle_period[node], node+.1*trickle_period[node]],
                           color='r',
                           linewidth=1,
                           alpha=0.5)
                    )

                #print "t", t.in_second(),
                #print "Timer in seconds?", timer_s,
                #print "-", t.in_second()+timer_s

                packs.append(
                    Line2D([t.in_second()+timer_s, t.in_second()+timer_s],
                           [node+.1*trickle_period[node]-.1,
                            node+.1*trickle_period[node]+.1],
#                           [node, node+1],
                           color='g',
                           linewidth=1,
                           alpha=1)
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
                           [node+.2, node+.2],
                           color='k',
                           marker='^',
                           markeredgewidth=0,
                           markersize=5,
                           linewidth=1,
                           alpha=0.5)
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
                                   [node+.8, node+.8],
                                   color='r',
                                   marker='v',
                                   markeredgewidth=0,
                                   markersize=5,
                                   linewidth=2,
                                   alpha=0.5)
                            )
                    elif line.find("inconsistent older") >= 0:
                        packs.append(
                            Line2D([t.in_second(), t.in_second()],
                                   [node+.8, node+.8],
                                   color='y',
                                   marker='v',
                                   markeredgewidth=0,
                                   markersize=5,
                                   linewidth=2,
                                   alpha=0.5)
                            )
                else: #consistent
                     packs.append(
                         Line2D([t.in_second(), t.in_second()],
                                [node+.8, node+.8],
                                color='g',
                                marker='v',
                                markersize=5,
                                markeredgewidth=0,
                                linewidth=2,
                                alpha=0.5)
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

        plt.title('Trickle Scatter')
        text = str(sqr_nodes) + "x" + str(sqr_nodes) + "\n" + \
            "Distance: " + str(distance) + "\n" + \
            "K: " + str(k)
#            "Connectivity: " + str(connectivity) + "\n" + \
        plt.text(.5, .1, text,
                 horizontalalignment='center',
                 verticalalignment='center',
                 transform = ax.transAxes,
                 bbox=dict(facecolor='red', alpha=0.2))

        listenp_line = Line2D([0, 1],
                              [0, 1],
                              color='b',
                              linewidth=1,
                              alpha=0.3)

        sendp_line = Line2D([0, 1],
                            [0, 1],
                            color='r',
                            linewidth=1,
                            alpha=0.5)

        timer_line = Line2D([0, 1],
                            [0, 1],
                            color='g',
                            linewidth=1)

        sent_line = Line2D([0, 1],
                           [0, 1],
                           color='k',
                           marker='^',
                           markeredgewidth=0,
                           linewidth=1,
                           alpha=0.5)

        rec_incons_new_line = Line2D([0, 1],
                                    [0, 1],
                                    color='r',
                                    marker='v',
                                    markeredgewidth=0,
                                    linewidth=2,
                                     alpha=0.5)

        rec_incons_old_line = Line2D([0, 1],
                                    [0, 1],
                                    color='y',
                                    marker='v',
                                    markeredgewidth=0,
                                    linewidth=2,
                                     alpha=0.5)

        cons_line = Line2D([0, 1],
                           [0, 1],
                           color='g',
                           marker='v',
                           markeredgewidth=0,
                           linewidth=2,
                           alpha=0.5)

        plt.figlegend( (listenp_line,
                        sendp_line,
                        timer_line,
                        sent_line,
                        rec_incons_new_line,
                        rec_incons_old_line,
                        cons_line,
                        ),
                       ('Listen Period',
                        'Send Period',
                        'Timer',
                        'Packet Sent',
                        'Inconsistent Received (New)',
                        'Inconsistent Received (Old)',
                        'Consistent Received'
                        ),
                       'lower right' )

        plt.grid(markevery=1)
        plt.savefig(filenamebase+"_trickle.png")
        print "#Periods:", trickle_period
