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

from jpype import JPackage, JProxy, JavaException, JException           
from pytos.util.JavaInheritor import JavaInheritor
import pytos.Comm as Comm
import struct, types
import thread
import pytos.util.nescDecls as nescDecls
from copy import deepcopy

drain = JPackage("net.tinyos.drain")

def getDrainObject(app, motecom=None, treeID=None) :
  """This function returns the drain objects stored in app that is connected to optional motecom
  with a optional treeID.  If motecome and treeID are specified but there is no drain object
  with these specs, it creates one"""
  drains = []
  for conn in app.connections :
    if isinstance(conn, Drain) :
#       if motecom==None or conn.motecom == motecom :                       #we need this funtion in java
#        if treeID=None or conn.treeID == treeID :                          #we need this funtion in java
          drains.append( conn )
  if len(drains)==0 and motecom != None and treeID != None :
    drain = drain.Drain(app, treeID, app.motecom)
    drain.delay=60            #rebuild every 5 mins          #can we make this a parameter?
    drain.forever=True
    drain.VERBOSE=False
    app.connections.append(drain)
    drains.append(drain)
  return drains

class Drain( JavaInheritor ) :
    """The Drain object inherits from both the Drain.java and
    the DrainConnector.java objects, in that order.  It overrides the
    constructors to construct both objects from the same comm objects and
    provides register/unregister methods to handle python TosMsg objects.

    usage:
      drain = Drain(app, spAddr, 'sf@localhost:9001')
      drain = Drain(app, spAddr, moteif)  
      drain.register(myTosMsg, myMsgQueue)
      drain.unregister(myTosMsg, myMsgQueue)
      ... (plus all other functions inherited from the java objects)
    """
    
    def __init__( self , app, spAddr, moteIF ) :
        if type(moteIF) == str :
            moteIF = Comm.openMoteIF(moteIF, app)
        drainObj = drain.Drain(spAddr, moteIF)
        drainConnectorObj = drain.DrainConnector(spAddr, moteIF)
        self.app = app #save for later use
        JavaInheritor.__init__(self, (drainObj, drainConnectorObj) )

    def register( self , msg , callback, *comm ) :
        (num, callback) = self._wrapCallbackAndTosMsg(msg, callback)
        self.registerListener( num , callback )

    def unregister( self , msg , callback , *comm ) :
        (num, callback) = self._wrapCallbackAndTosMsg(msg, callback)
        self.deregisterListener( num , callback )

    def _wrapCallbackAndTosMsg(self, msg, callback) :
        callback = DrainMsgPeeler(self.app, msg, callback)
        callback = Comm.createJavaMessageListener(callback)
        num = msg.amType
        return (num, callback)
    
class DrainMsgPeeler( Comm.Mig2TosMsgConverter ) :
  """This is a wrapper callback object that peels the Drain headers out
  of a DrainMsg mig object and creates a python TosMsg with the remaining data """

  def __init__(self, app, msg, callback) :
    self.drainMsg = nescDecls.TosMsg(app.enums.AM_DRAINMSG, app.types.DrainMsg)
    Comm.Mig2TosMsgConverter.__init__(self, msg, callback )
    
  def messageReceived( self , addr , migMsg ) :
      try:
          drainMsg = deepcopy(self.drainMsg)
          drainMsg.parseMigMsg(migMsg)
          msg = deepcopy(self.msg)
          bytes = drainMsg.data.getBytes()
          msg.setBytes( bytes )
          msg.parentMsg = drainMsg
          self.callback( addr, msg ) 
      except Exception, inst:
          print inst
          raise
      
