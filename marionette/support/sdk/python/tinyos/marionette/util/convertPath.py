#!/usr/bin/env python


import string, os, re, sys


def usage() :

    print """USAGE: ./convertPath.py -w|-u [PATH|-v [VAR_NAME]]

Convert path-type environmental variables to/from cygwin unix form
(eg, /bin:/usr/bin:/cygdrive/c/cygwin/sbin ) from/to equivalents
in windows form (ie, C:\cygwin\bin;C:\cygwin\usr\bin;C:\cygwin\sbin )

-w          :  convert to windows format
-u          :  convert to unix format
PATH        :  the path string to be converted (eg, /bin:/sbin)
-v VAR_NAME :  name of the variable (w/o $ or %...%) to convert, if
               no name is specified, PATH is assumed.
"""



# variable value to be converted
def getVarValue( varName ) :
    try:
        varValue = os.environ[ varName ]
    except:
        print "Cannot access the %s variable" % varName
        sys.exit(1)
    return varValue


# check number of input args
if (len(sys.argv) < 2) or (len(sys.argv) > 4) :
    usage()
    sys.exit(1)


# variable name to be converted
argList = sys.argv[1:]
if ( len(argList) == 2 ) and ( "-v" in argList ) :
    argList.remove( "-v" )
    convertTo = argList[0]
    varValue = getVarValue( "PATH" )

elif ( len(argList) == 2 ) :
    convertTo = argList[0]
    varValue = argList[1]

elif len(argList) == 3 :
    varName = argList[2]
    argList = argList[:-1]
    if "-v" in argList :
        argList.remove( "-v" )
    else :
        usage()
        sys.exit(1)
    convertTo = argList[0]
    varValue = getVarValue( varName )
else :
    usage()
    sys.exit(1)


# find cygwin's root in windows
cygRoot = os.popen( "cygpath -w /" ).read()[:-1]


# which form to convert to? 


# --------------------------------------------------
# convert to windows format
# --------------------------------------------------
if convertTo == "-w" :

    pathList = re.split( ":" , varValue )
    newPathStr = ""
    for path in pathList :
        path = re.sub( "^\s" , "" , path )
        path = re.sub( "\s$" , "" , path )
        regResults = re.search( "^((?P<dot>\.)|(/cygdrive/(?P<drive>[a-zA-Z])))?/(?P<rem>.*)$" , path )
        if regResults:
            dot = regResults.group("dot")
            drive = regResults.group("drive")
            rem = regResults.group("rem")
            if drive :
                prefix = "%s:\\" % drive
            elif dot :
                prefix = ".\\"
            else :
                prefix = "%s\\" % cygRoot
            newPath = prefix + re.sub( r"/" , r"\\" , rem )
            newPathStr += newPath + ";"
    newPathStr = newPathStr[:-1]



# --------------------------------------------------
# convert to unix format
# --------------------------------------------------
elif convertTo == "-u" :

    pathList = re.split( ";" , varValue )
    newPathStr = ""
    for path in pathList :
        path = re.sub( "^\s" , "" , path )
        path = re.sub( "\s$" , "" , path )
        regStr = r"^((?P<dot>\.)|(?P<cygr>%s)|((?P<drive>[a-z]):))\\(?P<rem>.*)$" % re.sub( r"\\" , r"\\\\" , cygRoot )
        regResults = re.search( regStr , path , re.I )
        if regResults:
            dot = regResults.group("dot")
            cygr = regResults.group("cygr")
            drive = regResults.group("drive")
            rem = regResults.group("rem")
            if cygr :
                prefix = "/"
            elif dot :
                prefix = "./"
            else :
                prefix = "/cygdrive/%s/" % drive
            newPath = prefix + re.sub( r"\\" , r"/" , rem )
            newPathStr += newPath + ":"
    newPathStr = newPathStr[:-1]


else :
    usage()
    sys.exit(1)


print newPathStr



