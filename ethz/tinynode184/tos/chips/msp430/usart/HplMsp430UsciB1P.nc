#include "msp430usart.h"
/**
 * Implementation of USART1 lowlevel functionality - stateless.
 * Setting a mode will by default disable USART-Interrupts.
 * 
 * Hpl for USCI_B1
 *
 * @author: Jan Hauer <hauer@tkn.tu-berlin.de>
 * @author: Jonathan Hui <jhui@archedrock.com>
 * @author: Vlado Handziski <handzisk@tkn.tu-berlin.de>
 * @author: Joe Polastre
 * @version $Revision$ $Date$
 */

module HplMsp430UsciB1P {
  provides interface AsyncStdControl;
  provides interface HplMsp430UsciSpi as UsciSpi;
  uses interface HplMsp430GeneralIO as SIMO;
  uses interface HplMsp430GeneralIO as SOMI;
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
      return SUCCESS;
  }

  void resetUsart(bool reset) {
      if (reset)
      	UCB1CTL1 = UCSWRST;
      else
      	CLR_FLAG(UCB1CTL1,UCSWRST);
  }
  
  bool isTxIntrPending(){
    if (UC1IFG & UCB1TXIFG){
      return TRUE;
    }
    return FALSE;
  }

  bool isTxEmpty(){
    if (!(UC1IFG&UCB1TXIFG)) {
      return TRUE;
    }
    return FALSE;
  }

  bool isRxIntrPending(){
    if (UC1IFG & UCB1RXIFG){
      return TRUE;
    }
    return FALSE;
  }

  void clrTxIntr(){
      UC1IFG &= ~UCB1TXIFG;
  }

  void clrRxIntr() {
    UC1IFG &= ~UCB1RXIFG;
  }

  void clrIntr() {
    UC1IFG &= ~(UCB1TXIFG | UCB1RXIFG);
  }

  void disableRxIntr() {
      UC1IE &= ~UCB1RXIE;
  }

  void disableTxIntr() {
      UC1IE &= ~UCB1TXIE;
  }

  void disableIntr() {
      UC1IE &= ~(UCB1TXIE | UCB1RXIE);
  }

  void enableRxIntr() {
    atomic {
      UC1IFG &= ~UCB1RXIFG;
      UC1IE |= UCB1RXIE;
    }
  }

  void enableTxIntr() {
    atomic {
	  UC1IFG &= ~UCB1TXIFG;
	  UC1IE |= UCB1TXIE;
    }
  }

  void enableIntr() {
    atomic {
  	  UC1IFG &= ~(UCB1TXIFG | UCB1RXIFG);
   	  UC1IE |= (UCB1TXIE | UCB1RXIE);
    }
  }

      
  void configSpi(msp430_spi_union_config_t* config) {
        UCB1CTL0 = (config->spiRegisters.uctl0) | UCSYNC;    //3-pin, 8-bit SPI master
        UCB1CTL1 = (config->spiRegisters.uctl1) | UCSWRST;   
        UCB1BR0 = (uint8_t)(config->spiRegisters.ubr);
        UCB1BR1 = (uint8_t)(config->spiRegisters.ubr>>8);    
  }
      
  async command void UsciSpi.setModeSpi(msp430_spi_union_config_t* config) {
      atomic {
       	resetUsart(TRUE);
       	configSpi(config);
       	call UsciSpi.enableSpi();
       	resetUsart(FALSE);
       	clrIntr();
       	disableIntr();
       }
     return;
   }
  
  async command void UsciSpi.enableSpi() {
    atomic {
      call SIMO.selectModuleFunc();
      call SOMI.selectModuleFunc();
      call UCLK.selectModuleFunc();
    }
  }

  async command void UsciSpi.disableSpi() {
    atomic {
      call SIMO.selectIOFunc();
      call SOMI.selectIOFunc();
      call UCLK.selectIOFunc();
    }
  }

  void tx(uint8_t data) {
      atomic UCB1TXBUF = data;
  }

  uint8_t rx() {
    uint8_t value;
    atomic value = UCB1RXBUF;
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

}
