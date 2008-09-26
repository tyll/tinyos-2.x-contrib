#!/usr/bin/python

import sys
import os


if (len(sys.argv) < 6):
	print("usage: "+sys.argv[0]+" <application directory> <app name> <destination> <stubbs--y or n> <copy impl--y or n>")
	sys.exit(1);

print sys.argv

path = sys.argv[1]
app = sys.argv[2]
dst = sys.argv[3]
s = sys.argv[4]
impl = sys.argv[5]

gencmd = "java5 -cp ./bin:./lib/jdsl.jar:./lib/javacuplex.jar:lib/getopt.jar edu.umass.eflux.Main "

if (sys.platform == "win32"):
	gencmd = gencmd.replace(":",";")

if ((s == "Y")|(s == "y")):
    gencmd = gencmd + " -s "

#gencmd = gencmd + "-d dotfiles.dot -r " + dst + "  src/apps/" + app + "/" + app
gencmd = gencmd + "-d dotfiles.dot -r " + dst + " " + path + "/" + app +" -a " + path 

print "Compiling flux program: "+app
print gencmd;
ret = os.system(gencmd);
if (ret):
    sys.exit(1);

#if ((impl == "Y")|(impl == "y")):
#	print "Copying implementation:"
	#cpcmd = "cp -LR --preserve=link src/impl/"+app+"/* "+dst+"/."
#	cpcmd = "cp -LR --preserve=link " + path + "/impl/* "+dst+"/."
#	print(cpcmd);
#	os.system(cpcmd);


print "Create dot graph post script:"
dotcmd = "dot -Tps -Gsize=\"8,11\" -Grotate=\"90\" "+dst+"/dotfiles.dot -o "+dst+"/graph.ps"
print(dotcmd);
os.system(dotcmd);


#print "Copy UnitTest Code:"
#testcmd = "mkdir "+dst+"/mica2dot/tests"
#print(testcmd);
#os.system(testcmd);

#testcmd = "cp src/tests/unittest/* "+dst+"/mica2dot/tests/."
#print(testcmd);
#os.system(testcmd);



