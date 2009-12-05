#! /usr/bin/env bash
# Here we setup the environment
# variables needed by the tinyos 
# make system

export TOSROOT="/opt/tinyos-2.x"
export SWROOT="/opt/sensorweb"
export TOSDIR="$TOSROOT/tos"
export CLASSPATH=$CLASSPATH:$TOSROOT/support/sdk/java/tinyos.jar:.
export MAKERULES="$TOSROOT/support/make/Makerules"
export PATH=$PATH:/opt/msp430/bin:$SWROOT/bin
export XMONITOR=$SWROOT/tools/XMonitor
export SIMX=$SWROOT/tools/simx/trunk
export SIMXLIB=$SIMX/lib/simx
export PYTHONPATH=.:$SIMX/python:$TOSROOT/support/sdk/python:
export SCALAC=$SWROOT/tools/simx-tools/scala/bin/scalac
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib:
export OASIS_ROOT=$SWROOT
export OASIS_APP=$OASIS_ROOT/app/MyApp

