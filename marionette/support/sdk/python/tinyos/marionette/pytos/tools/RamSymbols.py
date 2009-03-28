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
RamSymbols.py -- a tool for poking and peeking ram symbols on motes.
To be used in conjunction with tinyos-1.x/contrib/nestfe/nesc/lib/RamSymbols

"""

import sys, string, time, types
from xml.dom import minidom
import pytos.util.nescDecls as nescDecls
import pytos.util.RoutingMessages as RoutingMessages
import pytos.Comm as Comm
import re
from copy import deepcopy

class RamSymbol( RoutingMessages.RoutingMessage ) :

  #this is the variable the determines, on a blocking rpc call, how
  #many messages will be queued up.  Should perhaps be bigger for large
  #networks, but will generally be the same number for all rpc
  #functions that use the same send and receive comm stacks.
  msgQueueSize = 10
  
  def __init__(self, xmlDefinition=None, parent=None) :
    if xmlDefinition==None :
      return
    self.pokeResponseMsg = None
    self.memAddress = int(xmlDefinition.getAttribute("address"))
    length = int(xmlDefinition.getAttribute("length"))
    typeDef = xmlDefinition.getElementsByTagName("type")[0]
    self.isPointer = typeDef.getAttribute("typeClass") == "pointer"
    self.isArray = xmlDefinition.hasAttribute("array")
    symbolType = parent.app.types[typeDef.getAttribute("typeName")]
    #if symbolType.size > parent.app.enums.MAX_RAM_SYMBOL_SIZE :
    if self.isPointer :
      symbolType = nescDecls.nescPointer(parent.app, symbolType)
    if self.isArray :
      if length % symbolType.size == 0 :
        numElements = length // symbolType.size
      else :
        raise Exception("Could not discern ram symbol array length")
      symbolType = nescDecls.nescArray(numElements, symbolType)
    structArgs = []
    if type(symbolType) == nescDecls.nescStruct :
      self.isStruct = True
      structArgs.append(symbolType)
    else :
      structArgs.append(xmlDefinition.getAttribute("name"))
      structArgs.append( ("value", symbolType) )
    #now initialize this command as a Message object (which is really a nescStruct)
    RoutingMessages.RoutingMessage.__init__(self, parent, 0, *structArgs)
    if self.isStruct :
      self.__dict__["name"] = xmlDefinition.getAttribute("name")
    if length != self.size :
        raise Exception("Ram symbol size incorrect")
    self.pokeResponseMsg = nescDecls.Message(self.memAddress, "PokeResponseMsg",
                                          ("value", parent.app.types.error_t))
   


  def poke(self, value=None, arrayIndex = None, dereference=False, **nameArgs) :
    if not self.parent.app.__dict__.has_key("RamSymbolsM") :
      raise Exception("You must include the contrib/hood/tos/lib/RamSymbols/RamSymbolsM module in your nesc application in order to poke or peek at ram symbols")
    func = self.parent.app.RamSymbolsM.poke
    if arrayIndex != None :
      if self.isArray :
        if dereference == True :
          if self.isPointer:
            ptr = self.value["value"].elementType
            newValue = deepcopy(ptr.value)
            func.symbol.memAddress = self.memAddress + ptr.size * arrayIndex
            func.symbol.length = newValue.size
          else :
            raise Exception("Dereferencing is only allowed for pointer types")
        else :
          newValue = deepcopy(self.value["value"].elementType)
          func.symbol.memAddress = self.memAddress + newValue.size * arrayIndex
          func.symbol.length = newValue.size
      else :
        raise Exception("Indexing a poke is only supported for arrays")
    elif dereference == True :
      if self.isPointer and self.isArray :
        raise Exception("Poke cannot be used to dereference an entire array of pointers")
      elif not self.isPointer :
        raise Exception("Dereferencing is only allowed for pointer types")
      newValue = deepcopy(self.value["value"].value)
      func.symbol.memAddress = self.memAddress
      func.symbol.length = newValue.size
    else : 
      if self.isArray and self.size > self.parent.app.ramSymbol_t.data.size :
          raise Exception("Array is too large for poking.  You must index the poke")
      if self.isStruct :
        newValue = deepcopy(self)
      elif self.isPointer :
        newValue = self.parent.app.types["unsigned int"]
      else :
        newValue = deepcopy(self.value["value"])
      func.symbol.memAddress = self.memAddress
      func.symbol.length = newValue.size
    if func.symbol.length > self.parent.app.types.ramSymbol_t.data.size :
      raise Exception("Ram symbol size too large for msg buffer")
    if value != None :
      newValue = self._assignParam(newValue, value, "value")
    newBytes = newValue.getBytes()
    oldBytes = func.symbol.data.getBytes()
    newBytes = oldBytes.replace(oldBytes[:func.symbol.length], newBytes, 1)
    func.symbol.data.setBytes(newBytes)
    func.symbol.dereference = dereference
    result = func(**nameArgs)
    if result != None:
      return map(self.parsePokeResponse, result)
    
  def parsePokeResponse(self, msg) :
    response = deepcopy(self.pokeResponseMsg)
    if msg.nescType == "RpcResponseMsg":
      response.value=0
      addr = msg.sourceAddress
    else :
      if msg.value["value"].value != self.memAddress and (not self.isArray or
          (msg.value["value"].value -self.memAddress) % self.value["value"].elementType.size !=0 or
          msg.memAddress >= self.memAddress + self.size * self.value["value"].elementType.size):
        raise Exception("Memory address mismatch in poke response")
      response.value = 1
      addr = msg.parentMsg.sourceAddress
    response.parentMsg = msg
    response.nescType = "".join( [self.nescType, ".poke(),  nodeID=%d"%addr] )
    return response




  def peek(self, arrayIndex = None, dereference=False, **nameArgs) :
    if not self.parent.app.__dict__.has_key("RamSymbolsM") :
      raise Exception("You must include the contrib/hood/tos/lib/RamSymbols/RamSymbolsM module in your nesc application in order to poke or peek at ram symbols")
    func = self.parent.app.RamSymbolsM.peek
    if arrayIndex != None :
      #change memaddress to memAddres + array index
      if self.isArray :
        if dereference :
          if self.isPointer :
            func.memAddress = self.memAddress + self.value["value"].elementType.size * arrayIndex
            #set length of memcpy to ptr dereferenced value
            func.length = self.value["value"].elementType.value.size
          else :
            raise Exception("Dereferencing a peek is only allowed for pointers")
        else :
          func.memAddress = self.memAddress + self.value["value"].elementType.size * arrayIndex
          func.length = self.value["value"].elementType.size
      else :
        raise Exception("Indexing a peek is only allowed for arrays")
    elif dereference :
      #if this is an array or ptrs, fail
      if self.isArray :
        raise Exception("peek cannot be used to dereference an array of pointers")
      func.memAddress = self.memAddress
      func.length = self.value["value"].size
    else :
      #if this is an array check if the whole thing will fit in the return msg
      if self.isArray and self.size > self.parent.app.types.ramSymbol_t.data.size :
        raise Exception("Array is too large for peeking.  You must index the peek")
      func.memAddress = self.memAddress
      func.length = self.size
    if func.length > self.parent.app.types.ramSymbol_t.data.size :
      raise Exception("Ram symbol size of %d too large for msg buffer of size %d; change in RamSymbols.h" % (func.length,self.parent.app.types.ramSymbol_t.data.size))
    func.dereference = dereference
    result = func(**nameArgs)
    if result != None :
      return map(self.parsePeekResponse, result)

  def parsePeekResponse(self, msg) :
    #create the response message depending on if was rpc error or not
    if msg.nescType == "RpcResponseMsg":
      response = nescDecls.Message(self.memAddress, "PeekErrorMsg",
                                  ("value", self.parent.app.types.error_t))
      response.value=app.enums.FAIL
      addr = msg.sourceAddress
    else:
      #choose the type depending on if the ramSymbol is the entire symbol or element of array
      if msg.length == self.size and msg.memAddress == self.memAddress :
        if self.isStruct :
          value = deepcopy(self)
        else :
          value = deepcopy(self.value["value"])
      elif (self.isArray and msg.length == self.value["value"].elementType.size and
            (msg.memAddress -self.memAddress) % self.value["value"].elementType.size ==0 and
            msg.memAddress < self.memAddress + self.size * self.value["value"].elementType.size):
        value = deepcopy(self.value["value"].elementType)
      elif (self.isArray and self.isPointer
            and msg.length == self.value["value"].elementType.value.size and
            (msg.memAddress -self.memAddress) % self.value["value"].elementType.value.size ==0 and
            msg.memAddress < self.memAddress + self.size * self.value["value"].elementType.size):
        value = deepcopy(self.value["value"].elementType.value)
      elif (self.isPointer
            and msg.length == self.value["value"].value.size and
            msg.memAddress == self.memAddress ) :
        value = deepcopy(self.value["value"].value)
      else :
        raise Exception("Memory address mismatch in peek response")
      #choose the type depending on whether calling func was peek or ptrPeek
      if self.isPointer :
        if msg.dereference :
          value = value.value
        else :
          value = self.parent.app.types["unsigned int"]
      #create the return message from type depending if it is a struct already or must be created
      if issubclass(type(value), nescDecls.nescStruct) :
        response = nescDecls.Message(self.memAddress, value)
      else :
        response = nescDecls.Message(self.memAddress, value.nescType,
                                    ("value", value))
      bytes = msg.data.getBytes()
      response.setBytes(bytes[:response.size])
      addr = msg.parentMsg.sourceAddress
    response.parentMsg = msg
    response.nescType = "".join( [self.nescType, ".peek(),  nodeID=%d"%addr])
    return response
  
  def __str__(self) :
    if self.isStruct :
      return "%20s : %s\n" % (self.nescType,self.name)
    else:
      return "%20s : %s\n" % (self.value["value"].nescType,self.nescType)

        
  def __deepcopy__(self, memo={}) :
    result = self.__class__()
    memo[id(self)] = result
    result.parent = self.parent
    for (callParam, defaultVal) in self.parent.defaultCallParams :
      result.__dict__[callParam] = deepcopy(self.__dict__[callParam], memo)
    nescDecls.Message.__init__(result, self.amType, self)
    return result    
    
                    
  def registerPeek(self, listener, comm=()) :
    self.parent.app.RamSymbolsM.peek.register(SymbolResponseListener(listener, self.parsePeekResponse, self.__call__.__hash__), *comm)
    
  def unregisterPeek(self, listener, comm=()) :
    self.parent.app.RamSymbols.peek.unregister(SymbolResponseListener(listener, self.parsePeekResponse, self.__call__.__hash__), *comm)

  def registerPoke(self, listener, comm=()) :
    self.parent.app.RamSymbolsM.poke.register(SymbolResponseListener(listener, self.parsePokeResponse, self.__call__.__hash__), *comm)
    
  def unregisterPoke(self, listener, comm=()) :
    self.parent.app.RamSymbolsM.poke.unregister(SymbolResponseListener(listener, self.parsePokeResponse, self.__call__.__hash__), *comm)
   



class SymbolResponseListener( ):

  def __init__(self, listener, parseFunction, hashFunction ):
    self.parseFunction = parseFunction
    self.listener = listener
    self.hashFunction = hashFunction()
    
  def __cmp__(self, other):
    if self.listener == other.listener:
      return 0
    return 1

  def __hash__(self):
    if not self:
      return 0
    return self.hashFunction

  def receive( self , addr , msg ) :
    try:
      msg = self.parseFunction(msg)
      self.messageListener.messageReceived(addr, msg)
    except Exception, e:
      pass
          


  
class RamSymbols( RoutingMessages.RoutingMessages) :
  """A container class from which to find all ram symbols.

  """
  
  def __init__(self, app, sendComm=None, receiveComm=None, tosbase=True, xmlFileDOM=None, **callParams) :
    """ Find function defs in nescDecls.xml file and create function objects."""
    if not "ramSymbol_t" in app.types._types :
      print "The RamSymbolsM module was not compiled in.  No ram symbols will be imported."
    RoutingMessages.RoutingMessages.__init__(self, app)
    self.defaultCallParams = ( ("address", None), ("returnAddress", None),
                        ("timeout", 1), ("blocking", True), ("responseDesired", True) )
    self.initializeCallParams(callParams)
    self.tooLarge = []
    self.sizeIncorrect = []
    self.noType = []
    self.arraySizeIncorrect = []
    if xmlFileDOM == None:
      xmlFileDOM = minidom.parse(nescDecls.findBuildFile(buildDir, "nescDecls.xml"))
    symbols, = xmlFileDOM.childNodes[0].getElementsByTagName("ramSymbols")
    symbols = [node for node in symbols.childNodes if node.nodeType == 1]
    regexp = re.compile("\w+\.\w+")
    for symbolDef in symbols: 
      try :
          if (not regexp.match(symbolDef.getAttribute("name"))):
            # If the identifier is not of form Module.variable, then it is defined in a .c/.h file and not in a
            # nesc module. Add it to the "Globals" pseudo-module.
            symbolDef.setAttribute("name", "Globals."+symbolDef.getAttribute("name"))
          self._messages[symbolDef.getAttribute("name")] = RamSymbol(symbolDef, self)
      except Exception, e:
          if len(e.args) > 0 and e.args[0].find("No type") == 0:
              self.noType.append(symbolDef)
          elif len(e.args) > 0 and e.args[0].find("Could not discern") == 0:
              self.arraySizeIncorrect.append(symbolDef)
          elif len(e.args) > 0 and e.args[0].find("Ram symbol size too large") == 0:
              self.tooLarge.append(symbolDef)
          elif len(e.args) > 0 and e.args[0].find("Ram symbol size incorrect") == 0:
              self.sizeIncorrect.append(symbolDef)
          else :
              raise
    #self.printSkippedSymbols()
  def printSkippedSymbols(self) :
    err = ""
    if len(self.tooLarge) >0 :
      err += "\nWarning: %d ram symbols were too large for %d byte packet.\n" % (len(self.tooLarge), self.app.types.ramSymbol_t.data.size )
      for symbol in self.tooLarge :
        err += "\t%s\n" % symbol.getAttribute("name")
    if len(self.sizeIncorrect) >0 :
      err += "\nWarning: The size of the following ram symbols does not match the size of the discovered type:\n"
      for symbol in self.sizeIncorrect :
        err += "\t%s\n" % symbol.getAttribute("name")
    if len(self.noType) >0 :
      err += "\nWarning: No type was found for the following ram symbols:\n"
      for symbol in self.noType :
        err += "\t%s\n" % symbol.getAttribute("name")
    if len(self.arraySizeIncorrect) >0 :
      err += "\nWarning: The following ram symbols are arrays with length not a multiple of the type size:\n"
      for symbol in self.arraySizeIncorrect :
        err += "\t%s\n" % symbol.getAttribute("name")
    if len(err) > 0 : print err
