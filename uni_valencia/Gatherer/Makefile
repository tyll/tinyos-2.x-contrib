COMPONENT=GathererC

# uncomment this for network programming support
# BOOTLOADER=tosboot

CFLAGS += -DCC2420_DEF_CHANNEL=26


#CFLAGS += -DCC2420_DEF_RFPOWER=4

# disables support for the AM stack, which somewhat reduces code size
# and compresses packet formats.  If you want to use other tinyos
# protocols which are AM-based, you should not include this.
CFLAGS += -DIEEE154FRAMES_ENABLED

#external Sensirion Sensor
CFLAGS += -Isht75 -Igpio

# lib6lowpan contains inet_ntop6 and inet_pton6 to process ascii
# representations of IPv6 addresses.  You can remove them to save some
# code if you don't use them
# CFLAGS += -DNO_LIB6LOWPAN_ASCII

# if this is set, motes will send debugging information to the address
# listed.
 CFLAGS += -DDIR_SINK=\"fec0::64\"

# printf debugs.  works only on telosb/tmote sky
# CFLAGS += -DPRINTFUART_ENABLED

 # the sleep interval needs to be set the same for all participating devices
 CFLAGS += -DLOW_POWER_LISTENING -DLPL_SLEEP_INTERVAL=512 

 # also modifiy blip's L2 parameters to reduce media overload
 CFLAGS +=-DBLIP_L2_RETRIES=2 -DBLIP_L2_DELAY=2048

include $(MAKERULES)
