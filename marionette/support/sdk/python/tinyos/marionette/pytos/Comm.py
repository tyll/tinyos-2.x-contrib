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

# @author Cory Sharp <cssharp@eecs.berkeley.edu>
# @author Shawn Schaffert <sms@eecs.berkeley.edu>
# @author Kamin Whitehouse
# @author Michael Okola (TinyOS 2.x porting)

import sys, os, string, types
from Queue import Queue
import threading
import pytos.util.nescDecls as nescDecls
from tinyos.message.MoteIF import MoteIF
from copy import deepcopy


def getCommObject(app, motecom=None) :
  """This function returns the comm object stored in app.  If there
  is none, it creates one.  If it is not connected to motecom, it connects it."""
  for conn in app.connections :
    if isinstance(conn, Comm) :
      if motecom != None and motecom not in conn._connected :
        conn.connect(motecom)
      return conn
  if motecom==None:
    return None
  comm = Comm()
  comm.connect(motecom)
  app.connections.append(comm)
  return comm



class MoteIFCache(object) :

  def __init__(self, parent) :
    self._moteif = {}
    self._source = {}
    self.parent=parent

  def get( self , sourceStr ) :
    if self.isAlive( sourceStr ) :
      return self._moteif[ sourceStr ]

    self._moteif[ sourceStr ] = MoteIF( )
    self._source[ sourceStr ] = self._moteif[ sourceStr ].addSource(sourceStr)
    return self._moteif[ sourceStr ]

  def getSource( self, sourceStr ) :
    if self.isAlive( sourceStr ) :
      return self._source[ sourceStr ]
    raise Exception("Invalid source string")

  def isAlive( self , sourceStr ) :
    if self.has( sourceStr ) :
      return True
    return False

  def has( self , sourceStr ) :
    if self._moteif.has_key( sourceStr ) :
      return True
    return False

  def destroy( self , sourceStr ) :
    if self.has( sourceStr ) :
      # FIXME : this throws an exception that I cannot catch or print from being displayed
      self._moteif[ sourceStr ].finishAll()
      del self._moteif[ sourceStr ]
      del self._source[ sourceStr ]



class CommError(Exception):
  pass


class Comm( object ) :

  def __init__( self, app=None ) :
    self.app = app
    self._moteifCache = MoteIFCache(self)
    self._connected = []

  def connect( self , *moteComStr ) :    
    moteComStr = self.completeMoteComStr("environmentVariable", *moteComStr)
    for newMoteComStr in moteComStr :
      if newMoteComStr not in self._connected :
        self._moteifCache.get( newMoteComStr )
        self._connected.append( newMoteComStr )
      else :
        raise CommError , "already connected to " + newMoteComStr

  def disconnect( self , *moteComStr ) :
    moteComStr = self.completeMoteComStr("environmentVariable", *moteComStr)
    for oldMoteComStr in moteComStr :
      if oldMoteComStr in self._connected :
        self._connected.remove( oldMoteComStr )
        self._moteifCache.destroy( oldMoteComStr )
      else :
        raise CommError , "not connected to " + oldMoteComStr

  def send( self , addr , msg , *moteComStr ) :
    moteComStr = self.completeMoteComStr("ExistingPorts", *moteComStr)
    for mc in moteComStr :
      self._moteifCache.get(mc).sendMsg( self._moteifCache.getSource(mc), addr, msg.amType, msg.parent.app.enums.TOS_AM_GROUP, msg )

  def register( self , msg , listener , *moteComStr ) :
    """Register a function or an object to receive arriving messages.
    If an object is registered, it must implement the MessageListener
    interface, meaning it must have a messageReceived( self , addr ,
    msg ) method.  If a function is registered, it must accept two
    arguments: addr,msg"""

    moteComStr = self.completeMoteComStr("ExistingPorts", *moteComStr)
    for mc in moteComStr :
      self._moteifCache.get(mc).addListener( listener, msg )

  def unregister( self , msg , listener , *moteComStr ) :
    moteComStr = self.completeMoteComStr("ExistingPorts", *moteComStr)
    for mc in moteComStr :
      self._moteifCache.get(mc).removeListener( listener )

  def completeMoteComStr(self, default, *moteComStr) :
    if len(moteComStr)==0 or moteComStr[0] == None :
      if default.lower().find("env") >=0 :
        if "MOTECOM" in os.environ :
          return os.environ["MOTECOM"] 
        else :
          raise Exception("No comm port specified and MOTECOM environment variable undefined")
      elif default.lower().find("exist") >= 0:
        if len(self._connected) > 0:
          moteComStr = self._connected
        else :
          raise Exception("No new comm port specified and no existing ports available")
    return moteComStr

  

class MessageQueue( Queue ) :
  """This is object can be created and registered as an event handler,
  and then the message listener can read messages from this queue.
  A max size of the queue must be specified, and if more than this number
  of messages is received and not pulled from the queue, the oldest
  will be removed first.
  This is good for threading-based message handling instead of even-based.

  WARNING: Do not put your own messages into the message queue!
           You must make put() or put_nowait() thread safe first.
           
  example usage:
    myMsgQueue = Comm.MessageQueue( 10 )
    comm.register(myMsg, myMsgQueue)
    while True
      (addr, msg) = myMsgQueue.get()
      ...process msg
  """

  #If the queue is used to receive messages from multiple moteIF,
  #they can each call the messageReceived function from different
  #threads, so this needs to be thread-safe.  MessageQueue therefore
  #shields all applications from asynchronous code

  def __init__(self, maxsize) :
    Queue.__init__(self,maxsize)
    self.semaphore = threading.Semaphore()
    
  def receive( self , addr , msg ) :
    self.messageReceived(addr, msg)
    
  def messageReceived( self , addr , msg ) :
    self.semaphore.acquire()
    if self.full() :
      try :
        (addr,msg) = self.get_nowait( )
      except :
        #this would happen only if the user gets between if self.full and get_nowait.
        #In such case, ignore the problem
        #self.semaphore.release()
        #raise Exception("Comm.MessageQueue is empty")
        pass
    try :
      self.put_nowait( (addr, msg) )
    except :
      #If the semaphore is working, this should never happen because nobody but this function
      #should be putting stuff into the queue
      self.semaphore.release()
      raise Exception("Lost a packet in Comm.MessageQueue")
    self.semaphore.release()

