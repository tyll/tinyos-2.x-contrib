#if INTELMOTE2_CONTRIB_DIR is not defined, see stanford-lgl/README file
COMPONENT=cameraJpegTestC

PFLAGS += -I$(INTELMOTE2_CONTRIB_DIR)/support/sdk/c/compress
PFLAGS += -I$(INTELMOTE2_CONTRIB_DIR)/tos/lib/BigMsg
# for stanford-lgl backward compatibility only
ASSEMBLY_FILES += $(INTELMOTE2_CONTRIB_DIR)/tos/chips/pxa27x/memsetup-pxa.s
PFLAGS += -I$(INTELMOTE2_CONTRIB_DIR)/../intelmote2/libs/BigMsg
PFLAGS += -I$(INTELMOTE2_CONTRIB_DIR)/../intelmote2/tos/chips/ov7670
PFLAGS += -I$(INTELMOTE2_CONTRIB_DIR)/../intelmote2/tos/chips/pxa27x
PFLAGS += -I$(INTELMOTE2_CONTRIB_DIR)/tos/platforms/intelmote2
PFLAGS += -I$(INTELMOTE2_CONTRIB_DIR)/../intelmote2/tos/sensorboards/xbow_cb
PFLAGS += -I$(INTELMOTE2_CONTRIB_DIR)/../intelmote2/support/sdk/c/compress
#
SYSTEM_CORE_FREQUENCY := 104
SYSTEM_BUS_FREQUENCY := 104

#CFLAGS += -Wcast-align -Wpadded -Wpacked
include ../Makerules
