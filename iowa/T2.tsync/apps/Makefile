COMPONENT=testTsyncC

# Much software is in IAtsync/ subdirectory
PFLAGS= -I../IAtsync 

# optional:  set group
#DEFAULT_LOCAL_GROUP=0xaa
# or maybe TOS_AM_GROUP=0xaa

# use -DTRACK to get neighborhood
# tracking (biconnected links, 
# needed for skew compensation)  
PFLAGS += -DTRACK

# use -DUART to enable sending and
# receiving Beacons over the UART
# (not fully develeloped yet)
#PFLAGS += -DTUART

# use this to change the frequency
# of the Zigbee chip (use channel 
# 11, 15, 20, 25 or 26 -- which seem 
# to be non-overlapping with 802.11
#CFLAGS +=-DCC2420_DEF_CHANNEL=20
# use the following to change the 
# default transmission power on 
# MicaZ/Telos hardware (see ZigBee.txt)
#CFLAGS +=-DCC2420_DEF_RFPOWER=0x1F

# use -DDEMO_LIGHTS 
# only for demonstration of timesync
# PFLAGS += -DDEMO_LIGHTS

# use -v to see lots of extra messages
# during the compilation procedure
#PFLAGS += -v

include $(MAKERULES)
