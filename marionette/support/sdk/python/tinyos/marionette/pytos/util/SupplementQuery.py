#!/usr/bin/python -i
#
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
# @author August Joki
#
# *This script pulls the tos_image.xml file of the currently running
# program off of the mote attached to the computer.
# *(Only if the program has been loaded into the flash)
# *Parses the xml file to get the supplement.tar.bz2 file
# *Extracts the supplement files to the directory provided
# *Sets up the pytos environment based on the files in the supplement
#
# TODO: work through tosbase(?)
#
# Usage:
# SupQuery.py [dir] [motecom]
#
# Where "dir" is the directory where the supplement files will be downloaded to.
#  Creates directory if it doesn't exist.
#  Uses the current directory if nothing is supplied.
#
# Where "motecom" is the standard comm port definition, eg "sf@localhost:9001"
#  Uses MOTECOM if nothing is supplied
#
# Deluge parsing taken from read_deluge_supplement
#  Thanks Gil

import sys, os, re
from xml.dom.minidom import parse
from binascii import unhexlify

# Check command line args
supDir = None
comm = os.getenv("MOTECOM")
if len(sys.argv) > 2:
    supDir = sys.argv[1]
    comm = sys.argv[2]
elif len(sys.argv) >1:
    if sys.argv[1].find("@") != -1:
        if sys.argv[1].find(":") != -1:
            comm = sys.argv[1]
    else:
        supDir = sys.argv[1]

# Parse deluge ping response
print "Determining Running Application...."
deluge = os.popen("MOTECOM="+comm+" java net.tinyos.tools.Deluge -p",'r')
pinging = re.compile("^Pinging node ...")
connected = re.compile("^Connected to Deluge node.")
progname = re.compile("Prog Name:\\s+(.*)")
compon = re.compile("Compiled On:\\s+(.*)")
userhash = re.compile("User Hash:\\s+(.*)")
stored = re.compile("Stored Image (\\d)")
platform = re.compile("Platform:\\s+(.*)")
userid = re.compile("User ID:\\s+(.*)")
hostname = re.compile("Hostname:\\s+(.*)")
numpages = re.compile("Num Pages:\\s+(.*)")
currentProgram = {}
storedPrograms = []
deluged = -1
line = deluge.readline().rstrip()
if pinging.search(line) != None:
    print line
    line = deluge.readline().rstrip()
    if connected.search(line) != None:
        print line
        dashes = deluge.readline().rstrip() #---...
        print dashes
        print deluge.readline().rstrip() #Curr...
        st = deluge.readline().rstrip() #Prog...
        print st
        currentProgram["progName"] = progname.search(st).group(1)
        st = deluge.readline().rstrip() #Comp...
        print st
        currentProgram["compOn"] = compon.search(st).group(1)
        st = deluge.readline().rstrip() #User...
        print st
        currentProgram["userHash"] = userhash.search(st).group(1)
        print dashes
        
        # Collect image infos
        eof = False
        while(not eof):
            st = deluge.readline().rstrip()
            if stored.search(st) != None:
                num = int(stored.search(st).group(1))
                prog = {}
                prog["progName"] = progname.search(deluge.readline().rstrip()).group(1)
                prog["compOn"] = compon.search(deluge.readline().rstrip()).group(1)
                prog["platform"] = platform.search(deluge.readline().rstrip()).group(1)
                prog["userId"] = userid.search(deluge.readline().rstrip()).group(1)
                prog["hostname"] = hostname.search(deluge.readline().rstrip()).group(1)
                prog["userHash"] = userhash.search(deluge.readline().rstrip()).group(1)
                prog["numPages"] = numpages.search(deluge.readline().rstrip()).group(1)
                storedPrograms.insert(num, prog)
                if (currentProgram["progName"] == prog["progName"] and
                    currentProgram["compOn"] == prog["compOn"]     and
                    currentProgram["userHash"] == prog["userHash"]):
                    deluged = num

            else:
                eof = True

        # Running program not in flash so no supplement available
        if deluged == -1:
            index = 0
            print "Currently running program has not been Deluged.\nNo supplement to download."
            print dashes
            print "  Stored Programs:"
            for prog in storedPrograms:
                if prog["progName"] != "N/A":
                    name = prog["progName"]
                    comp = prog["compOn"]
                    uhash = prog["userHash"]
                    print "    "+str(index)
                    print "      Prog Name: "+name
                    print "      Compiled On: "+comp
                    print "      User Hash: "+uhash
                index += 1
            sys.exit()


deluge.close()

# Time to download tos_image.xml off mote
if not os.access(supDir,os.F_OK):
    os.makedirs(supDir)
os.chdir(supDir)

st = ''
if supDir != None:
    st = supDir+"/tos_image.xml"

print "Downloading image to "+st+"."
print "This could take a while...."
os.popen("MOTECOM="+comm+" java net.tinyos.tools.Deluge -d -in="+str(deluged)+" -o=tos_image.xml",'r')
print "Done downloading image."

# Extract supplement
print "Extracting supplement."
dom = parse("tos_image.xml")
supxml = dom.getElementsByTagName("supplement")[0]
format = supxml.getAttribute("format")
sup = supxml.firstChild.data
dom.unlink()

# Parse supplement archive
print "Parsing supplement.tar.bz2."
whitespace = re.compile("\\s+")
sup = whitespace.sub('',sup)
if format == "hex":
    #if supDir != None:
    #    os.chdir(supDir)
    supfile = open("sup.hx",'w')
    supfile.write(str(sup))
    supfile.close()
    supfile = open('sup.pl','w')
    supfile.write('open(HX, "sup.hx"); my $hex = <HX>; my $bin = pack("h*", $hex); open(SUP, ">supplement.tar.bz2"); print SUP $bin;')
    supfile.close()
    t = os.system('perl sup.pl')
    print t

# Unpack supplement file
print "Untaring suplement.tar.bz2"
os.system("tar xjf supplement.tar.bz2")
os.remove("sup.hx")
os.remove("sup.pl")
os.remove("tos_image.xml")

# Set up pytos environment like normal
print "Now setting up pytos environment...."

import pytos.tools.Rpc as Rpc
import pytos.tools.RamSymbols as RamSymbols
import pytos.util.NescApp as NescApp

app = NescApp.NescApp(supDir, comm, tosbase=False)
