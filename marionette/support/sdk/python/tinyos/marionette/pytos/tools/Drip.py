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

from jpype import JPackage, JInt
from pytos.util.JavaInheritor import JavaInheritor
import pytos.Comm as Comm
from  copy import *

drip = JPackage("net.tinyos.drip")

def getDripObject(app, motecom=None, channel=None) :
  """This function returns the drip object stored in app that is connected to optional motecom
  with a optional channel.  If motecome and channel are specified but there is no drip object
  with these specs, it creates one"""
  drips = []
  for conn in app.connections :
    if isinstance(conn, Drip) :
#      if motecom == None or conn.motecom == motecom :                       #we need this funtion in java
#        if channel == None or drip.channel == channel :  #we need this funtion in java
          drips.append( conn )
  if len(drips) == 0 and motecom != None and channel != None :
      drip = Drip(app, channel, app.motecom)
      app.connections.append(drip)
      drips.append(drip)
  return drips
  

class Drip( JavaInheritor ) :
    """The Drip object inherits from the Drip.java object.  It overrides the
    constructor, and the send and sendwakeup commands to handle python TosMsg objects.

    usage:
      drip = Drip(app, Channel, 'sf@localhost:9001')
      drip = Drip(app, Channel, moteif)  
      drip.send(myTosMsg)
      drip.sendWakeup(myTosMsg)
      ... (plus all other functions inherited from the java object)

    For interface-compatbility with comm, you can also send a dest address, which is ignored:
      drip.send(addr, myTosMsg)
    """
    
    def __init__( self , app, channel, moteIF ) :
        self.app = app
        if type(moteIF) == str :
            moteIF = Comm.openMoteIF(moteIF, app)
        dripObj = drip.Drip(channel, moteIF)
        JavaInheritor.__init__(self, (dripObj,) )

    def send( self , msg, *comm ) :
        #For interface-compatbility with comm, you can also send a dest address, which is ignored:
        if type(msg) == int and len(comm) > 0:
            msg = comm[0]
        migMsg = msg.createMigMsg()
        self.migMsgSend(migMsg, msg.size)

    def sendWakeup( self , msg, *comm ) :
        migMsg = msg.createMigMsg()
        self.migMsgSendWakeup(migMsg, msg.size)
      
    def migMsgSend( self , msg, size, *comm ) :
        self._javaParents[0].send(msg, JInt(size))

    def migMsgSendWakeup( self , msg, size, *comm ) :
        self._javaParents[0].sendWakeup(msg, size)
      

    def register( self , msg , callback, *comm ) :
        comm = Comm.getCommObject(self.app)
        comm.register(self.app.msgs.DripMsg, DripMsgPeeler(self.app, msg, callback))

    def unregister( self , msg , callback , *comm ) :
        comm = Comm.getCommObject(self.app)
        comm.unregister(self.app.msgs.DripMsg, DripMsgPeeler(self.app, msg, callback))

    def getCommObject(self, motecom) :
      """This function returns the comm object stored in app.  If there
      is none, it creates one"""
      for conn in self.app.connections :
          if isinstance(conn, Comm.Comm) :
              if motecom not in conn._connected :
                  conn.connect(motecom)
              return conn
      comm = Comm.Comm()
      comm.connect(self.motecom)
      self.app.connections.append(comm)
      return comm
    
class DripMsgPeeler( Comm.MessageListener ) :
  """This is a wrapper callback object that peels the Drip headers out
  of a DripMsg mig object and creates a python TosMsg with the remaining data """

  def __init__(self, app, msg, callback) :
    self.app = app
    self.msg = msg
    Comm.MessageListener.__init__(self, callback )
    self._firstHashFunction = self._hashFunction
    self._hashFunction = self._combinedHash

  def _combinedHash(self):
    return self._firstHashFunction() + self.msg.amType  #this will have to change
    
  def messageReceived( self , addr , dripMsg ) :
      if dripMsg.metadata.id == self.msg.amType :
          try:
              msg = deepcopy(self.msg)
              bytes = dripMsg.data.getBytes()
              msg.setBytes( bytes )
              msg.parentMsg = dripMsg
              self.callback( addr, msg ) 
          except Exception, inst:
              print inst
              raise
