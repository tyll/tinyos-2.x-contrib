COMPONENT = OasisApp
PLATFORMS = telosb micaz imote2 pc

# Put the platform dependent settings here
MAKE_PLATFORM = $(firstword $(MAKECMDGOALS))
SIM_PLATFORM = $(word 2, $(MAKECMDGOALS))

ifneq ($(MAKE_PLATFORM),)
  ifneq ($(MAKE_PLATFORM),clean)
    ifeq ($(SIM_PLATFORM),sim)
      include $(SIM_PLATFORM).platform
    endif
    include $(MAKE_PLATFORM).platform
  endif
endif

ifeq ($(MAKE_PLATFORM), imote2)
  CFLAGS += -DPLATFORM_IMOTE2
  CFLAGS += -DSMARTSENSING_USE_APP
endif
ifeq ($(MAKE_PLATFORM), telosb)
  CFLAGS += -DPLATFORM_TELOSB
endif
ifeq ($(MAKE_PLATFORM), micaz)
  CFLAGS += -DPLATFORM_MICAZ
endif
ifeq ($(MAKE_PLATFORM), pc)
  CFLAGS += -DPLATFORM_PC
endif
# Basic modules used in this App
CFLAGS += -I$(OASIS_ROOT)/system/
CFLAGS += -I$(OASIS_ROOT)/interfaces/
#CFLAGS += -I$(OASIS_ROOT)/lib/OasisSensing
CFLAGS += -I$(OASIS_ROOT)/lib/SmartSensing
#CFLAGS += -I$(OASIS_ROOT)/system/ADC
#CFLAGS += -I$(OASIS_ROOT)/lib/TopologyMgmt
##### RTC #####
#CFLAGS += -I${OASIS_ROOT}/lib/Timer/OasisClock

# We have copied ${TOS_ROOT}/beta/platform/imote2 or pxa27x to ${TOS_ROOT}/tos/platform/imote2 or pxa27x
# if any bugs to fix, fix it at ${TOS_ROOT}/tos/platform/imote2 or pxa27x
###### Data Sensing #####
#CFLAGS += -DUSE_SIM_SENSOR
# comment the following line to disable CASCADES
USE_CASCADES = 1
# comment the following line to disable Middleware
#USE_MIDDLEWARE = 1
# comment the following line to disable GenericCommPro
USE_GENERICCOMM_PRO = 1
# comment the following line to use default CSMA instead of TreeMAC
 USE_TREEMAC = 1
# Check whether use SNMS module, mainly for the EventReport
# comment the following line to disable SNMS as well as RPC
USE_SNMS = 1
# comment the following line to disable RPC
ifneq ($(MAKE_PLATFORM), pc)
USE_RPC = 1
endif
# Choose Routing Module: MULTIHOP_LQI or DRAIN
# comment the following line to change from MULTIHOPLQI to DRAIN
USE_MULTIHOP_LQI = 1
# comment the following line to disable FTSP as the time synchronization protocol
USE_FTSP = 1
# comment the following line to disable the compress processing task
# USE_COMPRESS = 1
# comment the following line to disable soft ACK
# USE_SACK = 1
# comment the following line to disable using multiple send multihoplqi
USE_MULTIPLE_SEND = 1
# comment the following line to disable using neighbor management
USE_NEIGHBORMGMT = 1
# comment the following line to disable saving sensing configuration into flash
USE_FLASH = 1
##### Soft ACK #####
ifdef USE_SACK
	CFLAGS += -DUSE_SACK
	PFLAGS += -I$(OASIS_ROOT)/lib/CC2420-SoftACK
endif


##### Compression #######
ifdef USE_COMPRESS
	CFLAGS += -DUSE_COMPRESS
endif

##### TimeSync of FTSP####
ifdef USE_FTSP
	CFLAGS += -DUSE_FTSP
	#CFLAGS += -DFTSP_USE_LEDS
	#CFLAGS += -DTIMESYNC_SYSTIME
	PFLAGS += -DFTSP_ENTRY_THROWOUT_LIMIT=100
        #PFLAGS += -DFTSP_STATIC_ROOT
        #PFLAGS += -DFTSP_STATIC_ROOT_ID=10
	PFLAGS += -DFTSP_TIMESYNC_RATE=5
	PFLAGS += -DSYNC_MODE=1
	PFLAGS += -I$(OASIS_ROOT)/lib/FTSP/TimeSync
endif

###### CASCADES #####
ifdef USE_CASCADES
	CFLAGS += -DUSE_CASCADES
	CFLAGS += -I$(OASIS_ROOT)/lib/Cascades
else
	# OR BCAST or nothing
	CFLAGS += -I$(OASIS_ROOT)/lib/RpcCast
	CFLAGS += -DSEND_QUEUE_SIZE=2
endif

###### Middleware
ifdef USE_MIDDLEWARE
	CFLAGS += -DUSE_MIDDLEWARE
	CFLAGS += -I$(OASIS_ROOT)/lib/Middleware
else
	# 
endif

##### Routing #####
ifdef USE_MULTIHOP_LQI
	CFLAGS += -DUSE_MULTIHOP_LQI

ifdef USE_MULTIPLE_SEND
	PFLAGS += -I$(OASIS_ROOT)/lib/MultiHopOasis-DWFQ/
	CFLAGS += -DCOMM_MHOP_MSG_NUM=4
   	CFLAGS += -DSUPPORT_MHOP_PRIORITY=1
else
	PFLAGS += -I$(OASIS_ROOT)/lib/MultiHop_Volcano-OasisType/
endif
	# parameters for MultiHopLQI
	CFLAGS += -DMHOP_RETRY_COUNT=3
	PFLAGS += -DMULTIHOP_TREE_ROOT_ADDRESS=0
	PFLAGS += -DMULTIHOP_TOS_BASE_ADDRESS=0

#	CFLAGS += -DMHOP_QUEUE_SIZE=8
#	CFLAGS += -DMHOP_HISTORY_SIZE=6
#	CFLAGS += -DMULTIHOP_BEACON_PERIOD=15
	CFLAGS += -DMULTIHOP_BEACON_PERIOD=10
	CFLAGS += -DMHOP_LEDS
	CFLAGS += -DDEF_BEACON_TIMEOUT=6
else
	CFLAGS += -I$(OASIS_ROOT)/lib/Drain
endif

##### GenericCommPro #####
ifdef USE_GENERICCOMM_PRO
	CFLAGS += -DUSE_GENERICCOMM_PRO
	PFLAGS += -I$(OASIS_ROOT)/lib/GenericCommPro
	CFLAGS += -DCOMM_REXMIT_BY_QOS
else
	# Use default GenericComm by tinyos-1.x
endif

##### TreeMAC #####
ifdef USE_TREEMAC
	CFLAGS += -DUSE_TREEMAC
	CFLAGS += -DUSE_DEMAND_SUBTREE
	PFLAGS += -I$(OASIS_ROOT)/lib/TreeMAC
else
	# use default CSMA provided by tinyos-1.x in
	# tos/lib/CC2420Raio
endif

############NEIGHBORMGMT################
# Check whether use neighbor management module
# comment the following line to disable NeighborMgmt support
ifdef USE_NEIGHBORMGMT
	CFLAGS += -DUSE_NEIGHBORMGMT
	PFLAGS += -I$(OASIS_ROOT)/lib/NeighborMgmt 
	CFLAGS += -DNEIGHBOR_TABLE_UPDATE_INTERVAL=10
endif 

############FLASH################
# Check whether use flash module to save sensing configuration
# comment the following line to disable flash support
ifdef USE_FLASH
	CFLAGS += -DUSE_FLASH
	PFLAGS += -I$(OASIS_ROOT)/lib/Deluge/TOSBoot/imote2
endif

#################WEIGHT FAIRNESS##################
#WEIGHT_FAIRNESS = 1
#ifdef WEIGHT_FAIRNESS
#	CFLAGS += -DWEIGHT_FAIRNESS
#	PFLAGS += -I$(OASIS_ROOT)/lib/WFController 
#endif   

#####  SNMS  #####
ifdef USE_SNMS
	CFLAGS += -DUSE_SNMS
	CFLAGS += -I$(OASIS_ROOT)/lib/SNMS

	ifdef USE_RPC
		CFLAGS += -DUSE_RPC
		# much declare the following to use RPC
		GOALS  +=  nescDecls
		GOALS  +=  rpc
		CFLAGS += -I$(OASIS_ROOT)/lib/Rpc
		CFLAGS += -I$(OASIS_ROOT)/lib/RamSymbols
		CFLAGS += -I${TOSROOT}/contrib/nucleus/tos/lib/Nucleus
		#CFLAGS += -I$(OASIS_ROOT)/lib/RpcCast
		RPC_GEN_PL = $(OASIS_ROOT)/tools/scripts/codeGeneration/generateRpc.pl
		#NESC_DECLS_GEN_PL = $(OASIS_ROOT)/tools/scripts/codeGeneration/generateNescDecls.pl
	else
		#
	endif
else
	#
endif


######################## Misc ######################
##### TODO: for LED #####

##### For debug #####
#CFLAGS += -DPRINTFUART_ENABLED
#Comment the following will enable DBG_ERR only!!!
#CFLAGS += -DDEBUG_MODES=0x0020000000000000ULL # DBG_SNMS = 53
#CFLAGS += -DDEBUG_MODES=0x4000000000000000ULL # DBG_UTIL
#CFLAGS += -DDEBUG_MODES=0x0010000000000000ULL # DBG_SENSING =52
#CFLAGS += -DDEBUG_MODES=0x0000300000000000ULL # DBG_TSYNC =46
#CFLAGS += -DDEBUG_MODES=0x0100000000000000ULL # DBG_CAS 56
#CFLAGS += -DDEBUG_MODES=0x2000000000000000ULL # DBG_GENERICCOMMPRO = 61
##### To use TOSSIM #####
# The TinyOS-1.x version from OASIS SVN has already been corrected to support sim,telosb   $TOS_ROOT/beta/TOSSIM-CC2420
# Caution: the version in Samba machine is best version - maybe the svn version is incomplete.

##### DELUGE #####
#CFLAGS += -DUSE_DELUGE

##### DATA_LENGTH #####
CFLAGS += -DTOSH_DATA_LENGTH=74

##### ACK #####
#CFLAGS += -DUSE_DISABLE_ACK


include ${OASIS_ROOT}/Makelocal
include ${MAKERULES}

