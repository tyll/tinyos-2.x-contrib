import random, math

from sim.utils.helper import *

class Scenario():
    def __init__(self, t, size, gain):
        self.t = t
        self.size = size
        self.gain = gain
        self.r = self.t.radio()

        self.max_neigh = 0

    def connect_neighbor(self, x, y, x2, y2):
        #print "\tConnecting " + \
        #    str(x) + "/" + str(y) + " (" + str(xy2id(x, y, self.size)) + ") and " + \
        #    str(x2) + "/" + str(y2) + " (" + str(xy2id(x2, y2, self.size)) + ")"
        self.r.add(xy2id(x, y, self.size), xy2id(x2, y2, self.size), self.gain)

    def should_connect(self, x, y, x2, y2, connectivity):
        distance = math.sqrt((x-x2)**2 + (y-y2)**2)
        if distance <= connectivity:
            return True
        else:
            return False

    def connect_neighbors(self, x, y, connectivity):
        for x2 in range(0, self.size):
            for y2 in range(0, self.size):
                if x == x2 and y == y2:
                    continue

                if self.should_connect(x, y, x2, y2, connectivity):
                    if x == 10 and y == 10:
                        self.max_neigh += 1
                    self.connect_neighbor(x, y, x2, y2)

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

    def setup_boot(self, randomize=False, randomseed=False):
        for x in range(0, self.size):
            for y in range(0, self.size):

                if randomize == False:
                    boottime = 1*self.t.ticksPerSecond() \
                        + xy2id(x, y, self.size)*10
                else:
                    if randomseed:
                        random.seed()
                    boottime = 1*self.t.ticksPerSecond() \
                        + int(9*random.random()*self.t.ticksPerSecond())

                #print "Setting boot time for", \
                #    x, y, xy2id(x, y, self.size), boottime
                n = self.t.getNode(xy2id(x, y, self.size))

                # set the boottime
                n.bootAtTime(boottime)
