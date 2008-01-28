COMPONENT=testTsyncC

# Much software is in IAtsync/ subdirectory
PFLAGS= -I../IAtsync 

# optional:  set group
#DEFAULT_LOCAL_GROUP=0xaa
# or maybe TOS_AM_GROUP=0xaa

# use -DTRACK to get neighborhood
# tracking (biconnected links, 
# needed for skew compensation)  
# (note: TRACK and POWCON together
#        is an untested combo)
#PFLAGS += -DTRACK

# use -DPOWCON to turn off the 
# radio between beacons (saves
# on battery);  this requires
# using the PowCon interface so
# that the rest of your app will
# have the radio on when needed
#PFLAGS += -DPOWCON

# use -DSTOPJUMP to avoid even
# correct large jumps of the 
# global time (say, due to network
# partition during initialization)
#PFLAGS += -DSTOPJUMP

# use -DMIXED_CC2420 for networks
# with both Telosb and MicaZ motes
#PFLAGS += -DMIXED_CC2420

# use this to change the frequency
# of the Zigbee chip (use channel 
# 11, 15, 20, 25 or 26 -- which seem 
# to be non-overlapping with 802.11
#CFLAGS +=-DCC2420_DEF_CHANNEL=20
# use the following to change the 
# default transmission power on 
# MicaZ/Telos hardware (see ZigBee.txt)
#CFLAGS +=-DCC2420_DEF_RFPOWER=0x1F

# experimental:  use the microsecond
# clock for some timings
#PFLAGS += -DUSE_MICROSECOND_CLOCK

# use -DDEMO_LIGHTS 
# only for demonstration of timesync
#PFLAGS += -DDEMO_LIGHTS

# use -v to see lots of extra messages
# during the compilation procedure
#PFLAGS += -v

include $(MAKERULES)
