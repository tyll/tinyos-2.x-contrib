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

import sys
import pytos.Comm as Comm         
import pytos.tools.Drain as Drain         
import pytos.tools.Drip as Drip         
import threading

def registerAllMsgs(msgs, msgQueue, connection) :
  for msgName in msgs._msgNames :
    msg = msgs[msgName]
    connection.register( msg , msgQueue )
        
class MessageSnooper( object ) :
  """This module offers \"register\" and \"unregister\" functions that
  take a messageHandler argument but no message type argument.
  Instead, the messageHandler will receive ALL incoming messages.  It
  currently handles local receive, drain messages, rpc messages, and
  ramSymbol messages.  Any new routing protocols should be
  incorporated into this module.

  usage:
  snooper = MessageSnooper(app)
  snooper.start
  snooper.stop
  snooper.register(callbackFcn)
  snooper.unregister(callbackFcn)
  """
   
  def __init__( self , app="" ) :

    self.app = app
    self.listeners = []

    msgQueue = Comm.MessageQueue(10)
        
    #register the msgQueue for all message types with localComm
    comm = Comm.getCommObject(self.app, self.app.motecom)
    registerAllMsgs(self.app.msgs, msgQueue, comm)

    #register the msgQueue for all message types with drain and unregister DrainMsg with localComm
    if "AM_DRAINMSG" in self.app.enums._enums :
      drains = Drain.getDrainObject(self.app)
      for drain in drains:
        registerAllMsgs(self.app.msgs, msgQueue, drain)
      comm.unregister(self.app.msgs.DrainMsg, msgQueue)

    #if rpc is imported
    if self.app.__dict__.has_key("rpc") :
      #make sure a drip object exists for snooping on cmds
      drips = Drip.getDripObject(self.app, self.app.motecom, self.app.enums.AM_RPCCOMMANDMSG)
      #register the msgQueue for all rpc response messages
      for command in self.app.rpc._messages.values() :
        command.register(msgQueue)
      #and unregister RpcResponseMsg from drain
      drains = Drain.getDrainObject(self.app, self.app.motecom, 0xfffe) #ugh... hard coded number
      for drain in drains:
        drain.unregister(app.msgs.RpcResponseMsg, msgQueue)
      #if ram symbols is imported
      if self.app.__dict__.has_key("ramSymbols") :
        #register the msgQueue for all ram symbol response messages
        for symbol in self.app.ramSymbols._messages.values() :
          symbol.registerPeek(msgQueue)
          symbol.registerPoke(msgQueue)
        #and unregister from peek/poke rpc commands
        self.app.RamSymbolsM.peek.unregister(msgQueue)
        self.app.RamSymbolsM.poke.unregister(msgQueue)

    #register the msgQueue for all message types with drip and unregister DripMsg with localComm
    if "AM_DRIPMSG" in self.app.enums._enums :
      drips = Drip.getDripObject(self.app)
      for drip in drips:
        print "actually dtrying to register dripmsgs\n"
        registerAllMsgs(self.app.msgs, msgQueue, drip)
      comm.unregister(self.app.msgs.DripMsg, msgQueue)

    self.running = True
    msgThread = threading.Thread(target=self.processMessages,
                                 args=(msgQueue,))
    msgThread.setDaemon(True)
    msgThread.start()

  def processMessages(self, msgQueue) :
    while True :
      (addr,msg) = msgQueue.get()
      if self.running == True :
        for listener in self.listeners :
          listener.messageReceived(addr, msg)

  def stop(self) :
      self.running = False

  def start(self) :
      self.running = True

  def register(self, msgHandler) :
    self.listeners.append(msgHandler)
    
  def unregister(self, msgHandler) :
    self.listeners.remove(msgHandler)
