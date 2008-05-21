#!/bin/sh
#$Id$

# The purpose of this script is to create an app.c file from the
# TinyOS sources and application program, that is suited as input for
# the MetroWerks CW compiler. It uses NesC to do this.

# INTERFACE/EXTERNAL ENVIRONMENT VARIABLES USED:

# PLATFORM           : REQUIRED : The platform
# TOSDIR             : REQUIRED : The base TinyOS dir/tos
# CWPATH             : OPTIONAL : The base path for CW (used by COMPILEHOST only)
# COMPILEHOST        : OPTIONAL : If present this host will compile app.c
# CFLAGS             : OPTIONAL : Compiler flags
# PFLAGS             : OPTIONAL : Path include flags
# ENVIRONMENT        : OPTIONAL : Environment to compile in = basic if not set.

# Note: not much will work if PFLAGS, and possible CFLAGS, are not defined

################################################################################
#
# Sanity and parameter checking

# Check that we got an argument - an app to compile
[ -z "$1" ] && echo "usage: $0 AppC.nc" && exit 1

# Check that TOSDIR is set.
[ -z "$TOSDIR" ] && echo "Error: $0: TOSDIR must be set" && exit 1

################################################################################
#
# Setting up paths and other stuff, most of it to be exported

# Set the app for NesC to compile to our argument
NESC_FILE=$1

# Export variables for MakeHCS08, if present
export CWPATH

# Handle the environment - this is not really elegant, but it does
# ensure that we can handle everything from here, and use SimpleMac as a string
# in make and perl, while its an int in the c/ncc files.
ENVIRONMENT=${ENVIRONMENT:-basic}
#if [ "$ENVIRONMENT" = "SimpleMac" ] ; then
#    EXTRADEF="-DENVIRONMENT_USESMAC=1"
#fi
#if [ "$ENVIRONMENT" = "FFD" ] ; then
#    EXTRADEF="-DINCLUDEFREESCALE802154"
#fi

case "$ENVIRONMENT" in
	"FFD"|"FFDNB"|"FFDNBNS"|"FFDNGTS"|"RFD"|"RFDNB"|"RFDNBNS")
		EXTRADEF="-DINCLUDEFREESCALE802154"
		;;
	"SimpleMac")
		EXTRADEF="-DENVIRONMENT_USESMAC=1"
		;;
esac

# If INCLUDESMACLIB is defined, export it
#[ -n $INCLUDESMACLIB ] && export INCLUDESMACLIB

# We specify the paths for include files with no default
# includes. This means, that future versions of nesc may break, but
# also means that we are certain what files gets included.
export STDINCLUDES="-nostdinc  \
-I$TOSDIR/interfaces \
-I$TOSDIR/types \
-I$TOSDIR/system\
-I$TOSDIR/platforms/dig528"

# Get the name of the current directory.
PROGNAME=${0##*/}
PROGPATH=${0%$PROGNAME}

################################################################################
#
# The meat of this script

# A function to prefix when we call a command. Note that this is not used
# for the demangle step.
docmd () {
  echo ">>>" "$@"
  "$@" || exit $?
}

### Make sure the build directory exists
mkdir -p build/$PLATFORM

### Create app.c with nesc
docmd ncc $EXTRADEF -D__HIWARE__ -D__MWERKS__ "$STDINCLUDES" $CFLAGS $PFLAGS -S -Os -target=$PLATFORM -Wall \
   $NESC_FLAGS -Wshadow -finline-limit=100000 -fnesc-cfile=build/$PLATFORM/app.c \
  $NESC_FILE -DDEF_TOS_AM_GROUP=$DEFAULT_LOCAL_GROUP

### Remove an assembly file that nesc insists on creating
rm -f ${NESC_FILE%.nc}.s

### Mangle app.c so that it compiles with the CW HCS08 compiler
docmd mv build/$PLATFORM/app.c build/$PLATFORM/app.c.orig
# Sigh, this is not really clever shell/perl programming, but...
echo ">>>" "perl -w $PROGPATH/hcs08MangleAppC.pl < build/$PLATFORM/app.c.orig > build/$PLATFORM/app.c"
perl -w $PROGPATH/hcs08MangleAppC.pl < build/$PLATFORM/app.c.orig > build/$PLATFORM/app.c || exit $?

### Build the binary application app.exe and possibly program it
# If the COMPILEHOST variable is set, we use that, otherwise we assume we are
# on a host that can compile by it self.
cd build/$PLATFORM 
if test -z "$COMPILEHOST" ; then 
    docmd make -f $PROGPATH/MakeHCS08 app.s19
else 
    # mv app.c app.c.posted
    rm -f compile.tar.gz http_headers OUTPUT app.c.gz
    #rm -f app.c
    #cp app2.c app.c
    gzip app.c
    echo ">>> curl --max-time 300 -o compile.tar.gz -D http_headers -F \"ENVIRONMENT=$ENVIRONMENT\" -F \"CHC08_OPTS=$CHC08_OPTS\" -F \"app_c=@app.c.gz\" $COMPILEHOST"
    curl --max-time 300 -o compile.tar.gz -D http_headers -F "ENVIRONMENT=$ENVIRONMENT" -F "CHC08_OPTS=$CHC08_OPTS" -F "app_c=@app.c.gz" $COMPILEHOST
    EXITCODE=$?
    if test $EXITCODE -eq 0 ; then  
	# Check the exit code, which is always present in the http_headers
	grep Tar-code: http_headers | perl -pe 'if (m/Tar-code: (\d*)/i) { exit $1;} else { exit 255; }'
	TARCODE=$?
	if test $TARCODE -eq 0 ; then  
	    if test -e compile.tar.gz ; then 
		tar -zxf compile.tar.gz
		cat OUTPUT
	    else
          	# This is not really very likely ;-)
		echo "ERROR: NO RESULT FROM COMPILE HOST"
		exit 1
	    fi
	else
	    # No tar file.
	    # echo "ERROR: NO TAR FILE - DUMPING HEADERS AND TEXT"
	    echo -n "ERROR: " ; cat compile.tar.gz
	fi
	# We need to check the headers for the actual exit code
	grep Exit-code: http_headers | perl -pe 'if (m/Exit-code: (\d*)/i) { exit $1;} else { exit 255; }'
	EXITCODE=$?
	if test $EXITCODE -ne 0 ; then
	    echo "Error during compilation, exit code: $EXITCODE";
	fi
	exit $EXITCODE
	# We need to check the headers for the actual exit code
    else
	echo "curl returned error $EXITCODE - unable to compile"
	exit $EXITCODE
    fi
fi

cd ../..

