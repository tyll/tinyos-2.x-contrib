COMPONENT=cameraTestC

LGLDIR = /cygdrive/d/work/tinyos-2.x-contrib/lgl

ASSEMBLY_FILES += $(LGLDIR)/tos/chips/pxa27x/memsetup-pxa.s

CFLAGS += -DCC2420_NO_ACKNOWLEDGEMENTS
CFLAGS += -DCC2420_NO_ADDRESS_RECOGNITION
 
PFLAGS += -I.
PFLAGS += -I$(LGLDIR)/tos/sensorboards/im2cb
PFLAGS += -I$(LGLDIR)/tos/chips/OV7649
PFLAGS += -I$(LGLDIR)/tos/chips/pxa27x/cif
PFLAGS += -I$(LGLDIR)/tos/chips/pxa27x
PFLAGS += -I$(LGLDIR)/tos/platforms/intelmote2
SENSORBOARD ?= im2cb

#CFLAGS += -Wcast-align -Wpadded -Wpacked

include $(MAKERULES)
