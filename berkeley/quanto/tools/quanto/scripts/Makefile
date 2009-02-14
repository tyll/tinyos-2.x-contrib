FILES=QuantoLogEntry.py QuantoLogConstants.py QuantoCoreConstants.py \
      ResourceConstants.py Msp430Constants.py \
      QuantoTimerConstants.py  QuantoCC2420Constants.py \
      QuantoLogMsgV.py
all: $(FILES)
clean:
	rm $(FILES) *.pyc
QuantoLogEntry.py: $(QUANTO_ROOT)/tos/lib/quanto/QuantoLog/RawUartMsg.h 
	mig -o $@ -python-classname=QuantoLogEntry python \
              $(QUANTO_ROOT)/tos/lib/quanto/QuantoLog/RawUartMsg.h \
              nx_entry_t

QuantoLogMsgV.py: $(QUANTO_ROOT)/tos/lib/quanto/QuantoLog/QuantoLogStagedMyUART.h \
                  $(QUANTO_ROOT)/tos/lib/quanto/QuantoLog/RawUartMsg.h 
	mig -o $@ -python-classname=QuantoLogMsgV python \
              $(QUANTO_ROOT)/tos/lib/quanto/QuantoLog/QuantoLogStagedMyUART.h \
              quanto_vlog_msg_t


QuantoLogConstants.py: $(QUANTO_ROOT)/tos/lib/quanto/QuantoLog/RawUartMsg.h 
	nescc-ncg $(CFLAGS) -o $@ -python-classname=QuantoLogConstants python \
              $(QUANTO_ROOT)/tos/lib/quanto/QuantoLog/RawUartMsg.h \
                MSG_TYPE_SINGLE_CHG \
                MSG_TYPE_MULTI_CHG \
                MSG_TYPE_COUNT_EV \
                MSG_TYPE_POWER_CHG \
                MSG_TYPE_FLUSH_REPORT \
                SINGLE_CHG_NORMAL \
                SINGLE_CHG_ENTER_INT \
                SINGLE_CHG_EXIT_INT \
                SINGLE_CHG_BIND \
                MULTI_CHG_ADD \
                MULTI_CHG_REM \
                MULTI_CHG_IDL \
                TYPE_SINGLE_CHG_NORMAL \
                TYPE_SINGLE_CHG_ENTER_INT \
                TYPE_SINGLE_CHG_EXIT_INT \
                TYPE_SINGLE_CHG_BIND \
                TYPE_MULTI_CHG_ADD \
                TYPE_MULTI_CHG_REM \
                TYPE_MULTI_CHG_IDL \
                TYPE_POWER_CHG \
                TYPE_COUNT_EV \
                TYPE_FLUSH_REPORT

QuantoCoreConstants.py: $(QUANTO_ROOT)/tos/lib/quanto/activity.h
	nescc-ncg $(CFLAGS) -DMIG -o $@ -python-classname=QuantoCoreConstants \
              python $(QUANTO_ROOT)/tos/lib/quanto/activity.h \
                ACT_INVALID \
                ACT_NODE_MASK \
                ACT_NODE_OFF \
                ACT_NODE_INVALID \
                ACT_TYPE_MASK \
                ACT_TYPE_OFF \
                ACT_TYPE_IDLE \
                ACT_TYPE_UNKNOWN \
                ACT_TYPE_QUANTO \
                ACT_TYPE_QUANTO_WRITER

ResourceConstants.py: $(QUANTO_ROOT)/tos/lib/quanto/ResourceContexts.h
	nescc-ncg $(CFLAGS) -I%T -o $@ -python-classname=ResourceConstants\
              python $(QUANTO_ROOT)/tos/lib/quanto/ResourceContexts.h \
                CPU_RESOURCE_ID \
                LED0_RESOURCE_ID\
                LED1_RESOURCE_ID \
                LED2_RESOURCE_ID \
                SHT11_RESOURCE_ID \
                CC2420_RESOURCE_ID \
                CC2420_SPI_RESOURCE_ID \
                MSP430_USART0_ID \
                MSP430_USART1_ID 


Msp430Constants.py: $(QUANTO_ROOT)/tos/chips/msp430/msp430quantoconsts.h
	nescc-ncg $(CFLAGS) -I%T -o $@ -python-classname=Msp430Constants\
              python $(QUANTO_ROOT)/tos/chips/msp430/msp430quantoconsts.h \
                ACT_PXY_ADC     \
                ACT_PXY_DACDMA  \
                ACT_PXY_NMI     \
                ACT_PXY_PORT1   \
                ACT_PXY_PORT2   \
                ACT_PXY_TIMERA0 \
                ACT_PXY_TIMERA1 \
                ACT_PXY_TIMERB0 \
                ACT_PXY_TIMERB1 \
                ACT_PXY_UART0RX \
                ACT_PXY_UART0TX \
                ACT_PXY_UART1RX \
                ACT_PXY_UART1TX 

QuantoTimerConstants.py: $(QUANTO_ROOT)/tos/lib/timer/QuantoTimer.h
	nescc-ncg $(CFLAGS) -I%T -o $@ -python-classname=QuantoTimerConstants \
              python $(QUANTO_ROOT)/tos/lib/timer/QuantoTimer.h ACT_TIMER

QuantoCC2420Constants.py: $(QUANTO_ROOT)/tos/chips/cc2420/CC2420Quanto.h
	nescc-ncg $(CFLAGS) -I%T -o $@ -python-classname=QuantoCC2420Constants \
              python $(QUANTO_ROOT)/tos/chips/cc2420/CC2420Quanto.h \
                ACT_PXY_CC2420_RX \
                CC2420_PW_STOPPED \
                CC2420_PW_STARTING \
                CC2420_PW_LISTEN \
                CC2420_PW_RX \
                CC2420_PW_TX \
                CC2420_PW_STOPPING \
                CC2420_PW_RXFIFO \
                CC2420_PW_TXFIFO \
                CC2420_POWERSTATE_MASK \
                CC2420_POWERSTATE_OFF \
                CC2420_POWERLEVEL_MASK \
                CC2420_POWERLEVEL_OFF

