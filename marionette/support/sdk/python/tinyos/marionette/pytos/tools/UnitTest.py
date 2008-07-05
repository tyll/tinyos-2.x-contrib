#
# Marionette Unit Test Framework
#
# @author Michael Okola
#

from pytos.util.NescApp import *
import pytos.util.NescApp as NescApp

class UnitTest(NescApp.NescApp):
  def __init__( self, buildDir=None, motecom=None, tosbase=True,
                localCommOnly=False, applicationName="Unknown App", xmlFileDOM=None ) :
    if applicationName == "Unknown App":
      raise Exception("Module name must be specified")
    
    #open the files, apply the necessary transformations, and save the new ones
    appFile = open(applicationName + "AppC.nc", "r")
    cFile = open(applicationName + "C.nc", "r")
    if not (appFile or cFile):
      raise Exception("Given component does not exist")
    appStr = self.stripComments(appFile.read())
    cStr = self.stripComments(cFile.read())
    appFile.close()
    cFile.close()


    #Check to make sure that Boot is not wired to this component
    if re.compile("interface\s+Boot").search(cStr) != None:
      raise Exception("Error: Component may not use the Boot interface")

    #Check to see if SplitControl is already wired to the component in some way
    hasSplitControl = False
    if re.compile(r'interface\s+SplitControl').search(cStr) != None or re.compile(r'interface/s+SplitControl').search(appStr) != None:
      hasSplitControl = True

    #Perform necessary transformations
    providesBegin = re.compile(r'provides\s*\{', re.MULTILINE)
    usesBegin = re.compile(r'uses\s*\{', re.MULTILINE)
    pResult = providesBegin.search(cStr)

    if pResult != None:
      nextSemi = cStr.find(";", pResult.end(), cStr.find("}", pResult.end()))
      while nextSemi != -1:
        cStr = cStr[:nextSemi] + " @rpc()" + cStr[nextSemi:]
        nextSemi = cStr.find(";", nextSemi+8, cStr.find("}", pResult.end()))

    uResult = usesBegin.search(cStr)
    if uResult != None:
      nextSemi = cStr.find(";", uResult.end(), cStr.find("}", uResult.end()))
      while nextSemi != -1:
        cStr = cStr[:nextSemi] + " @rpc()" + cStr[nextSemi:]
        nextSemi = cStr.find(";", nextSemi+8, cStr.find("}", uResult.end()))
      cStr = cStr[:cStr.find("}", uResult.end())-1] + '''   interface Boot;
    ''' + cStr[cStr.find("}", uResult.end()):]

    if not hasSplitControl:
      res = re.compile("interface Boot.*?\n").search(cStr)
      cStr = cStr[:res.end()] + "    interface SplitControl;\n" + cStr[res.end():]
      
    impl = re.compile(r'implementation\s*\{').search(cStr)
    if not hasSplitControl:
      cStr = cStr[:impl.end()] + '''
    
  event void Boot.booted()
  {
    call SplitControl.start();
  }

  event void SplitControl.startDone(error_t error) {
  }

  event void SplitControl.stopDone(error_t error) {
  }
''' + cStr[impl.end():]
    else:
      cStr = cStr[:impl.end()] + '''
    
  event void Boot.booted()
  {
    call SplitControl.start();
  }

''' + cStr[impl.end():]


    beginImpl = re.compile("implementation\s*{\s*\n").search(appStr)
    appStr = appStr[:beginImpl.end()+1] + '''components RpcC,
RamSymbolsM,
MainC;
''' + appStr[beginImpl.end()+1:]
    endImpl = re.compile("}").search(appStr, beginImpl.end())
    appStr = appStr[:endImpl.start()-1] + applicationName + "C.SplitControl -> RpcC;\n  " + applicationName + "C.Boot -> MainC.Boot;\n" + appStr[endImpl.start():]

    
    #Make UnitTest directory and copy all files into it
    os.system("rm -rf " + applicationName + "UnitTest")
    os.mkdir(applicationName + "UnitTest")
    os.chdir(applicationName + "UnitTest")
    os.system("cp ../* ./")

    #Write the transformed components to disk
    appFile = open(applicationName + "AppC.nc", "w")
    cFile = open(applicationName + "C.nc", "w")
    appFile.write(appStr)
    cFile.write(cStr)
    appFile.close()
    cFile.close()

    #create Makefile
    mFile = open("Makefile", "w")
    mFile.write("COMPONENT=" + applicationName + '''AppC

GOALS += marionette

PFLAGS += -DTOSH_MAX_TASKS_LOG2=8
MARIONETTE_ROOT=/opt/tinyos-2.x-contrib/marionette

CFLAGS += -I$(MARIONETTE_ROOT)/tos/lib/Rpc
CFLAGS += -I$(MARIONETTE_ROOT)/tos/lib/RamSymbols

TOSMAKE_PATH += $(MARIONETTE_ROOT)/support/make

MAKERULES := $(TOSROOT)/support/make/Makerules
include $(MAKERULES)''')

    mFile.close()

    #build and program the mote software
    #os.system("cp " + applicationName + " ./")
    os.system("make " + buildDir + " install")

    #wait for the user to start up any needed serial forwarders, etc
    print "\nPlease set up any connections needed, such as a serial forwarder."
    raw_input("Press enter when ready to connect.")

    #now run the regular NescApp initialization
    #first, import all enums, types, msgs, rpc functions, and ram symbols
    self.applicationName = applicationName
    self.buildDir = buildDir
    self.motecom=motecom
    self.tosbase=tosbase
    self.localCommOnly=localCommOnly
    try:
      xmlFilename = findBuildFile(buildDir, "nescDecls.xml")
    except:
      raise Exception("""\nERROR: cannot find file \"nescDecls.xml\".

Your nesC app cannot be imported.

Be sure that you compiled with the \"nescDecls\" option.
Be sure that you supplied the correct buildDir parameter \"%s\".

""" % buildDir)
    if xmlFileDOM == None :
      xmlFileDOM = minidom.parse(xmlFilename)

    # Import enums, types, and msgs
    self.enums = NescEnums(xmlFilename, applicationName, xmlFileDOM)
    self.types = NescTypes(xmlFilename, applicationName, xmlFileDOM)
    self.msgs = NescMsgs(self.types, self.enums, applicationName)

    # Connect to the network
    self.connections = []
    if self.motecom != None:
      comm = Comm.Comm()
      comm.connect(self.motecom)
      self.connections.append(comm)

    # Import the rpc commands and ram symbols
    try:
      self.rpc = Rpc.Rpc(self)
    except Exception, e:
      if len(e.args)>0 and re.search("WARNING: cannot find file", e.args[0]) > 0 :
        print  e.args[0]
        return # (if there are no rpc commands, we have nothing left to do)
      else :
        raise
    try:
      self.ramSymbols = RamSymbols.RamSymbols(self, xmlFileDOM=xmlFileDOM)
    except Exception, e:
      if re.search("The RamSymbolsM module was not compiled in", e.args[0]) > 0 :
        print e.args[0]
      else :
        raise
      pass 

    # Create shortcuts to all the application modules
    moduleNames = {}
    self._moduleNames = []
    moduleName = re.compile('^(\w+).')
    names = self.rpc._messages.keys()
    if self.__dict__.has_key("ramSymbols"):
      names.extend(self.ramSymbols._messages.keys())
    names.sort()
    for name in names :
      match = moduleName.match(name)
      if match != None :
        moduleNames[match.groups(0)[0]] = True
    for name in moduleNames.keys() :
      try :
        rpc = self.rpc.__getattr__(name)
      except:
        rpc = None
      try :
        ram = self.ramSymbols.__getattr__(name)
      except:
        ram = None
      self.__dict__[name] = Shortcut(name, rpc, ram)
      self._moduleNames.append(name)
    self._moduleNames.sort()

  def stripComments(self, s):
    blockre = re.compile(r'/\*.*?\*/', re.MULTILINE|re.DOTALL)
    result = blockre.search(s)

    while result != None:
      s = s[:result.start()] + " " + s[result.end()+1:]
      result = blockre.search(s)

    linere = re.compile(r'//.*?\n')
    result = linere.search(s)
    while result != None:
      s = s[:result.start()] + " " + s[result.end()+1:]
      result = linere.search(s)
    
    return s

  def getValue(result):
    return result[0].value.values()[0].value
