# the default timestamping precision is TMilli

# to set timestamping precision to 32kHz, uncomment the following lines
# PFLAGS+=-DDFRF_T32KHZ 
# # set remote control execution delay to 5sec (32768 * 5)
# PFLAGS+=-DREMOTECONTROL_DELTA_T=163840L

# to set timestamping precision to 1 microsecond, uncomment the following lines
PFLAGS+=-DDFRF_TMICRO 
# set remote control execution delay to 5sec (921600 * 5)
PFLAGS+=-DREMOTECONTROL_DELTA_T=460800L


COMPONENT=BaseStationC
PFLAGS += -I$(VUTOSDIR)/lib/misc
PFLAGS += -DCC2420_NO_ACKNOWLEDGEMENTS
PFLAGS += -DCC2420_NO_ADDRESS_RECOGNITION
PFLAGS += -DTASKLET_IS_TASK
# set remote control execution delay to 5sec (1024 * 5)
# PFLAGS+=-DREMOTECONTROL_DELTA_T=5120L
include $(VUMAKERULES)

