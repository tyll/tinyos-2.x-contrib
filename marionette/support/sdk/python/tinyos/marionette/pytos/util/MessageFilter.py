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

import sys, re
import pytos.Comm as Comm         
import pytos.util.KeyPress as KeyPress
import threading

def userMenu( menu ):
  """A generic function to print menus and return the result"""
  
  (banner, choices) = menu
  print banner
  keyPress = KeyPress.KeyPress()
  while True :
    try :
      key = keyPress.getChar(blocking=True)
      return choices[key]()
    except Exception, e:
      if len(e.args)>0:
        print e.args[0]
      else :
        raise
      print "key %s not understood." % key
      print banner

class RecursiveFilter( object ):
  """A wrapper filter that determines how far down the headers to apply the real filter"""
  def __init__( self, filtr, maxDepth ) :
    self._filter = filtr
    self._maxDepth = maxDepth

  def filter( self, addr, msg, myDepth = 0) :
    if msg == None or self._maxDepth == myDepth :
      return False
    else:
      return self._filter.filter(addr, msg) or self.filter( addr, msg.parentMsg, myDepth+1)

  @staticmethod
  def menu(maxDepth) :
    filtr = userMenu(msgFilterMenu)
    if filtr == None :
      return None
    else :
      return RecursiveFilter(filtr, maxDepth)

  def __str__(self) :
    return "(depth=%d) : %s" % (self._maxDepth, str(self._filter))
                            
class NameFilter( object ):
  """Filters for messages certain names"""
  def __init__( self, name ) :
    self._name = name

  def filter( self, addr, msg) :
    return re.search(self._name, msg.nescType, re.I) != None

  @staticmethod
  def menu() :
    print "Enter the desired message name (python regexps accepted)"
    return NameFilter(sys.stdin.readline().strip())

  def __str__(self) :
    return "Message Name == %s" % (self._name)

class AMFilter( object ):
  """Filters for messages certain AM types"""
  def __init__( self, am ) :
    self._am = am

  def filter( self, addr, msg) :
    return msg.amType == self._am

  @staticmethod
  def menu() :
    print "Enter the desired AM type: "
    try:
      return AMFilter(int(sys.stdin.readline().strip()))
    except Exception, e:
      if len(e.args) > 0:
        print e.args[0]
        print "You must enter an integer"
      else :
        raise

  def __str__(self) :
    return "AM type == %s" % (self._am)


class FieldFilter( object ):
  """Filters for messages certain fields"""
  def __init__( self, name ) :
    self._name = name

  def filter( self, addr, msg) :
    for field in msg.fields :
      if re.search(self._name, field['name'], re.I) != None :
        return True
    return False

  @staticmethod
  def menu() :
    print "Enter the desired field name (python regexps accepted)"
    return FieldFilter(sys.stdin.readline().strip())

  def __str__(self) :
    return "Field Name == %s" % (self._name)

class ValueFilter( object ):
  """Filters for fields with a certain value"""
  def __init__( self, name, value ) :
    self._name = name
    self._value = value

  def filter( self, addr, msg) :
    for field in msg.fields :
      if re.search(self._name, field['name'], re.I) != None :
        if msg.__dict__[self._name] == value :
          return True
    return False

  @staticmethod
  def menu() :
    print "Sorry, this filter is incomplete"
    return None
#    print "Enter the field name (python regexps accepted)"
#    print "Enter the field value (only integers at this time)"
#    return ValueFilter(sys.stdin.readline().strip())

  def __str__(self) :
    return "Field %s == %d" % (self._name, self._value)

class ORFilter( object ):
  """A wrapper filter that ORs other filters together"""
  def __init__( self, filters ) :
    self._filters = filters

  def filter( self, addr, msg) :
    for filtr in self._filters :
      if filtr.filter(addr, msg) :
        return  True
    return False

  @staticmethod
  def menu() :
    filters = []
    while True :
      filtr = userMenu( recursionMenu )
      if filtr != None :
        filters.append(filtr)
      else :
        break
    return ORFilter(filters)
  
  def __str__(self) :
    strg= "ORFilter \n          ---OR---\n"
    for filtr in self._filters :
      strg += "          %s\n" % str(filtr)
    strg += "          ---OR---"
    return strg
  
class NotFilter( object ):
  """A wrapper filter that NOTs another filter"""
  def __init__( self, filtr ) :
    self._filter = filtr

  def filter( self, addr, msg) :
    if self._filter.filter(addr, msg) :
        return  False
    return True

  @staticmethod
  def menu() :
    filtr = userMenu( recursionMenu )
    if filtr != None :
      return NotFilter(filtr)
    else :
      return None
  
  def __str__(self) :
    return "NOT %s\n" % str(filtr)
  

logicalMenu = ( """
  Only messages that match ALL filters can pass through, by default.
  You can negate a filter with the NOT-filter, or create a group of
  filters than are OR-ed together with the OR-filter.
  
    'd': default filter
    'o': OR-filter
    'n': NOT-filter
    'x': to cancel
    """, { 
  'o': ORFilter.menu,
  'n': NotFilter.menu,
  'd': lambda : userMenu(recursionMenu),
  'x': lambda : None
  })

recursionMenu = ( """
  Choose the depth to which the filter will apply:
  
    '1': top-level message only    
    '2': include one level of protocol headers
    '3': include two levels of protocol headers
    ...
    'f': full recursion            
    'x': to cancel
    """, { 
  '1': lambda : RecursiveFilter.menu(1),
  '2': lambda : RecursiveFilter.menu(2),
  '3': lambda : RecursiveFilter.menu(3),
  '4': lambda : RecursiveFilter.menu(4),
  '5': lambda : RecursiveFilter.menu(5),
  '6': lambda : RecursiveFilter.menu(6),
  '7': lambda : RecursiveFilter.menu(7),
  '8': lambda : RecursiveFilter.menu(8),
  '9': lambda : RecursiveFilter.menu(9),
  'f': lambda : RecursiveFilter.menu('all'),
  'x': lambda : None
  })

msgFilterMenu = ("""
  What type of filter:
  
    'n': filter on message name
    'a': filter on AM type
    'f': filter on message field name
    'v': filter on message field value
    'x': to cancel
    """, { 
  'n': NameFilter.menu,
  'a': AMFilter.menu,
  'f': FieldFilter.menu,
  'v': ValueFilter.menu,
  'x': lambda : None
  })

class MessageFilter( object ) :
  """This module offers \"register\" and \"unregister\" functions that
  take a messageHandler argument but no message type argument, similar
  to the MessageSnooper module.  This module allows the user to
  receive all incoming messages, and to apply filters to them. The
  filters can either be created programmatically or through a UI menu.

  usage:
  snooper = MessageSnooper(app)
  filtr = MessageFilter(app, snooper)
  filtr.start
  filtr.stop
  filtr.register(callbackFcn)
  filtr.unregister(callbackFcn)
  """
   
  def __init__( self , app, snooper ) :

    self.app = app
    self.snooper = snooper
    self.listeners = []
    self.filters = []

    msgQueue = Comm.MessageQueue(10)
    self.running = True
    self.snooper.register(msgQueue)
    msgThread = threading.Thread(target=self.processMessages,
                                 args=(msgQueue,))
    msgThread.setDaemon(True)
    msgThread.start()

  def processMessages(self, msgQueue) :
    while True :
      (addr,msg) = msgQueue.get()
      passes = True
      if self.running == True :
        for filtr in self.filters :
          passes = passes and filtr.filter(addr, msg)
      if passes == True :
        for listener in self.listeners :
          listener.messageReceived(addr, msg)

  def userMenu(self) :
    """A generic function to print menus and return the result"""
    banner = """
  Choose an action:
  
    'a': add filter
    'p': print filters
    'd': delete filter
    's': stop filtering
    'r': resume filtering
    'x': to cancel
    """
    print banner
    keyPress = KeyPress.KeyPress()
    while True :
      try :
        key = keyPress.getChar(blocking=True)
        if key == 'x':
          print "Done"
          break
        if key == 's':
          self.stop()
          break
        if key == 'r':
          self.start()
          break
        elif key == 'a':
          filtr = userMenu( logicalMenu ) #recursionMenu )
          if filtr != None :
            self.filters.append(filtr)
            print "Filter added"
          else :
            print "No filter added"
          break
        elif key == 'p':
          print "%5s : %9s : %s" % ("Num", "Depth", "Filter")
          print "  -----"
          for i in range(len(self.filters)):
            print "%5d : %s" % (i, str(self.filters[i]))
          print banner
        elif key == 'd':
          print "Enter the number of the filter to remove"
          try:
            self.filters.remove(self.filters[int(sys.stdin.readline().strip())])
            break
          except Exception, e:
            if len(e.args) > 0:
              print e.args[0]
              print "You must enter an integer"
            else :
              raise
        else :
          print "key %s not understood." % key
          print banner
      except Exception, e:
        if len(e.args)>0:
          print e.args[0]
        else :
          raise
        print "key %s not understood." % key
        print banner

  def addFilter(self, filtr) :
    self.filters.append(filtr)
    
  def removeFilter(self, filtr) :
    self.filters.remove(filtr)
    
  def stop(self) :
      self.running = False

  def start(self) :
      self.running = True

  def register(self, msgHandler) :
    self.listeners.append(msgHandler)
    
  def unregister(self, msgHandler) :
    self.listeners.remove(msgHandler)
