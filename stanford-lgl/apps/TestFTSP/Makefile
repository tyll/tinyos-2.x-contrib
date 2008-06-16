################################################################################
# the following directives are recognized by TimeSync component 
#
# -DTIMESYNC_DEBUG: enforces multiple hops in software
#
################################################################################
############################ SPECIFY COMPONENT FILE ###########################
ifndef COMPONENT
   COMPONENT=TestTimeSyncC
#   COMPONENT=TestTimeSyncPollerC
endif

#period of timesync msg broadcast and the period of reference broadcast
CFLAGS += -DTIMESYNC_RATE=10 -DTIMESYNC_POLLER_RATE=3
#CFLAGS += -DTS_MICRO
#CFLAGS += -DTIMESYNC_DEBUG

#path to the vanderbilt TimeSync component
#CFLAGS += -I$(LGL_CONTRIB)/libs/FTSP
PFLAGS += -I$(TOSDIR)/lib/ftsp

include ../Makerules

