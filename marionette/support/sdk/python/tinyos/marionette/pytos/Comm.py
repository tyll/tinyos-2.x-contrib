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

import sys, os, string, types
from jpype import JPackage, JObject, JProxy
from Queue import Queue
import threading
import pytos.util.nescDecls as nescDecls
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

def migTosMsgInvariant( msg, messageListener) :
  """This function takes either a mig or TosMsg object (with a Comm.MessageListener Object)
  and returns a mig message (with Comm.MessageListener Object)"""
  if issubclass(type(msg), nescDecls.TosMsg) :
    messageListener = Mig2TosMsgConverter(msg, messageListener)
    msg = msg.createMigMsg()
  return (msg, messageListener)

def createJavaMessageListener(messageListener) :
  """This function will take a Comm.MessageListener object
  and returns a java MessageListener object"""
  messageListener = JProxy( JPackage("net.tinyos.pytos").HashableMessageListener , inst = messageListener  )
  messageListener = JPackage("net.tinyos.pytos").MessageListenerObject(messageListener)
  return messageListener

def wrapCallbackAndTosMsg( msg, callback) :
  messageListener = MessageListener(callback)
  (msg, messageListener) = migTosMsgInvariant(msg, messageListener)
  messageListener = createJavaMessageListener(messageListener)
  return (msg, messageListener)

def openMoteIF(sourceName, app) :

  #tinyos = JPackage("net.tinyos")
  BuildSource = JPackage("net.tinyos.packet").BuildSource
  messenger = JObject( None, JPackage("net.tinyos.util").Messenger )
  source = BuildSource.makePhoenix( sourceName, messenger )
  source.setPacketErrorHandler( JPackage("net.tinyos.pytos").PyPhoenixError(source) )

  if app != None and "TOS_DEFAULT_AM_GROUP" in app.enums._enums :
    moteif = JPackage("net.tinyos.message").MoteIF( source, app.enums.TOS_DEFAULT_AM_GROUP )
  else :
    moteif = JPackage("net.tinyos.message").MoteIF( source )

  #if source.isAlive() :
    #moteif.start()
  #else :
    #raise RuntimeError, "could not open MoteIF %s" % sourceName

  return moteif



class MoteIFCache(object) :

  def __init__(self, parent) :
    self._moteif = {}
    self.parent=parent

  def get( self , sourceStr ) :
    if self.isAlive( sourceStr ) :
      return self._moteif[ sourceStr ]

    self._moteif[ sourceStr ] = openMoteIF( sourceStr, self.parent.app )
    return self._moteif[ sourceStr ]

  def isAlive( self , sourceStr ) :
    if self.has( sourceStr ) :
      if self._moteif[ sourceStr ].getSource().isAlive() :
	return True
    return False

  def has( self , sourceStr ) :
    if self._moteif.has_key( sourceStr ) :
      return True
    return False

  def destroy( self , sourceStr ) :
    if self.has( sourceStr ) :
      # FIXME : this throws an exception that I cannot catch or print from being displayed
      self._moteif[ sourceStr ].getSource().shutdown()
      del self._moteif[ sourceStr ]



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
    if issubclass(type(msg), nescDecls.TosMsg) :
      msg = msg.createMigMsg()
    moteComStr = self.completeMoteComStr("ExistingPorts", *moteComStr)
    for mc in moteComStr :
      # FIXME : send expects a Message, but only the TOSMsg subclass has set_addr
      self._moteifCache.get(mc).send( addr , msg )

  def register( self , msg , callback , *moteComStr ) :
    """Register a function or an object to receive arriving messages.
    If an object is registered, it must implement the MessageListener
    interface, meaning it must have a messageReceived( self , addr ,
    msg ) method.  If a function is registered, it must accept two
    arguments: addr,msg"""

    (msg, messageListener) = wrapCallbackAndTosMsg(msg, callback)
    moteComStr = self.completeMoteComStr("ExistingPorts", *moteComStr)
    for mc in moteComStr :
      self._moteifCache.get(mc).registerListener( msg , messageListener )

  def unregister( self , msg , callback , *moteComStr ) :
    (msg, messageListener) = wrapCallbackAndTosMsg(msg, callback)
    moteComStr = self.completeMoteComStr("ExistingPorts", *moteComStr)
    for mc in moteComStr :
      self._moteifCache.get(mc).deregisterListener( msg , messageListener )

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

  
class MessageListener( object ) :
  """This function takes one of:
  1.  another MessageListener object
  2.  a python object with a messageReceived method
  3.  a python messageReceived method itself
  and wraps it as a java-hashable python object"""

  def __init__(self, callback) :
    if issubclass( type ( callback) , MessageListener ) :
      self.callback = callback.messageReceived
      self._hashFunction = callback._hashFunction
    elif isinstance( callback, (types.FunctionType,types.MethodType) ) :
      self.callback = callback
      self._hashFunction = callback.__hash__
    elif isinstance( callback ,(types.InstanceType,types.ObjectType) ) and \
             "messageReceived" in list(dir(callback)) :
      self.callback = callback.messageReceived
      self._hashFunction = self.callback.__hash__
    else :
      raise Exception("Object is neither messageListener object nor messageReceived method")
   
  def messageReceived( self , addr , msg ) :
    self.callback(addr, msg)

  def hashCode(self):
    return self._hashFunction()
  
class Mig2TosMsgConverter( MessageListener ) :
  """This is a MessageListener object that takes a python TosMsg object and will convert
  an incoming java mig message that TosMsg.  \"Callback\" is the same as for MessageListener."""

  def __init__(self, msg, callback) :
    self.msg = msg
    MessageListener.__init__(self, callback)
    
  def messageReceived( self , addr , msg ) :
    tmpMsg = deepcopy(self.msg)
    tmpMsg.parseMigMsg(msg)
    msg = tmpMsg
    self.callback( addr, msg )

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

