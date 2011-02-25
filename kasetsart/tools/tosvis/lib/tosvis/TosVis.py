import math
import re
import sys
import os
import select
from random import random
from threading import Thread
from TOSSIM import *
from topovis import *
from topovis.TkPlotter import Plotter

## Stores preconfigured LEDs' positions and colors.
#
# The configuration is contained in a list.  Each of the entries is
# corresponding to the particular LED based on
# the index in the list.  An entry is of the format [[posx,posy],[r,g,b]], where
# (posx,posy) indicates the position relative to the node's center, and
# (r,g,b) indicates the displayed color (0 <= r,g,b <= 1).
LEDS_CONFIG = [
        [ [ 5, 5], [1.0, 0.0, 0.0] ],
        [ [ 0, 5], [0.0, 0.8, 0.0] ],
        [ [-5, 5], [0.0, 0.0, 1.0] ],
        ]

###############################################
class Node(object):
    '''
    Defines a generic node object used as a handler for a node modeled in
    TOSSIM.
    '''

    LED_RE    = re.compile(r'LEDS: Led(\d) (.*)\.')
    AMSEND_RE = re.compile(r'AM: Sending packet \(id=(\d+), len=(\d+)\) to (\d+)')
    AMRECV_RE = re.compile(r'Received active message \(0x[0-9a-f]*\) of type (\d+) and length (\d+)')

    txRange = 100 # default transmission range

    #################################
    def __init__(self, location, txRange=100):
        '''
        The class constructor.

        @param location 
        tuple (x,y) indicating node's location

        @param txRange 
        (optional) transmission range of the node.
        '''
        self.location = location
        self.txRange = txRange

        # the following attributes will be set by TosVis
        self.id = None
        self.tosvis = None
        self.tossimNode = None

    ####################
    def animateLeds(self,time,ledno,state):
        '''
        Animates LEDs status
        '''
        scene = self.tosvis.scene
        (x,y) = self.location
        shape_id = '%d:%d' % (self.id,ledno)
        if state == 0:
            scene.execute(time, scene.delshape, shape_id)
            return
        if ledno < len(LEDS_CONFIG):
            pos,color = LEDS_CONFIG[ledno]
            x,y = x+pos[0],y+pos[1]
        scene.execute(time, scene.circle, x, y, 2, id=shape_id,
                line=LineStyle(color=color), fill=FillStyle(color=color))

    ####################
    def animateAmSend(self,time,amtype,amlen,amdst):
        '''
        Animates transmission of radio packet for the specified
        ActiveMessage type ID
        '''
        scene = self.tosvis.scene
        (x,y) = self.location
        range
        scene.execute(time, scene.circle, x, y, self.txRange,
                line=LineStyle(color=(1,0,0),dash=(1,1)),delay=.1)

    ####################
    def animateAmRecv(self,time,amtype,amlen):
        '''
        Animates reception of radio packet for the specified
        ActiveMessage type ID
        '''
        scene = self.tosvis.scene
        (x,y) = self.location
        scene.execute(time, scene.circle, x, y, 10,
                line=LineStyle(color=(0,0,1),width=3),delay=.1)

    #################################
    def processDbgMsg(self, dbgMsg):
        simTime = self.tosvis.simTime()

        # LED message
        match = self.LED_RE.match(dbgMsg)
        if match:
            ledno = int(match.group(1))
            stateStr = match.group(2)
            if stateStr == 'off':
                state = 0
            else:
                state = 1
            self.animateLeds(simTime, ledno, state)

        # AM Send message
        match = self.AMSEND_RE.match(dbgMsg)
        if match:
            amtype = int(match.group(1))
            amlen  = int(match.group(2))
            amdst  = int(match.group(3))
            self.animateAmSend(simTime, amtype, amlen, amdst)

        # AM Receive message
        match = self.AMRECV_RE.match(dbgMsg)
        if match:
            amtype = int(match.group(1))
            amlen  = int(match.group(2))
            self.animateAmRecv(simTime, amtype, amlen)


###############################################
class TosVis(object):

    DEBUG_RE  = re.compile(r'DEBUG \((\d+)\): (.*)')

    ####################
    def __init__(self, maxTime, autoBoot=True, showDebug=True):
        '''
        The class constructor.

        @param maxTime
        time limit for which the simulation will run

        @param showDebug
        (optional) flag to indicate whether all debugging messages from TOSSIM
        should also be displayed on the console
        '''

        self.tossim = Tossim([])

        ## Check if nextEventTime() is available in TOSSIM.
        ## This function is necessary to simulate mobility
        #if 'nextEventTime' not in dir(self.tossim):
        #    print 'Error: TosVis requires nextEventTime() in TOSSIM'
        #    quit()

        self.maxTime = maxTime * self.tossim.ticksPerSecond()
        self.showDebug = showDebug
        self.nodes = []
        self.evq = []    # custom event queue

        # setup a pipe for monitoring dbg messages
        r,w = os.pipe()
        self.dbg_read = os.fdopen(r, 'r')
        self.dbg_write = os.fdopen(w, 'w')
        self.tossim.addChannel('LedsC', self.dbg_write)
        self.tossim.addChannel('AM', self.dbg_write)

    ####################
    def simTime(self):
        '''
        Returns the current simulation time in seconds
        '''
        return float(self.tossim.time())/self.tossim.ticksPerSecond()

    ####################
    def addNode(self, node, autoBoot=True):
        '''
        Adds a new node to the simulation.
        
        @param node
        The node object to be added.  It must be an instant of the Node class
        or any of its subclasses.

        @param autoBoot
        (optional) flag to indicate whether the added node will be turned
        on automatically

        @return index of the added node in the 'nodes' list

        '''
        id = len(self.nodes)
        node.id = id
        node.tosvis = self
        node.tossimNode = self.tossim.getNode(id)
        self.createNoiseModel(node)
        self.nodes.append(node)

        # Randomly set the boot time for the node if autoBoot is true
        if autoBoot:
            node.tossimNode.bootAtTime(int(random()*self.tossim.ticksPerSecond()))

        return id


    ####################
    def setupRadio(self):
        '''
        Creates ideal radio links for node pairs that are in range
        '''
        radio = self.tossim.radio()
        num_nodes = len(self.nodes)
        for i,ni in enumerate(self.nodes):
            for j,nj in enumerate(self.nodes):
                if i != j:
                    (isLinked, gain) = self.computeRFGain(ni, nj)
                    if isLinked:
                        radio.add(i, j, gain)

    ####################
    def createNoiseModel(self, node):
        '''
        Obtained from TOSSIM example.  No idea what this is.
        '''
        for i in range(100):
            node.tossimNode.addNoiseTraceReading(int(random()*20)-100)
        node.tossimNode.createNoiseModel()

    ####################
    def computeRFGain(self, src, dst):
        '''
        Returns signal reception gain between src and dst using a simple
        tx-range model.  Should be overriden with a more realistic
        propagation model.
        '''
        if src == dst:
            return (False, 0)

        (x1,y1) = src.location
        (x2,y2) = dst.location
        dx = x1 - x2;
        dy = y1 - y2;
        if math.sqrt(dx*dx + dy*dy) <= src.txRange:
            return (True, 0)
        else:
            return (False, 0)

    ####################
    def moveNode(self, node, location, time=None):
        '''
        Schedules the specified node to move to the new location at the
        specified time.  If time is omitted, move the node immediately.
        '''
        # This function requires access to the simulation queue.  TOSSIM must be
        # patched for it to work
        raise Exception("Node mobility is not yet supported.")

    ####################
    def processDbgMsg(self, dbgMsg):
        match = self.DEBUG_RE.match(dbgMsg)
        if not match: return
        id = int(match.group(1))
        detail = match.group(2)
        self.nodes[id].processDbgMsg(detail)

    ####################
    def run_tossim(self):
        '''
        Starts TOSSIM and captures/processes debugging messages.  (To be
        started in a separate thread.)
        '''
        self.setupRadio()

        while (self.tossim.time() < self.maxTime):
            if self.tossim.runNextEvent() == 0:
                break

            r,w,e = select.select([self.dbg_read.fileno()],[],[],0)
            if len(r) == 1:
                dbg = self.dbg_read.readline()
                self.processDbgMsg(dbg)
                if self.showDebug:
                    sys.stdout.write('%.3f : %s' % (self.simTime(), dbg))

    ####################
    def run(self):
        'Starts simulation with visualization'
        # Setup an animating canvas
        scene = Scene(timescale=1)
        tkplot = Plotter()
        self.scene = scene
        self.tkplot = tkplot
        scene.addPlotter(tkplot)

        # draw nodes on animating canvas
        for n in self.nodes:
            scene.node(n.id, n.location[0], n.location[1])

        # start TOSSIM thread and enter Tk's mainloop
        thr = Thread(target=self.run_tossim)
        thr.setDaemon(True)
        thr.start()
        tkplot.tk.mainloop()
