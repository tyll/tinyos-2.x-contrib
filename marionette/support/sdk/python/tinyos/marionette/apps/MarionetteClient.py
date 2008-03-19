#!/usr/bin/python 

#Test XML-RPC Marionette client to be used along with the TestMarionette app
#Uncomment various lines to see their effects
#
#Additionally, note that named arguments are not supported by XML-RPC
#Therefore, peek and poke should take arguments as follows (pass None if argument is not needed):
#peek(arrayIndex, value)
#poke(value, arrayIndex, dereference)
#
#author Michael Okola

import sys
import time
from xmlrpclib import *

server = ServerProxy("http://localhost:21777", allow_none=True)

#print server.app.TestMarionetteC.test.peek()
#print server.app.TestMarionetteC.test.poke(50)
#print server.app.TestMarionetteC.test.peek()

#print server.app.TestMarionetteC.testPtr.peek()
#print server.app.TestMarionetteC.testPtr.peek(None, True)
#print server.app.TestMarionetteC.testPtr.poke(130, None, True)

#print server.app.TestMarionetteC.testArray.peek(0)
#print server.app.TestMarionetteC.testArray.poke(12, False, 0)
#print server.app.TestMarionetteC.testArray.peek(0)

#print server.app.TestMarionetteC.testCommand8()

#print server.str("app")
#print server.str("app.rpc")
