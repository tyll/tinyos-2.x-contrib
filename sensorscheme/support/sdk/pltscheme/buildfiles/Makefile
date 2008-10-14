COMPONENT=src/SensorSchemeAppC

# uncomment this line to enable serial port printing of 
# debug commands in sensorscheme code 
#CFLAGS += -DPRINTF_DBG="\"SensorSchemePrint"\"

# uncomment this line (or include in the command line) when compiling  
#CFLAGS += -DGATEWAY

include src/SensorScheme.include

ssclean:
	rm -r src; rm -r ssgw
	
include $(MAKERULES)
