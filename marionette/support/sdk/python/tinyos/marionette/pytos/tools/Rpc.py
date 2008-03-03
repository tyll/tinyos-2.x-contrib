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

"""\
Rpc.py -- a tool for calling rpc functions on motes.
To be used in conjunction with tinyos-1.x/contrib/hood/tos/lib/Rpc.

rpc = Rpc(\"./apps/TestRpc/build/pc/foo.xml\")
rpc.redOn()
rpc.redOff()
rpc.myfunc(101,'abc')

or

f=rpc.myfunc
f.firstParam = 101
f.secondParam = 'abc'
f()
"""

import sys, string, time, types, os
from xml.dom import minidom
import pytos.util.nescDecls as nescDecls
import pytos.util.RoutingMessages as RoutingMessages
import pytos.Comm as Comm 
from copy import deepcopy

class RpcFunction( RoutingMessages.RoutingMessage ) :
  """a callable TosMsg used to interact with the rpc.nc module.  On
  being called, either with positional or named arguments, this
  object will fill in the params given, pack up a message and send
  it off using comm.send.  Named arguments can have the names of the
  param names.  Any params not specified will have default values as
  specified by the initialization semantics of nescDecls.nescStruct
  (zero).  Optional named parameter \"comm\" can be used to pass
  arguments to the comm.send function.
  
  usage:
  rpcFunction.param = X
  rpcFunction()
  rpcFunction(X, Y, Z)
  rpcFunction(p1=X, p2=Y, p3=Z)
  rpcFunction(X, p3=Z, p2=Y)
  rpcFunction(X, p3=Z, p2=Y, comm=['COM1','COM2',...])
  """

  #this is the variable the determines, on a blocking rpc call, how
  #many messages will be queued up.  Should perhaps be bigger for large
  #networks, but will generally be the same number for all rpc
  #functions that use the same send and receive comm stacks.
  msgQueueSize = 10
  
  def __init__(self, xmlDefinition=None, parent=None) :
    if xmlDefinition==None :
      return
    self.responseMsg = None
    #start creating the arguments to the nescStruct constructor.
    #first, add the command msg name and the rpc headers
    structArgs = []
    structArgs.append(xmlDefinition.tagName)
    structArgs.append( ("rpcHeader", parent.app.types.RpcCommandMsg) )
    #then, add each parameter as a new msg field 
    for i in range(int(xmlDefinition.getAttribute("numParams"))) :
      param = xmlDefinition.getElementsByTagName("param%d" % i)
      paramName = param[0].getAttribute("name")
      paramType = parent.app.types[
        param[0].getElementsByTagName("type")[0].getAttribute("typeName")]
      structArgs.append( (paramName, paramType) )
    #now initialize this command as a TosMsg object (which is really a nescStruct)
    RoutingMessages.RoutingMessage.__init__(self, parent,
                                            parent.app.enums.AM_RPCCOMMANDMSG, *structArgs)
    #fill in the header fields once and for all
    self.rpcHeader.commandID = int(xmlDefinition.getAttribute("commandID"))
    self.rpcHeader.dataLength = self.size - self.rpcHeader.size
    #turn the response type into a response msg (to be received by the user)
    responseType = parent.app.types[
      xmlDefinition.getElementsByTagName("returnType")[0].getAttribute("typeName")]
    if issubclass(type(responseType), nescDecls.nescStruct) :
      self.responseMsg = nescDecls.TosMsg(self.rpcHeader.commandID, responseType)
    else :
      self.responseMsg = nescDecls.TosMsg(self.rpcHeader.commandID, responseType.nescType,
                                          ("value", responseType))

  def __call__(self, *posArgs, **nameArgs) :
    if not self.parent.app.__dict__.has_key("RpcM") :
      raise Exception("You must include the contrib/hood/tos/lib/Rpc/RpcM module in your nesc application in order to use rpc commands")
    commArgs = ()
    callParams = self.parseCallParams(nameArgs)
    self.rpcHeader.transactionID = (self.rpcHeader.transactionID+1) % 256
    thisCall = deepcopy(self)
    thisCall.rpcHeader.address = callParams["address"]
    thisCall.rpcHeader.returnAddress = callParams["returnAddress"] 
    thisCall.rpcHeader.responseDesired = callParams["responseDesired"]

    #If this is a blocking call, get ready to process response msgs for timeout time
    processMsgs = False
    if callParams["blocking"] ==True \
           and callParams["timeout"] > 0 \
           and callParams["responseDesired"]==True:
      responseQueue = Comm.MessageQueue(self.msgQueueSize)
      self.register(responseQueue)
      processMsgs = True

    thisCall._send(callParams["address"], *posArgs, **nameArgs)

    if processMsgs :
      startTime = time.time()
      responses = []
      while time.time() - startTime <= callParams["timeout"] :
        try:
          (addr,msg) = responseQueue.get(True, 0.1) #why 0.1?
          if msg.nescType == "RpcResponseMsg" :
            rxdTransactionID = msg.transactionID
          else :
            rxdTransactionID = msg.parentMsg.transactionID
          if rxdTransactionID == thisCall.rpcHeader.transactionID :
            responses.append(msg)
        except Exception, e:
          if len(e.args) >0 :
            print "rpc error: %s" % str(e)
      self.unregister(responseQueue)
      return responses
    
  def __str__(self) :
    """print function signature"""
    string = "%21s %s( " % (self.responseMsg.nescType, self.nescType)
    for field in self.fields[1:] :
      string += " %s %s," % ( self.value[field["name"]].nescType,
                              field["name"] )
    if len(self.fields) >0 :
      string += "\b"
    string += " )\n"
    return string

  def __deepcopy__(self, memo={}) :
    result = self.__class__()
    memo[id(self)] = result
#    result.rpcHeader = deepcopy(self.rpcHeader, memo)
    result.responseMsg = deepcopy(self.responseMsg, memo)
    result.parent = self.parent
    for (callParam, defaultVal) in self.parent.defaultCallParams :
      result.__dict__[callParam] = deepcopy(self.__dict__[callParam], memo)
    nescDecls.TosMsg.__init__(result, self.amType, self)
    return result    
    
  def printCurrentValues(self) :
    print nescDecls.TosMsg.__str__(self)
                    
  def register(self, listener, comm=()) :
    self.parent.receiveComm.register(self.parent.app.msgs.RpcResponseMsg,
                              RpcResponseListener(self.parent.app, self.responseMsg,
                                                  listener, self.nescType, self.__call__.__hash__), *comm)
    
  def unregister(self, listener, comm=()) :
    self.parent.receiveComm.unregister(self.parent.app.msgs.RpcResponseMsg,
                                RpcResponseListener(self.parent.app, self.responseMsg,
                                                    listener, self.nescType, self.__call__.__hash__), *comm)




class RpcResponseListener( Comm.MessageListener ):

  def __init__(self, app, responseMsg, callback, rpcName, hashFunction ):
    self.app = app
    self.responseMsg = responseMsg
    self.rpcName = rpcName
    self._secondHashFunction = hashFunction
    Comm.MessageListener.__init__(self, callback)
    self._firstHashFunction = self._hashFunction
    self._hashFunction = self._combinedHash

  def _combinedHash(self):
    return self._firstHashFunction() + self._secondHashFunction()
  
  def messageReceived( self , addr , msg ) :
    if msg.commandID == self.responseMsg.amType :
      if msg.errorCode == self.app.enums.RPC_SUCCESS :
        response = deepcopy(self.responseMsg)
        response.setBytes( msg.data.getBytes() )
        response.parentMsg = msg
        response.nescType = "".join( [self.rpcName,
                                      ",  nodeID=%d"%response.parentMsg.sourceAddress] )
        self.callback( addr, response )
      else :
        self.callback( addr, msg)
          

  
  
class Rpc( RoutingMessages.RoutingMessages) :
  """A container class from which to call all rpc functions.

  usage:
    rpc = Rpc(sendComm, receiveComm, '/path/to/rpcSchema.xml')
    print rpc
    rpc.module.interface.function(args)
    rpc.module.function(args)
  """
  
  def __init__(self, app, sendComm=None, receiveComm=None, tosbase=True, **callParams) :
    """ Find function defs in rpcSchema.xml file and create function objects."""
    # Check for the rpcSchema.xml file
    try :
      xmlFilename = nescDecls.findBuildFile(app.buildDir, "rpcSchema.xml")
    except:
      raise Exception("""\nWARNING: cannot find file \"rpcSchema.xml\".  No rpc commands will be imported.""")

    RoutingMessages.RoutingMessages.__init__(self, app)

    self.defaultCallParams = ( ("address", None), ("returnAddress", None),
                        ("timeout", 1), ("blocking", True), ("responseDesired", True) )
    self.initializeCallParams(callParams)

    schema = minidom.parse(nescDecls.findBuildFile(app.buildDir, "rpcSchema.xml"))
    functions, = schema.childNodes[0].getElementsByTagName("rpcFunctions")
    functions = [node for node in functions.childNodes if node.nodeType == 1]
    for funcDef in functions: 
      self._messages[funcDef.tagName] = RpcFunction(funcDef, self)

