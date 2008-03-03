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
# @author Kamin Whitehouse 
#

import sys, threading, time, os
import pytos.util.NescApp as NescApp
import pytos.util.ParseArgs as ParseArgs
import pytos.util.MessageSnooper as MessageSnooper
import pytos.util.MessageFilter as MessageFilter
import pytos.util.KeyPress as KeyPress
import pytos.Comm as Comm

def noReturn(msg) :
  sys.stdout.write("%25s" % "(am=%3d) %s " % (msg.amType, msg.nescType))
  sys.stdout.flush()
  
def nameAndType(msg) :
  print "(am=%3d) %s" % (msg.amType, msg.nescType)

def printNamesOnly(msg, maxLevel=3, myLevel=0) :
  if myLevel==0 :
    print "%s%s" % (printNamesOnly(msg.parentMsg, maxLevel, 1),
                    "%25s" % "(am=%3d) %s" % (msg.amType, msg.nescType))
  else :
    if type(maxLevel) == int and maxLevel < myLevel:
      return ""
    elif msg == None:
      return "%s%28s" % (printNamesOnly(msg, maxLevel, myLevel+1), "")
    else :
      return "%s%s  =>  " % (printNamesOnly(msg.parentMsg, maxLevel, myLevel+1),
                            "(am=%3d) %13s" % (msg.amType, msg.nescType))

def printNormal(msg) :
  print msg
  
def printParentNames(msg, maxLevel=3, myLevel=0) :
  if myLevel==0 :
    print "%s%s" % (printParentNames(msg.parentMsg, maxLevel, 1), str(msg))
  else :
    if type(maxLevel) == int and maxLevel < myLevel:
      return ""
    elif msg == None:
      return "%s%30s" % (printParentNames(msg, maxLevel, myLevel+1), "")
    else :
      return "%s%s  =>  " % (printParentNames(msg.parentMsg, maxLevel, myLevel+1),
                            "(am=%3d) %15s" % (msg.amType, msg.nescType))

def printParents(msg, maxLevel='all', myLevel=0) :
  if myLevel==0 :
    print "%s%s" % (printParents(msg.parentMsg, maxLevel, 1), str(msg))
  else :
    if msg == None or (type(maxLevel) == int and maxLevel < myLevel) :
      return ""
    else:
      return "%s%s" % (printParents(msg.parentMsg, maxLevel, myLevel+1), str(msg))


class Listen( object ) :
  """This application prints incoming packets to the screen.  Unlike
  other versions of listen, this one automatically parses the byte
  stream.  The format of the output can be modified by typing letters
  while the data is flowing by (similar to 'top').  For a help, type
  the letter 'h'.  Some of the current commands are:
   h: toggle help
   q: quit
   c: toggle colors

  usage:
  Listen.py telosb sf@localhost:9001
  """
   
  def __init__( self , snooper ) :

    self.usage = """
    h   : help
    p   : pause
    q   : quit
    1-9 : verbosity
    f   : manage filters
    l   : draw line now
    c   : toggle colors
    """

    print "\nType \"h\" for help\n"
    msgQueue = Comm.MessageQueue(10)
    self.keyPress = KeyPress.KeyPress()
    self.filter = MessageFilter.MessageFilter(app,snooper)
    self.filter.register(msgQueue)
    self.running = True
    self.pausing = False
    self.verbosity = '4'
    self.numLostPackets = 0
    self.numPrintedChars = 0

    #start a thread to process the messages (make daemon so it dies when main thread stops)
    self.msgThread = threading.Thread(target=self.processMessages, args=(msgQueue,))
    self.msgThread.setDaemon(True)
    self.msgThread.start()
    self.readKeys()
    
  def processMessages(self, msgQueue) :
    while True :
      (addr,msg) = msgQueue.get()
      if self.running == True:
        self.printMsg(msg)
      else :
        self.numLostPackets += 1
    
        
  def readKeys(self) :
    self.reading = True
    while self.reading :
      try :
        key = self.keyPress.getChar(blocking=True)
        { 'q': self.stopReading, #sys.exit,
          '': self.stopReading, #sys.exit,
          'h': self.help,
          '1': lambda : self.setVerbosity(key),
          '2': lambda : self.setVerbosity(key),
          '3': lambda : self.setVerbosity(key),
          '4': lambda : self.setVerbosity(key),
          '5': lambda : self.setVerbosity(key),
          '6': lambda : self.setVerbosity(key),
          '7': lambda : self.setVerbosity(key),
          '8': lambda : self.setVerbosity(key),
          '9': lambda : self.setVerbosity(key),
          'f': self.createFilter,
          'l': self.drawLine,
          'c': self.colors,
          'p': self.pause
          }[key]()
      except Exception, e:
        if len(e.args)>0:
          print e.args[0]
        else :
          raise
        print "key %s not understood.  Press \"h\" for help" % key

  def createFilter(self) :
    self.stop()
    self.filter.userMenu()
    self.start()
    
  def drawLine(self) :
    print "  ---------------  "
    
  def stopReading(self) :
    self.reading = False
    
  def setVerbosity(self, verbosity) :
    self.verbosity = verbosity
    print "Verbosity is now %s" % self.verbosity
    
  def printMsg(self, msg) :
    { '1' : noReturn,
      '2' : nameAndType,
      '3' : lambda msg: printNamesOnly(msg),
      '4' : printNormal,
      '5' : lambda msg: printParentNames(msg),
      '6' : lambda msg: printParents(msg,1),
      '7' : lambda msg: printParents(msg,2),
      '8' : lambda msg: printParents(msg,3),
      '9' : lambda msg: printParents(msg,'all')
      }[self.verbosity](msg)

  def printLostPackets(self):
    banner = "\nHit any key to resume.  Messages lost: 0"
    sys.stdout.write(banner)
    sys.stdout.flush()
    self.numPrintedChars=1
    while True:
      time.sleep(1)
      c= self.keyPress.getChar(blocking=False)
      if c == "":
        strg = ""
        for i in range(self.numPrintedChars) :
          strg += "\b"
        strg = "%s%d" % (strg,self.numLostPackets)
        self.numPrintedChars = len(strg)-self.numPrintedChars
        sys.stdout.write(strg)
        sys.stdout.flush()
      else:
        print
        break
    
  def help(self) :
    self.stop()
    print "  Current verbosity:  %s" % self.verbosity
    print self.usage
    self.printLostPackets()
    self.start()
  
  def pause(self) :
    self.stop()
    self.printLostPackets()
    self.start()
  
  def colors(self) :
    print "Sorry, no colors yet\n"
  
  def stop(self) :
      self.running = False
      self.numLostPackets = 0
      self.numPrintedChars = 0

  def start(self) :
      self.running = True
        
if __name__ == "__main__":
  args = ParseArgs.ParseArgs(sys.argv)
  app = NescApp.NescApp(args.buildDir, args.motecom, tosbase=True, localCommOnly=True)
  snooper = MessageSnooper.MessageSnooper(app)
  listen = Listen(snooper)
#  os.system('reset')
