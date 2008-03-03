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

from nescDecls import *
import pytos.tools.Rpc as Rpc
import pytos.tools.RamSymbols as RamSymbols
import re

class ParseArgs( object ) :
  """This object will parse command line arguments and environment
  variables to find the appropriate build directory and motecom.  It
  assumes that the buildDir is the first argument, if it appears, and
  that motecom is either the first or second argument.  It creates a
  new value for argv without the motecom and buildDir.

  If keyword arguments are passed to the constructor, this class will also parse the argument list for such keywords.
  
  usage:
  args = ParsArgs(sys.argv)
  args = ParsArgs(sys.argv, myArg=\"yellow\")
  print args
  buildDir = args.buildDir
  motecom = args.motecom
  myArg = args.myArg
  argv = args.argv
  """
  
  def __init__( self, args=None, **keywords ) :

    self.keywords=keywords
    match = re.match(".*/(\S*?)\Z", args[0])
    appname = match.group(1)
    #try to find the buildDir
    foundIt = False
    failedDirs = []
    buildDirFlag = re.compile("\A-{1,2}(?:buildDir|platform)=(\S+)\Z",re.I)
    for i in range(len(args)) :
        match = buildDirFlag.match(args[i])
        if match != None :
            if os.path.isdir(match.group(1)) :
                self.buildDir = match.group(1)
                args.pop(i)
                foundIt = True
                break
            elif os.path.isdir("build/%s" % match.group(1)) :
                self.buildDir = "build/%s" % match.group(1)
                args.pop(i)
                foundIt = True
                break
            else :
                failedDirs.append(match.group(1))
                failedDirs.append("build/%s" % match.group(1))
            
    if foundIt == False and len(args) > 1:
        if os.path.isdir(args[1]) :
            self.buildDir = args[1]
            args.pop(1)
            foundIt = True
        elif os.path.isdir("build/%s" % args[1]):
            self.buildDir = "build/%s" % args[1]
            args.pop(1)
            foundIt = True
        else:
            failedDirs.append(args[1])
            failedDirs.append("build/%s" % args[1])

    if foundIt == False and os.environ.has_key("TINYOS_DEFAULT_PLATFORM") :
        defaultDir = os.environ["TINYOS_DEFAULT_PLATFORM"]
        if os.path.isdir(defaultDir) :
            self.buildDir = defaultDir
            foundIt = True
        elif os.path.isdir("build/%s" % defaultDir):
            self.buildDir = "build/%s" % defaultDir
            foundIt = True
        else:
            failedDirs.append(defaultDir)
            failedDirs.append("build/%s" % defaultDir)

    if foundIt == False :
        print """\nERROR: No PLATFORM or BUILDDIR found.  Could not import your nesC app.
Specify PLATFORM or BUILDDIR in one of the following ways:

  Usage:

     %(appname)s <platform>
     %(appname)s build/<platform>
     %(appname)s /home/kamin/tinyos-1.x/apps/MyApp/build/<platform>
     %(appname)s --platform=<platform>
     %(appname)s --buildDir=<platform>
     TINYOS_DEFAULT_PLATFORM=<platform> %(appname)s
""" % {'appname':appname}
        if len(failedDirs) > 0:
          print """Based on your parameter list and the environment variable TINYOS_DEFAULT_PLATFORM,
we tried the following strings but they were found not to be directories:\n\n %s\n""" % failedDirs
        raise Exception("No buildDir found")



    #try to find the motecom
    self.motecom=None
    foundIt = False
    failedComms = []
    motecomRE = "\S+@\S+[:\S]?"
    motecom = re.compile(motecomRE, re.I)
    motecomFlag = re.compile("\A-{1,2}motecom=(\S+)\Z", re.I)
    for i in range(len(args)) :
        match = motecomFlag.match(args[i])
        if match != None :
            self.motecom = match.group(1)
            args.pop(i)
            foundIt = True
            break
            
    if foundIt == False and len(args) > 1:
        match = motecom.match(args[1])
        if match != None :
            self.motecom = args[1]
            args.pop(1)
            foundIt = True
        else:
            failedComms.append(args[1])

    if foundIt == False and os.environ.has_key("MOTECOM") :
        defaultCom = os.environ["MOTECOM"]
        match = motecom.match(defaultCom)
        if match != None :
            self.motecom = defaultCom
            foundIt = True
        else:
            failedComms.append(defaultCom)

    if foundIt == False :
        print """\nWARNING: No MOTECOM found.

You app will be imported but will not be connected to the mote network.
Specify MOTECOM in one of the following ways:

     %(appname)s <motecom>
     %(appname)s platform <motecom>
     %(appname)s --motecom=<motecom>
     MOTECOM=<motecom> %(appname)s
""" % {'appname':appname}
        if len(failedComms) > 0:
          print """Based on your parameter list and the environment variable MOTECOM,
we tried the following strings but they did not match the regular expression \"%s\":\n\n %s\n""" % (motecomRE,failedComms)

    for k in keywords.keys():
      foundIt = False
      flagRE = re.compile("\A-{1,2}%s=(.+)\Z" % k,re.I)
      for i in range(len(args)) :
        match = flagRE.match(args[i])
        if match != None :
          self.__dict__[k] = match.group(1)
          foundIt = True
          args.pop(i)
          break
      if foundIt == False :
        self.__dict__[k] = keywords[k]
        

    if re.search("/\Z",self.buildDir) == None :
      self.buildDir = self.buildDir + "/"
    self.argv = args

  def __repr__(self) :
    return "%s object at %s:\n\n%s" % (self.__class__, hex(id(self)), str(self))
  
  def __str__(self) :
    """ print the parsed args."""
    string = "%20s : %s\n" % ("buildDir",self.buildDir)
    string += "%20s : %s\n" % ("motecom",self.motecom)
    string += "%20s : %s\n" % ("argv",self.argv)
    for k in self.keywords.keys() :
      string += "%20s : %s\n" % (k,self.__dict__[k])
    return string
