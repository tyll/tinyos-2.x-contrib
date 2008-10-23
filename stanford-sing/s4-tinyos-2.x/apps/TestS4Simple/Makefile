COMPONENT=TestS4Simple

#Configuration Parameters
PFLAGS += -DMAX_ROOT_BEACONS=8   #c
PFLAGS += -DTOSH_DATA_LENGTH=50  #29 for c < 8; 30 for 8 coords; 42 for 12 coord components; 54 for 16;
PFLAGS += -DBVR_APP_DATA_LENGTH=10 # TOSH_DATA_LENGTH - (12 + MAX_ROOT_BEACONS)
PFLAGS += -DLE_CACHE_SIZE=18

#Testing
#CFLAGS += -DLINK_DUMMY #uncomment to use dummy link estimator
#CFLAGS += -DFROZEN_COORDS

#Experimentation
CFLAGS += -DEXP_PROGRESS #uses the expected progress when ranking next_hops
CFLAGS += -DBEACON_ETX  -DCRROUTING -DRECEIVE_HISTORY_SIZE=4 
CFLAGS += -DETX_TOLERANCE -DLOCAL_DV  -DSHORT_INTERVAL -DFW_COORD_TABLE -DMULTIPLE_BEACON -DEXP_BACKOFF 
#CFLAGS += -I/home/Tahir/T2SerialT1

TEMP_TOSDIR=../../tos/
#Includes
PFLAGS += -I$(TEMP_TOSDIR)/lib/bvr -I$(TEMP_TOSDIR)/lib/commstack 
PFLAGS += -I$(TEMP_TOSDIR)/lib/interfaces -I$(TEMP_TOSDIR)/lib/linkestimator -I$(TEMP_TOSDIR)/lib/util -I$(TOSDIR)/chips/cc2420/interfaces -I$(TOSDIR)/chips/cc2420/packet
PFLAGS += -I$(TEMP_TOSDIR)/lib/command  -I$(TOSDIR)/types/ 


include $(MAKERULES)
