#include "msp430usart.h"
/**
 * Implementation of USART1 lowlevel functionality - stateless.
 * Setting a mode will by default disable USART-Interrupts.
 * 
 * Hpl for USCI_A1
 *
 * @author: Jan Hauer <hauer@tkn.tu-berlin.de>
 * @author: Jonathan Hui <jhui@archedrock.com>
 * @author: Vlado Handziski <handzisk@tkn.tu-berlin.de>
 * @author: Joe Polastre
 * @version $Revision$ $Date$
 */

module HplMsp430UsciA1P {
  provides interface AsyncStdControl;
  provides interface HplMsp430UsciSpi as UsciSpi;
  provides interface HplMsp430UsciUart as UsciUart;
  uses interface HplMsp430GeneralIO as SIMOTX;
  uses interface HplMsp430GeneralIO as SOMIRX;
  uses interface HplMsp430GeneralIO as UCLK;  
}

implementation
{

  MSP430REG_NORACE(UC1IE);
  MSP430REG_NORACE(UC1IFG);
  
  async command error_t AsyncStdControl.start() {
      return SUCCESS;
  }

  async command error_t AsyncStdControl.stop() {
      call UsciSpi.disableSpi();
      call UsciUart.disableUart();
      return SUCCESS;
  }

  void resetUsart(bool reset) {
      if (reset)
      	UCA1CTL1 = UCSWRST;
      else
      	CLR_FLAG(UCA1CTL1,UCSWRST);
  }
  
  bool isTxIntrPending(){
    if (UC1IFG & UCA1TXIFG){
      return TRUE;
    }
    return FALSE;
  }

  bool isTxEmpty(){
    if (!(UC1IFG&UCA1TXIFG)) {
      return TRUE;
    }
    return FALSE;
  }

  bool isRxIntrPending(){
    if (UC1IFG & UCA1RXIFG){
      return TRUE;
    }
    return FALSE;
  }

  void clrTxIntr(){
      UC1IFG &= ~UCA1TXIFG;
  }

  void clrRxIntr() {
    UC1IFG &= ~UCA1RXIFG;
  }

  void clrIntr() {
    UC1IFG &= ~(UCA1TXIFG | UCA1RXIFG);
  }

  void disableRxIntr() {
      UC1IE &= ~UCA1RXIE;
  }

  void disableTxIntr() {
      UC1IE &= ~UCA1TXIE;
  }

  void disableIntr() {
      UC1IE &= ~(UCA1TXIE | UCA1RXIE);
  }

  void enableRxIntr() {
    atomic {
      UC1IFG &= ~UCA1RXIFG;
      UC1IE |= UCA1RXIE;
    }
  }

  void enableTxIntr() {
    atomic {
	  UC1IFG &= ~UCA1TXIFG;
	  UC1IE |= UCA1TXIE;
    }
  }

  void enableIntr() {
    atomic {
  	  UC1IFG &= ~(UCA1TXIFG | UCA1RXIFG);
   	  UC1IE |= (UCA1TXIE | UCA1RXIE);
    }
  }

      
  void configSpi(msp430_spi_union_config_t* config) {
        UCA1CTL0 = (config->spiRegisters.uctl0) | UCSYNC;    //3-pin, 8-bit SPI master
        UCA1CTL1 = (config->spiRegisters.uctl1) | UCSWRST;   
        UCA1BR0 = (uint8_t)(config->spiRegisters.ubr);
        UCA1BR1 = (uint8_t)(config->spiRegisters.ubr>>8);    
  }
      
  async command void UsciSpi.setModeSpi(msp430_spi_union_config_t* config) {
      atomic {
       	resetUsart(TRUE);
       	call UsciUart.disableUart();
       	configSpi(config);
       	call UsciSpi.enableSpi();
       	resetUsart(FALSE);
       	clrIntr();
       	disableIntr();
       }
     return;
   }
  
  void enableUartTx() {
      call SIMOTX.selectModuleFunc();
      UC1IE |= UCA1TXIE;  
    }

    void disableUartTx() {
      UC1IE &= ~UCA1TXIE;  
      call SIMOTX.selectIOFunc();

    }

    void enableUartRx() {
      call SOMIRX.selectModuleFunc();
      UC1IE |= UCA1RXIE;  
    }

    void disableUartRx() {
      UC1IE &= ~UCA1RXIE;  
      call SOMIRX.selectIOFunc();
    }
   
  void configUart(msp430_uart_union_config_t* config) {
      	UCA1CTL1 = (config->uartRegisters.uctl1) | UCSWRST;
      	UCA1CTL0 = (config->uartRegisters.uctl0) & ~UCSYNC;	// UART mode
      	UCA1BR0  = config->uartRegisters.ubr & 0x00FF;
      	UCA1BR1 = (config->uartRegisters.ubr >> 8) & 0x00FF;
      	UCA1MCTL = config->uartRegisters.umctl;
   }

  async command void UsciUart.setModeUart(msp430_uart_union_config_t* config) {
     atomic { 
        resetUsart(TRUE); 
        call UsciSpi.disableSpi(); 
        configUart(config);
        if ((config->uartConfig.utxe == 1) && (config->uartConfig.urxe == 1)) {
         	call UsciUart.enableUart();
        } else if ((config->uartConfig.utxe == 0) && (config->uartConfig.urxe == 1)) {
            disableUartTx();
            enableUartRx();
        } else if ((config->uartConfig.utxe == 1) && (config->uartConfig.urxe == 0)){
            disableUartRx();
            enableUartTx();
        } else {
            call UsciUart.disableUart();
        }
        resetUsart(FALSE);
        clrIntr();
        disableIntr();
     }
     return;
  }
  
  async command void UsciUart.enableUart() {
    atomic{
      call SIMOTX.selectModuleFunc();
      call SOMIRX.selectModuleFunc();
    }
  }

  async command void UsciUart.disableUart() {
    atomic {
      UC1IE &= ~(UCA1RXIE|UCA1TXIE); 
      call SIMOTX.selectIOFunc();
      call SOMIRX.selectIOFunc();
    }

  }
  
  async command void UsciSpi.enableSpi() {
    atomic {
      call SIMOTX.selectModuleFunc();
      call SOMIRX.selectModuleFunc();
      call UCLK.selectModuleFunc();
    }
  }

  async command void UsciSpi.disableSpi() {
    atomic {
      call SIMOTX.selectIOFunc();
      call SOMIRX.selectIOFunc();
      call UCLK.selectIOFunc();
    }
  }


  void tx(uint8_t data) {
      atomic UCA1TXBUF = data;
  }

  uint8_t rx() {
    uint8_t value;
    atomic value = UCA1RXBUF;
    return value;
  }
  
  // common commands
  async command void UsciSpi.resetUsart(bool reset) { resetUsart(reset); }
  
  async command void UsciSpi.disableRxIntr() {disableRxIntr();}
  async command void UsciSpi.disableTxIntr() {disableTxIntr();}
  async command void UsciSpi.disableIntr() {disableIntr();}
  async command void UsciSpi.enableRxIntr() {enableRxIntr();}
  async command void UsciSpi.enableTxIntr() {enableTxIntr();}
  async command void UsciSpi.enableIntr() {enableIntr();}
  async command bool UsciSpi.isTxIntrPending() {return isTxIntrPending();}
  async command bool UsciSpi.isRxIntrPending() {return isRxIntrPending();}
  async command void UsciSpi.clrRxIntr() {clrRxIntr();}
  async command void UsciSpi.clrTxIntr() {clrTxIntr();}
  async command void UsciSpi.clrIntr() {clrIntr();}
  async command bool UsciSpi.isTxEmpty() {return isTxEmpty();}
  async command void UsciSpi.tx(uint8_t data) {tx(data);}
  async command uint8_t UsciSpi.rx() {return rx();}

  async command void UsciUart.resetUsart(bool reset) { resetUsart(reset); }
  async command void UsciUart.disableRxIntr() {disableRxIntr();}
  async command void UsciUart.disableTxIntr() {disableTxIntr();}
  async command void UsciUart.disableIntr() {disableIntr();}
  async command void UsciUart.enableRxIntr() {enableRxIntr();}
  async command void UsciUart.enableTxIntr() {enableTxIntr();}
  async command void UsciUart.enableIntr() {enableIntr();}
  async command bool UsciUart.isTxIntrPending() {return isTxIntrPending();}
  async command bool UsciUart.isRxIntrPending() {return isRxIntrPending();}
  async command void UsciUart.clrRxIntr() {clrRxIntr();}
  async command void UsciUart.clrTxIntr() {clrTxIntr();}
  async command void UsciUart.clrIntr() {clrIntr();}
  async command bool UsciUart.isTxEmpty() {return isTxEmpty();}
  async command void UsciUart.tx(uint8_t data) {tx(data);}
  async command uint8_t UsciUart.rx() {return rx();}

}
