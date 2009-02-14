from QuantoLogConstants import QuantoLogConstants
from QuantoCoreConstants import QuantoCoreConstants
from ResourceConstants import ResourceConstants
from Msp430Constants import Msp430Constants
from QuantoTimerConstants import QuantoTimerConstants
from QuantoCC2420Constants import QuantoCC2420Constants
from QuantoAppConstants import QuantoAppConstants

QuantoActivityNames = {
  QuantoCoreConstants.ACT_TYPE_IDLE : 'idle',
  QuantoCoreConstants.ACT_TYPE_UNKNOWN : 'unkn',
  QuantoCoreConstants.ACT_TYPE_QUANTO  : 'quanto_logging',
  QuantoCoreConstants.ACT_TYPE_QUANTO_WRITER : 'writer',
  QuantoCC2420Constants.ACT_PXY_CC2420_RX: 'pxy_RX',
  QuantoTimerConstants.ACT_TIMER : 'VTimer',
  Msp430Constants.ACT_PXY_ADC     : 'int_ADC'    ,
  Msp430Constants.ACT_PXY_DACDMA  : 'int_DACDMA' ,
  Msp430Constants.ACT_PXY_NMI     : 'int_NMI'    ,
  Msp430Constants.ACT_PXY_PORT1   : 'int_PORT1'  ,
  Msp430Constants.ACT_PXY_PORT2   : 'int_PORT2'  ,
  Msp430Constants.ACT_PXY_TIMERA0 : 'int_TIMERA0',
  Msp430Constants.ACT_PXY_TIMERA1 : 'int_TIMERA1',
  Msp430Constants.ACT_PXY_TIMERB0 : 'int_TIMERB0',
  Msp430Constants.ACT_PXY_TIMERB1 : 'int_TIMERB1',
  Msp430Constants.ACT_PXY_UART0RX : 'int_UART0RX',
  Msp430Constants.ACT_PXY_UART0TX : 'int_UART0TX',
  Msp430Constants.ACT_PXY_UART1RX : 'int_UART1RX',
  Msp430Constants.ACT_PXY_UART1TX : 'int_UART1TX',
}

class QuantoLogConstantsNamed:
  typeName = {
    QuantoLogConstants.MSG_TYPE_SINGLE_CHG  : 'single_chg',
    QuantoLogConstants.MSG_TYPE_MULTI_CHG  : 'multi_chg',
    QuantoLogConstants.MSG_TYPE_COUNT_EV  : 'count_ev',
    QuantoLogConstants.MSG_TYPE_POWER_CHG  : 'power_chg',
    QuantoLogConstants.MSG_TYPE_FLUSH_REPORT : 'flush_report'
  }
  subtypeName = {
    QuantoLogConstants.MSG_TYPE_SINGLE_CHG  : {
      QuantoLogConstants.SINGLE_CHG_NORMAL  : 'normal',
      QuantoLogConstants.SINGLE_CHG_ENTER_INT  : 'enter_int',
      QuantoLogConstants.SINGLE_CHG_EXIT_INT  : 'exit_int',
      QuantoLogConstants.SINGLE_CHG_BIND  : 'bind',
    } ,
    QuantoLogConstants.MSG_TYPE_MULTI_CHG  : {
      QuantoLogConstants.MULTI_CHG_ADD  : 'add',
      QuantoLogConstants.MULTI_CHG_REM  : 'remove',
      QuantoLogConstants.MULTI_CHG_IDL  : 'idle',
    } ,
    QuantoLogConstants.MSG_TYPE_COUNT_EV  : {
      0 : '-',
    } ,
    QuantoLogConstants.MSG_TYPE_POWER_CHG  : {
      0 : '-',
    } ,
    QuantoLogConstants.MSG_TYPE_FLUSH_REPORT  : {
      0 : '-',
    } ,
  }

class ResourceConstantsNamed:
  names = {
    ResourceConstants.CPU_RESOURCE_ID        : 'cpu',
    ResourceConstants.LED0_RESOURCE_ID       : 'led0',
    ResourceConstants.LED1_RESOURCE_ID       : 'led1',
    ResourceConstants.LED2_RESOURCE_ID       : 'led2',
    ResourceConstants.SHT11_RESOURCE_ID      : 'sht11',
    ResourceConstants.CC2420_RESOURCE_ID     : 'cc2420',
    ResourceConstants.CC2420_SPI_RESOURCE_ID : 'cc2420spi',
    ResourceConstants.MSP430_USART0_ID       : 'usart0',
    ResourceConstants.MSP430_USART1_ID       : 'usart1',  
  }


