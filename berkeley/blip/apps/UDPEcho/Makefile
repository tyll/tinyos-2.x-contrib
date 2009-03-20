COMPONENT=UDPEchoC

# uncomment this for network programming support
# BOOTLOADER=tosboot

# radio opts
CFLAGS += -DCC2420_DEF_CHANNEL=17
# CFLAGS += -DCC2420_DEF_RFPOWER=4

# turn this on to disable inet_pton6 and inet_ntop6.  may save some
# space when using the binary shell
# CFLAGS += -DNO_LIB6LOWPAN_ASCII

# if this is set, motes will send debugging information to the address
# listed.
# CFLAGS += -DREPORT_DEST=\"2001:470:1f04:56d::64\"

# printf debugs.  works only on telosb/tmote sky/epic
# CFLAGS += -DPRINTFUART_ENABLED


include $(MAKERULES)

