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

# @author Cory Sharp <cssharp@eecs.berkeley.edu>
# @author Shawn Schaffert <sms@eecs.berkeley.edu>

import os, sys, jpype

__all__ = [ "Comm" , "Util" ]


class pytosException( Exception ) :
    pass


class pytosJavaException( pytosException ) :
    pass


def startJVM( jvmPath ) :
    if "CLASSPATH" in os.environ :
        classPath = os.environ["CLASSPATH"]
    else :
        classPath = ""

    if not os.path.exists( jvmPath ) :
        raise pytosJavaException , "The JVM %s does not exist" % jvmPath
    else :
        try:
            jpype.startJVM( jvmPath , "-ea", "-Djava.class.path=%s" % classPath )
        except RuntimeError , exception :
            raise pytosJavaException , "Tried to JVM was found at " + jvmPath + \
                  ", but could not be started due to the following error:\n" + \
                  exception.__str__()


#------------------------------------------------------------
# windows
#------------------------------------------------------------
if sys.platform == "win32" :


    def findJavaPath() :

        import re

        if "JAVA_HOME" in os.environ :
            return os.environ["JAVA_HOME"]
        elif "PATH" in os.environ :
            pathList = re.split( ";" , os.environ["PATH"] )
            for path in pathList :
                if re.search( r"j2sdk.*\\bin\s*$" , path ) :
                    path = re.sub( r"\\bin\s*$" , "" , path )
                    return path
        return ""
                
            
    javaPath = findJavaPath()
    if javaPath :
        jvmPath = javaPath + "\\jre\\bin\\server\\jvm.dll"
        startJVM( jvmPath )
    else :
        raise pytosJavaException , "Cannot find java in path. " + \
              "Please include j2sdkX.X.X_XX/bin in your path " + \
              "or set the JAVA_HOME environment variable to your j2sdkX.X.X_XX directory."


#------------------------------------------------------------
# cygwin
#------------------------------------------------------------
elif sys.platform == "cygwin" :
    javaPathCyg = os.popen("which java").read()
    javaPathWin = os.popen("cygpath -m \"" + javaPathCyg + "\"").read()
    startJVM( "%s/jre/bin/server/jvm.dll" % javaPathWin[:-10] )



#------------------------------------------------------------
# linux
#------------------------------------------------------------
elif sys.platform.find("linux") == 0:
#    jpype.startJVM(  jpype.getDefaultJVMPath(), "-Djava.class.path=%s" % os.environ["CLASSPATH"] )
    javaPath = os.popen("which java").read()
    jpype.startJVM( "/usr/lib/jvm/java-1.5.0-sun/jre/lib/i386/client/libjvm.so", "-Djava.class.path=%s" % os.environ["CLASSPATH"] )



#------------------------------------------------------------
# other OS
#------------------------------------------------------------
else :
    raise pytosException , "Your OS/platform is not supported by pytos"

