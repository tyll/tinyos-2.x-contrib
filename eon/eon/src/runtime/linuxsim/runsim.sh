#!/bin/bash

#comment this out to simulate as fast as possible
export SIM_TIME_SCALE=100  #realtime
#export SIM_TIME_SCALE=1000  #10x realtime

#set simulation time limit in seconds
export SIM_TIME_LIMIT=255000

#file that specifies the trace of network requests
export SIM_NETWORK_TRACE=nettrace

#file that specifies the solar energy trace
export SIM_SOLAR_TRACE=simsolar

#size of the battery to simulate in uJ
export SIM_BATTERY_SIZE=1332000000

#export SIM_LOG_LEVEL=25

#simulation output file
#uncommenting this causes the output to go to stdout
export SIM_LOG_FILE=log.txt

./eflux.out
