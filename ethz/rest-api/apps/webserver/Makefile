COMPONENT=MyWebServerC

# uncomment this for network programming support
# BOOTLOADER=tosboot

# radio opts

# RF212 support
 CFLAGS += -DRF212
# CFLAGS += -DRF212_DEF_CHANNEL=11

# RF230 support
# CFLAGS += -DRF230
# CFLAGS += -DRF230_DEF_CHANNEL=11

# Additional Sensors
#CFLAGS += -DMOISTURE

PFLAGS+= -I./resources
PFLAGS+= -I./actuators
PFLAGS+= -I./sensor

# LCD
PFLAGS+= -I${TOSDIR}/lib/terminal/lcd/
#PFLAGS+= -DTERMINAL_ENABLED

CFLAGS += -DTCP_TEST

PFLAGS +=-DPACKET_LINK -DDEF_MEMCPY
PFLAGS += -DCC2420_HW_ACKNOWLEDGEMENTS
PFLAGS += -DTOSH_DATA_LENGTH=102

# enable low-power listening
# PFLAGS += -DLOW_POWER_LISTENING
# PFLAGS += -DLPL_SLEEP_INTERVAL=50



include $(MAKERULES)

