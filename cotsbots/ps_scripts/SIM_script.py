#!/usr/bin/python

# for the simulation
from TOSSIM import *
# for IO (grab from run time, printing)
import sys
# regex for python
#import re
# to be able to use m.getVariable([NAME])
from tinyos.tossim.TossimApp import *
#for Threading (watching threads for trig)
from threading import Thread 

##########################
# Begin Global Variables #
##########################
global current_time
global DebugID
global bots
DebugID = "0"
current_time = 0


###########################################Parse Inputs for variations...
inputs = sys.argv
if len(inputs) < 2 :
  #print "assuming 1 bot, and localhost:6665"
  bots = 1
  hostname = 'localhost'
  port = [6665]
elif len(inputs) == 2 and (inputs[1] == '-h' or inputs[1] == '-help'):
  print "usage: python SIM_script.py [bot numbers] [hostname] [destination port number]"
  print "you have to give information from left to right, (you can't not give hostname when giving port number"
  print "python SIM_script.py -h or -help   to reprint this message"
  sys.exit() 
elif len(inputs) == 2:
  print "assuming localhost:6665 and " + inputs[1] + " bots"
  bots = int(inputs[1])
  hostname = 'locahost'
  port = range(6665,6665 + bots - 1)
elif len(inputs) == 3:
  print "assuming " + inputs[2] + ":6665 and " + inputs[1] + " bots"
  bots = int(inputs[1])
  hostname = inputs[2]
  port = range(6665,6665 + bots - 1)
elif len(inputs) == 4:
  print "assuming " + inputs[2] + ":" + inputs[3] + " and " + inputs[1] + " bots"
  bots = int(inputs[1])
  hostname = inputs[2]
  port = int(inputs[3])
  port = range(port,port + bots - 1)
else:
  print "usage: python SIM_script.py [bot numbers] [hostname] [destination port number]"
  print "you have to give information from left to right, (you can't not give hostname when giving port number"
  print "the port order will start from the given port or default port (6665) and increment by 1"
  print "python SIM_script.py -h or -help   to reprint this message"
  sys.exit()
#############################################end input parse

############################################# regexing for time parse
def TimeRegex(someString):
   t_reg2 = "time.sleep("
   #t_reg = "time.sleep\([\d]*:[\d]*:[\d]*\.[\d]*\)"
   global current_time
   if(someString.find(t_reg2) != -1):
    toReturn = "#" + DebugID + "\n"
    hours = someString.split("(")[1].split(":")[0]
    minutes = someString.split("(")[1].split(":")[1]
    seconds = someString.split("(")[1].split(":")[2].split(")")[0]
    someString = "time.sleep(" + hours + "* 3600 +" + minutes + "* 60 +" + seconds + "-" + str(current_time) + ")\n"
    current_time = float(hours) * 3600 + float(minutes) * 60 + float(seconds)
    someString = toReturn + someString 
    return someString
   else:
    return someString 

################################################End Time parse method

################################################Begin Hostname Regex
def HostnameRegex(someString):
  t_reg =  "HOSTNAME"
  t_reg2 = "PORT"
  global DebugID
  if(someString.find(t_reg2) != -1 and someString.find(t_reg) != -1):
    toReturn = "#" + DebugID + "\n"
    line = someString.split(t_reg)
    toReturn = toReturn + line[0] + "\"" + hostname + "\"" + line[1].split(t_reg2)[0] + str(port[int(DebugID)])  + line[1].split(t_reg2)[1]
    return toReturn
  else:
   return someString
################################################END Hostname Regex

################################################Begin BotID  Regex
def BotIDRegex(someString):
  t_reg = "CLIENT_X"  #should replace with client[\d]
  t_reg2 = "CLI_POS_X" #should replace with pos[\d]
  t_reg3 = "BUMPER_X" #should replace with bumper[\d]
  global DebugID
# idea:
# 1. copy the string
# 2. take input string check it is DEBUG(~~~) then grab the digit store digit
#    and pass the rest of the string on. 
# 3. else do CLIENT_X, CLI_POS_X switch replacee
#	CLIENT_ with client
#	CLI_POS_X with pos
#	then append the digit value that was retrieved from the DEBUG(#):
#	after that you can return.
  if(someString.find(t_reg) != -1 or someString.find(t_reg2) != -1 or someString.find(t_reg3) != -1):
    toReturn = "#" + DebugID + "\n"
    messageBody = someString
    if(messageBody.find(t_reg) != -1): #if the messagebody contains CLIENT_X
      xsplit = messageBody.split(t_reg)
      messageBody = xsplit[0] + "client" + DebugID + xsplit[1]
    if(messageBody.find(t_reg2) != -1): #this means it has CLI_POS_X
      xsplit = messageBody.split(t_reg2)
      messageBody = xsplit[0] + "pos" + DebugID + xsplit[1]
    if(messageBody.find(t_reg3) != -1): #this means it has BUMPER_X
      xsplit = messageBody.split(t_reg3)
      messageBody = xsplit[0] + "bumper" + DebugID + xsplit[1]
    #else: #this means this is a generic message (sleep, import etc.) 
    toReturn = toReturn + messageBody

    return toReturn  
  else: 
    return someString
################################################END BotID  Regex

################################################START DEBUG REGEX
### This parses out the DEBUG (?):  from TOSSIM ####
def DebugRegex(someString):
 t_reg = "DEBUG ("
 global DebugID
 if (someString.find(t_reg) != -1):
  someString = someString[7:]
  splitString = someString.split("): ")
  DebugID = splitString[0]  #this sets the DebugID value, so it can be used later
  someString = splitString[1]
 return someString
################################################END DEBUG REGEX

############################################START CHECKING STRING FOR PLAYERSTAGE CLIENT

def psClientChk(someString):
 global botThreads

 t_reg = "if bumper"
 
 if(someString.find(t_reg) != -1): #if string does contain "if bumper[/d]", this should only happen from Robot.init()
  ID = someString.split("bumper")[1].split(".subscribe")[0] #splits bumper[/d].subscribe, carves the number 
  #the below might be slow, but it is required to have them run in order
  toExec = "cur = ctbtThread(m[" + ID + "], client" + ID + ", bumper" + ID + ")"
  exec(toExec)
  toExec = "botThreads.append(cur)"
  exec(toExec)
  toExec = "cur.start()"
  exec(toExec)
   

############################################END PSCLIENTCHK




###################################################################
#                   Start Actual Simulation Program               # 
###################################################################

n = NescApp()
vars = n.variables.variables()
t = Tossim(vars)
x = t.ticksPerSecond()

#create an array for the bots
global m 
m = [None] * bots
global botThreads
botThreads = []

class ctbtThread(Thread):
 def __init__(self,mote,psRobot,psBumper):
  Thread.__init__(self)
  self.keepAlive = True #flag to kill
  self.mote = mote #mote from TOSSIM
  self.psRobot = psRobot #from PlayerStage
  self.psBumper = psBumper #Device being watched on PlayerStage(a whisker?)
 def run(self):
  while(self.keepAlive):
   #if(self.psRobot.read() == self.psBumper): #if data from PlayerStage signals an event of a triggerable Item
   # print 1
    #Assumed to be a playerc_bumper object
    self.psRobot.read()
    if(sum(self.psBumper.bumpers)): #one of the bumpers (could be expanded for many bumpers)
     self.mote.trig(77) #trigger the event on the TOSSIM mote


for i in range(bots):
 m[i] = t.getNode(i)
 m[i].bootAtTime(0) #boot all of them at 1 second

fr = open("SIMULATOR.py_debug", "r") #this reads the debug file
fw = open("SIMULATOR.py_debug", "w") #this reads the debug file
f2 = open("SIMULATOR.py", "w") #this creates the full SIMULATION file.

t.addChannel("SIM_FILE", fw)
#t.addChannel("SIM_FILE", sys.stdout)

#A Common Start for ALL TYPES

#sys.stdout.write("from playerc import *\n")
#print("from playerc import *")
#sys.stdout.write("import time\n")
#print("import time")

######################
# exec('import xyz') # How to execute arbitrary strings in single process
######################

t.addChannel("Whisker",sys.stdout) 

#while(t.runNextEvent() == True)
i = 0
while (i <= 400 ):#and t.runNextEvent()):
  i = i + 1
  t.runNextEvent()
  wrote = fr.readline()
  #while(wrote != ''):
  #do some stuff here 
  #and prepare it to be written
    
  wrote = DebugRegex(wrote) #this has to be done FIRST
  wrote = TimeRegex(wrote)
  wrote = HostnameRegex(wrote)
  wrote = BotIDRegex(wrote)
  
  f2.write(wrote) #writes to buffer
  exec(wrote)

  psClientChk(wrote) #appends to botThreads[] after client[/d] has been created

  if(i == 100):
   m[0].trig(0)
  if(i == 200):
   m[0].trig(1)
  if(i == 300):
   m[0].trig(2)

#clean up

for i in range(bots):
 print "me"
 botThreads[i].keepAlive = False
 print "me!"

########################SIMULATION ENDS###############################

