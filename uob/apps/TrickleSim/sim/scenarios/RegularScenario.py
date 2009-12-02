import random

from sim.utils.helper import *

class Scenario():
    def __init__(self, t, size):
        self.t = t
        self.size = size
        self.r = self.t.radio()

    def connect_neighbor(self, x, y, x2, y2):
        #print "\tConnecting " + \
        #    str(x) + "/" + str(y) + " (" + str(xy2id(x, y, self.size)) + ") and " + \
        #    str(x2) + "/" + str(y2) + " (" + str(xy2id(x2, y2, self.size)) + ")"
        self.r.add(xy2id(x, y, self.size), xy2id(x2, y2, self.size), -50)

    def connect_neighbors(self, x, y, connectivity):

        for i in range(1, connectivity+1):
            #print "!!!!", i
            if y-i >= 0:
                self.connect_neighbor(x, y, x, y-i)
            if y+i < self.size:
                self.connect_neighbor(x, y, x, y+i)

            if x-i >= 0:
                self.connect_neighbor(x, y, x-i, y)
            if x+i < self.size:
                self.connect_neighbor(x, y, x+i, y)

            #FIXME: also diagonal connections?

        # if y-1 >= 0:
        #     self.connect_neighbor(x, y, x, y-1)
        # if y+1 < self.size:
        #     self.connect_neighbor(x, y, x, y+1)

        # if x-1 >= 0:
        #     self.connect_neighbor(x, y, x-1, y)
        # if x+1 < self.size:
        #     self.connect_neighbor(x, y, x+1, y)


    def setup_radio(self, connectivity):
        for x in range(0, self.size):
            for y in range(0, self.size):
                #print "Setting up " + \
                #    str(x) + "/" + str(y) + " (" + str(xy2id(x, y, self.size)) + ")"
                self.connect_neighbors(x, y, connectivity)
                # FIXME: use connectivity to show scaling with denseness

        for x in range(0, self.size):
            for y in range(0, self.size):
                for i in range(0, 10000):
                    self.t.getNode(xy2id(x, y, self.size)).addNoiseTraceReading(-98)

        for x in range(0, self.size):
            for y in range(0, self.size):
                #print "Creating noise model for ", xy2id(x, y, self.size)
                self.t.getNode(xy2id(x, y, self.size)).createNoiseModel()

    def setup_boot(self, randomize=False):
        for x in range(0, self.size):
            for y in range(0, self.size):

                if randomize == False:
                    boottime = 1*self.t.ticksPerSecond() \
                        + xy2id(x, y, self.size)*10
                else:
                    boottime = 1*self.t.ticksPerSecond() \
                        + int(1000*random.random())

                #print "Setting boot time for", \
                #    x, y, xy2id(x, y, self.size), boottime
                self.t.getNode(xy2id(x, y, self.size)).bootAtTime(boottime)

