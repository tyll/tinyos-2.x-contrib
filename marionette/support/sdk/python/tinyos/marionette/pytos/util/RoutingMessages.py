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
# @author Michael Okola (TinyOS 2.x porting)
#

"""\
RoutingMessages:  This is a package of classes that have some functionality
commonly used by routing messages, eg. Rpc and RamSymbol.
This class is not intended to be used on its own.
"""

import sys, string, time, types
import pytos.util.nescDecls as nescDecls
import pytos.Comm as Comm
#import pytos.tools.Drip as Drip
#import pytos.tools.Drain as Drain
from copy import deepcopy

class RoutingMessage( nescDecls.Message ) :

  def __init__(self, parent, amType, *structArgs) :
    #store the parent
    self.parent = parent
    #initialize the default call parameters to none (ie, use the parent's defaults)
    for (callParam,default) in self.parent.defaultCallParams :
      self.__dict__[callParam] = None
    nescDecls.Message.__init__(self, parent.app.enums.AM_RPCCOMMANDMSG, *structArgs)

  def _assignParam(self, field, param, paramId) :
    """assign a call parameter to the correct field (checking types)"""
    if type(field) == nescDecls.nescType and (
       type(param) == int or type(param) == long or
       type(param) == float or type(param) == str or
       type(param) == unicode ) :
      field.value = param
    elif type(field) == type(param): #FIX: check other types here, eg.: field.nescType == param.nescType:
      field = param
    else :
      raise Exception("Illegal parameter type for param #%s.  Requires type %s." % (
        str(paramId), str(type(field))) )
    return field
  
  def _send(self, address, *posArgs, **nameArgs) :
    commArgs = ()
    
    #posArgs and nameArgs now contain only field values.
    #now assign them to the appropriate RoutingMessage fields.
    #create a temporary RoutingMessage to hold the call-time parameters
    thisCall = deepcopy(self)
    for i in range(len(posArgs)) :
      thisCall.value[thisCall.fields[i+1]["name"]]=thisCall._assignParam(thisCall.value[thisCall.fields[i+1]["name"]], posArgs[i], i)
    for key in nameArgs.keys() :
      if not thisCall.value.has_key(key) :
        raise Exception("parameter name %s non-existent" % key)
      thisCall._assignParam(thisCall.value[key], nameArgs[key], key)
    thisCall.parent.sendComm.send(address, thisCall, *commArgs)
      
  def parseCallParams(self, nameArgs) :
    callParams = self.getCallParams()
    #parse any call-time call parameters
    for param in nameArgs.keys() :
      if callParams.has_key(param) :
        callParams[param] = nameArgs[param]
        del nameArgs[param]
    return callParams


  def getCallParams(self) :
    """Use the default call parameters from the parent module, but if I have the same
    field with a non-None value, use it instead"""

    callParams = self.parent.getCallParams()
    for param in callParams.keys() :
      if self.__dict__.has_key(param) and self.__getattribute__(param) != None :
        callParams[param] = self.__getattribute__(param)
    return callParams

  def __repr__(self) :
    """full function name"""
    return "%s object at %s:\n\n%s" % (self.__class__, hex(id(self)), str(self))
    
  def register(self, listener, comm=()) :
    self.parent.receiveComm.register(self, listener, *comm)
    
  def unregister(self, listener, comm=()) :
    self.parent.receiveComm.unregister(self, listener, *comm)


class Shortcut (object):
  """used to allow multiple levels of indirection w/routing messages using dots;
  ie., to allow something.module.interface.RoutingMessage()"""

  def __init__(self, parent, name):
    self.parent = parent
    self.name = name

  def __getattr__(self, name) :
    name = self.name + "." + name
    if self.parent._messages.has_key(name) :
      return self.parent._messages.get(name)
    else :
      for message in self.parent._messages.values() :
        if message.nescType.find(name+".") == 0 :
          return Shortcut(self.parent,name)
      raise Exception("Cannot find %s. Check spelling." % name)

  def __repr__(self):
    return "%s object at %s:\n\n%s" % (self.__class__, hex(id(self)), str(self))
  
  def __str__(self):
    string = ""
    funcs = ()
    messageNames = self.parent._messages.keys()
    messageNames.sort()
    for message in messageNames :
      if message.find(self.name) == 0 :
        string += str(self.parent._messages[message])
    string = string.replace(self.name + "." , "" )
    return string


  
class RoutingMessages(object) :
  
  def __init__(self, app) :

    self.app = app
    self._messages = {}

    ## In this constructor, we connect to the routing layer as best as
    ## we can.  This may mean creating new drip/drain instances,
    ## reusing old ones, reusing old Comm objects, or not connecting
    ## at all, depending...

    if app.motecom == None:
      return

    #connect to sendComm: use localComm if user requested or if drip not compiled in.
    self.address=app.enums.AM_BROADCAST_ADDR
    if app.localCommOnly==True or "AM_DRIPMSG" not in app.enums._enums:
      self.sendComm = Comm.getCommObject(app, app.motecom)
    else :
      self.sendComm = Drip.getDripObject(app, app.motecom, app.enums.AM_RPCCOMMANDMSG)[0]

    #connect to receiveComm: always use Drain unless not compiled in
    if "AM_DRAINMSG" not in app.enums._enums:
      self.receiveComm = Comm.getCommObject(app, app.motecom)
      self.returnAddress = app.enums.AM_BROADCAST_ADDR
    else :
      treeID = 0xfffe                                        #can we set this automatically?
      self.receiveComm = Drain.getDrainObject(app, app.motecom, treeID)[0]
      if app.localCommOnly == False :
        self.receiveComm.maintainTree()
      if app.tosbase==True:                                  #can we discover this like deluge?
        self.returnAddress = treeID
      else :
        self.returnAddress = app.enums.TOS_UART_ADDR
  

    
  def initializeCallParams(self, callParams) :
    for (callParam,defaultVal) in self.defaultCallParams :
      if callParams.has_key(callParam) :
        self.__dict__[callParam] = callParams[callParam]
      elif not self.__dict__.has_key(callParam):
        self.__dict__[callParam] = defaultVal

  def getCallParams(self) :
    callParams = {}
    for (callParam,default) in self.defaultCallParams :
      callParams[callParam] = self.__dict__[callParam]
    return callParams

  def __getattr__(self, name) :
    for function in self._messages.values() :
      if function.nescType.find(name + ".") == 0 :
        return Shortcut(self,name)
    raise AttributeError("No such attribute %s" % name)
    
  def __repr__(self) :
    return "%s object at %s:\n\n%s" % (self.__class__, hex(id(self)), str(self))
  
  def __str__(self) :
    """ Print all available RoutingMessages."""
    string = ""
    keys = self._messages.keys()
    keys.sort()
    for name in keys :
      string += str( self._messages[name])
    return string

