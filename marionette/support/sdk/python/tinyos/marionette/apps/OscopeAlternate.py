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
# This application is an alternate implementation of the main Oscope application.
# The differences are:
# 1.  this application uses java MIG messages instead of python TosMsg objects
# 2.  This application uses event-driven message processing instead of threads
#

import sys, time, os
from pylab import *                 #the matplotlib stuff
from matplotlib.numerix import arange, sin, pi, array
from pytos.Comm import Comm  #the python comm stack
from jpype import jimport           #java messages
import Tkinter as Tk                #the gui stuff
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg, NavigationToolbar2TkAgg

tinyos = jimport.net.tinyos

class Oscope( object ) :
    """Oscope is a class that opens a window and prints out data
    being passed in by a mote running the tinyos-1.x/apps/Oscilloscope
    application.

    Usage:
      from the shell command line:
        python Oscope.py serial@COM1:telos

        or
        
        export MOTECOM = serial@COM1:telos
        python Oscope.py

      from the python command line:
      (note, it's slow and loses packets as a module... why?)
        from Oscope import Oscope
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
    
    def __init__( self , motecom=None,  tkRoot=None, comm=None ) :

        #use the user's tk root, if they passed it in
        if tkRoot == None:
            self.tkRoot = Tk.Tk()
        else:
            self.tkRoot = tkRoot
            
        #use the user's comm, if they passed it in
        if comm != None:
            self.comm = comm
        #if no comm passed, create one
        else:
            # connect using motecom first, then MOTECOM environment var
            self.comm = Comm()
            if motecom != None :
                self.comm.connect( motecom )
            elif "MOTECOM" in os.environ :
                self.comm.connect( os.environ["MOTECOM"] )
            else:
                sys.stderr.write("No serial port specified\n")
    
        #register a listener for my message
        self.comm.register( tinyos.oscope.OscopeMsg() , self )
        
        # start/stop state
        self.started = False

        # create the frame where all the widgets will go
        self.frame = Tk.Frame( self.tkRoot )
        self.frame.pack()

        # create the matplotlib figure for displaying the oscope msg payload
        #self.fig = Figure()
        #self.axes = self.fig.add_subplot(111)
        self.fig = figure()
        self.axes = subplot(111)
        self.axes.plot([0],[0],'b')

        #we create a line that holds sensor data
        #so that we can update it later
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

        # start the GUI if I created it
        if tkRoot == None:
            self.tkRoot.mainloop()


    def reset( self ) :
        self.comm.send(65535, tinyos.oscope.OscopeResetMsg() )
        self.line.set_data([],[])
        self.canvas.draw()
        
    def toggleStart( self ) :
        self.started = not self.started
        if self.started :
            self.startButton["text"] = "stop"
        else :
            self.startButton["text"] = "start"

    def messageReceived( self , addr , msg ) :

        # Because callbacks via jpype give awful errors, catch
        # and print errors here
        try:
            if self.started :
                if isinstance( msg , tinyos.oscope.OscopeMsg ) :
                    self.receivedOscopeMsg( msg )
                else :
                    sys.stderr.write("message of unknown type received\n")
        except Exception,inst :
            print inst
            sys.exit(1)

    def receivedOscopeMsg( self , msg ) :
        print "Received new data #%d from %d" % (msg.get_lastSampleNumber(),
                                                 msg.get_sourceMoteID() )
        #update the old line with the new data
        newData = list(msg.get_data())
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
    #if the user is running this as a script
    if len(sys.argv) == 2 :
        oscope = Oscope(motecom = sys.argv[1])
    else:
        oscope = Oscope()

