#!/usr/bin/python
#$Id$

# "Copyright (c) 2000-2003 The Regents of the University of California.  
# All rights reserved.
#
# Permission to use, copy, modify, and distribute this software and its
# documentation for any purpose, without fee, and without written agreement
# is hereby granted, provided that the above copyright notice, the following
# two paragraphs and the author appear in all copies of this software.
# 
# IN NO EVENT SHALL THE UNIVERSITY OF CALIFORNIA BE LIABLE TO ANY PARTY FOR
# DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
# OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE UNIVERSITY
# OF CALIFORNIA HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
# 
# THE UNIVERSITY OF CALIFORNIA SPECIFICALLY DISCLAIMS ANY WARRANTIES,
# INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
# AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
# ON AN "AS IS" BASIS, AND THE UNIVERSITY OF CALIFORNIA HAS NO OBLIGATION TO
# PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
#
# @author Shawn Schaffert <sms@eecs.berkeley.edu>
# @author Kamin Whitehouse 
#
# This is the default Oscope application, which shows how a very simple
# python script should use the pytos tools.  Some other versions of Oscope
# exist, which show special cases (eg. how to use mig msgs instead of python
# msgs, or how to use event-driven programming instead of threaded apps)
#
# To debug this application, run it with the -i option passed to python
# and then close the Tk frame.

import sys, time, os
import pytos.util.nescDecls as nescDecls   #the nescTypes stuff
from pylab import *                        #the matplotlib stuff
from matplotlib.numerix import arange, sin, pi, array
from pytos.Comm import Comm         #the python comm stack
from pytos.Comm import MessageQueue        #the message queue
import Tkinter as Tk                       #the gui stuff
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg, NavigationToolbar2TkAgg
import threading
from copy import deepcopy

class Oscope( object ) :
    """Oscope is a class that opens a window and prints out data
    being passed in by a mote running the tinyos-1.x/apps/Oscilloscope
    application.  You must indicate where the build directory is

    Usage:
    Oscope.py [platform directory] [comm port]

    Both parameters can be contained in environment variables. Example usage:
    
      from the shell command line:
        python OscopeThreaded.py ~/tinyos-1.x/apps/Oscope/build/telosb serial@COM1:telos

        or

        cd ~/tinyos-1.x/apps/Oscope
        python OscopeThreaded.py telosb serial@COM1:telos

        or
        
        export MOTECOM = serial@COM1:telos
        export DEFAULT_PLATFORM
        cd ~/tinyos-1.x/apps/Oscope
        python OscopeThreaded.py

      from the python command line:
      (note, it's slow and loses packets as a module... why?)
        from OscopeThreaded import Oscope
        oscope = Oscope('serial@COM1:telos')

        or
        
        from pytos.Comm import Comm
        myComm = Comm()
        myComm.connect('serial@COM1:telos')
        oscope = Oscope(comm=myComm)

        and/or (you can use combinations of comm and tkRoot)

        import Tkinter as Tk
        root = Tk.Tk()
        oscope = Oscope(rkRoot = root)
        root.mainloop()
        """
    
    def __init__( self , buildDir="", motecom=None,  tkRoot=None, comm=None ) :

        #first, import all types, msgs, and enums from the nesc app
        self.app = nescDecls.nescApp(buildDir, "Oscope")
        #use the user's comm and tkroot, if they passed it in
        if tkRoot == None:
            self.tkRoot = Tk.Tk()
        else :
            self.tkRoot = tkRoot
        if comm == None:
            comm = Comm()
            comm.connect( motecom ) #defaults to MOTECOM env variable if undefined
        self.comm = comm

        self.initializeGui()
        #create a queue for receiving oscope messages and register it for messages
        oscopeMsgQueue = MessageQueue(1)
        self.comm.register( deepcopy(self.app.msgs.OscopeMsg) , oscopeMsgQueue )
        #start a thread to process the messages (make daemon so it dies when tk is killed)
        msgThread = threading.Thread(target=self.processMessages,
                                     args=(oscopeMsgQueue,))
        msgThread.setDaemon(True)
        msgThread.start()
        # start the GUI thread if we own it
        if tkRoot == None:
            self.tkRoot.mainloop()
            print "Oscope.py exited normally"
            
    def initializeGui(self) :

        # create the frame where all the widgets will go
        self.frame = Tk.Frame( self.tkRoot )
        self.frame.pack()
        # create the matplotlib figure for displaying the oscope msg payload
        self.fig = figure()
        self.axes = subplot(111)
        self.axes.plot([0],[0],'b')
        #we create a line that holds sensor data so that we can update it later
        self.line, = self.axes.lines
        self.line.set_data([],[])
        #remember the current axis limits
        self.xlim = self.axes.get_xlim()
        self.ylim = self.axes.get_ylim()
        # start/stop button
        self.startButton = Tk.Button( self.frame , text="start" ,
                                      command = self.toggleStart )
        self.startButton.pack( side = Tk.LEFT )
        # reset button
        self.resetButton = Tk.Button( self.frame , text="reset" ,
                                      command = self.reset )
        self.resetButton.pack( side = Tk.LEFT )
        #container object for the figure instance
        self.canvas = FigureCanvasTkAgg( self.fig , master = self.tkRoot )  
        self.canvas.show()
        self.canvas.get_tk_widget().pack( side = Tk.TOP , fill = Tk.BOTH ,
                                          expand = 1 )
        self.toolbar = NavigationToolbar2TkAgg( self.canvas , self.tkRoot )
        self.toolbar.update()
        self.canvas._tkcanvas.pack( side=Tk.TOP , fill=Tk.BOTH , expand=1)

        
    def reset( self ) :
        self.comm.send(self.app.enums.TOS_BCAST_ADDR, self.app.msgs.OscopeResetMsg )
        self.line.set_data([],[])
        self.canvas.draw()
        
    def toggleStart( self ) :
        if self.startButton["text"] == "start" :
            self.startButton["text"] = "stop"
        else :
            self.startButton["text"] = "start"

    def processMessages(self, msgQueue) :
        while True :
            (addr,msg) = msgQueue.get()
            if self.startButton["text"] == "stop" :
                self.receivedOscopeMsg(msg)

    def receivedOscopeMsg( self , msg ) :
        print "Received new data #%d from %d" % (msg.lastSampleNumber,
                                                 msg.sourceMoteID )
        #update the old line with the new data
        newData = list(msg.data)
        xdata = self.line.get_xdata().tolist()
        ydata = self.line.get_ydata().tolist()
        xdata.extend(range(len(xdata), len(xdata)+len(newData)))
        ydata.extend(newData)
        self.line.set_data(xdata, ydata)

        #now, if the user isn't zooming or something, update the axis limits
        if self.xlim == self.axes.get_xlim() and  \
           self.ylim == self.axes.get_ylim() :
            self.axes.set_xlim(min(xdata), max(xdata))
            self.axes.set_ylim(min(ydata), max(ydata)) 
            self.xlim = self.axes.get_xlim()
            self.ylim = self.axes.get_ylim()
           
        self.canvas.draw()

        
if __name__ == "__main__":
    #if the user is running this as a script as opposed to an imported module
    if len(sys.argv) == 3 :
        oscope = Oscope(buildDir = sys.argv[1], motecom = sys.argv[2], )
    elif len(sys.argv) == 2 :
        oscope = Oscope(buildDir = sys.argv[1], )
    else:
        oscope = Oscope()

