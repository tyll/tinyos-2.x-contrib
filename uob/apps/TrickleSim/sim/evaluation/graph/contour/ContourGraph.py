import matplotlib
import matplotlib.pyplot as plt
import matplotlib.cm as cm
import matplotlib.colors as col
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
                k,
                distance,
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
            if line.find("inconsistent newer") >= 0:
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

        fig = plt.figure(figsize=(10, 8))
        ax = fig.add_subplot(111)

        print "! Max. Time to Consistency:", np.max(consist)
        print "! Min. Time to Consistency:", np.min(consist)

        LOW_LEVEL = 0
        HIGH_LEVEL = 3*sqr_nodes

        levels = floatRange(LOW_LEVEL,
                            HIGH_LEVEL,
                            .5)
        #print levels

        my_cm = cm.jet
        my_cm.set_over('k')

        my_norm = col.Normalize(LOW_LEVEL,
                                HIGH_LEVEL,
                                clip=False)

        CS = plt.contourf(consist, levels,
                          cmap = my_cm, norm = my_norm,
                          extend='max')
        CS.set_clim(CS.cvalues[0], CS.cvalues[-2])

        plt.colorbar(CS)

        plt.grid(markevery=1)
        plt.title('Model Time to Consistency [s]')

        text = str(sqr_nodes) + "x" + str(sqr_nodes) + "\n" + \
            "Distance: " + str(distance) + "\n" + \
            "K: " + str(k)
#            "Connectivity: " + str(connectivity) + "\n" + \
        plt.text(.5, .1, text,
                 horizontalalignment='center',
                 verticalalignment='center',
                 transform = ax.transAxes,
                 bbox=dict(facecolor='red', alpha=0.2))

        #if sqr_nodes <= 10:
        plt.yticks(range(sqr_nodes))
        plt.xticks(range(sqr_nodes))
        #else:
        #    plt.yticks(range(0, sqr_nodes, 2))
        #    plt.xticks(range(0, sqr_nodes, 2))

        plt.xlim(0, sqr_nodes-1)
        plt.ylim(0, sqr_nodes-1)

        plt.xlabel("x")
        plt.ylabel("y")

#        conn_circ = matplotlib.patches.Circle((0, 0),
#                                             connectivity+.02,
#                                             ls='dotted',
#                                             lw=2,
#                                             ec='w',
#                                             fill=False)
#        fig.gca().add_artist(conn_circ)

        plt.savefig(filenamebase+"_contour.png")
