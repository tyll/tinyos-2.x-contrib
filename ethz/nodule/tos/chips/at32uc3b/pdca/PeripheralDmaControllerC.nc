/* $Id$ */

/* @author Mustafa Yuecel <mustafa.yuecel@alumni.ethz.ch> */

#include "at32uc3b.h"

configuration PeripheralDmaControllerC
{
  provides {
    interface PeripheralDmaController as AdcRx[uint8_t];
    interface PeripheralDmaController as SscRx[uint8_t];
    interface PeripheralDmaController as Usart0Rx[uint8_t];
    interface PeripheralDmaController as Usart1Rx[uint8_t];
    interface PeripheralDmaController as Usart2Rx[uint8_t];
    interface PeripheralDmaController as TwiRx[uint8_t];
    interface PeripheralDmaController as SpiRx[uint8_t];
    interface PeripheralDmaController as SscTx[uint8_t];
    interface PeripheralDmaController as Usart0Tx[uint8_t];
    interface PeripheralDmaController as Usart1Tx[uint8_t];
    interface PeripheralDmaController as Usart2Tx[uint8_t];
    interface PeripheralDmaController as TwiTx[uint8_t];
    interface PeripheralDmaController as SpiTx[uint8_t];
  }
}
implementation
{
  components InterruptControllerC, 
    new PeripheralDmaControllerP(AVR32_PDCA_PID_ADC_RX) as ADCRX,  
    new PeripheralDmaControllerP(AVR32_PDCA_PID_SSC_RX) as SSCRX, 
    new PeripheralDmaControllerP(AVR32_PDCA_PID_USART0_RX) as USART0RX, 
    new PeripheralDmaControllerP(AVR32_PDCA_PID_USART1_RX) as USART1RX, 
    new PeripheralDmaControllerP(AVR32_PDCA_PID_USART2_RX) as USART2RX, 
    new PeripheralDmaControllerP(AVR32_PDCA_PID_TWI_RX) as TWIRX, 
    new PeripheralDmaControllerP(AVR32_PDCA_PID_SPI0_RX) as SPIRX, 
    new PeripheralDmaControllerP(AVR32_PDCA_PID_SSC_TX) as SSCTX, 
    new PeripheralDmaControllerP(AVR32_PDCA_PID_USART0_TX) as USART0TX, 
    new PeripheralDmaControllerP(AVR32_PDCA_PID_USART1_TX) as USART1TX, 
    new PeripheralDmaControllerP(AVR32_PDCA_PID_USART2_TX) as USART2TX, 
    new PeripheralDmaControllerP(AVR32_PDCA_PID_TWI_TX) as TWITX, 
    new PeripheralDmaControllerP(AVR32_PDCA_PID_SPI0_TX) as SPITX;

  ADCRX = AdcRx;
  ADCRX.InterruptController -> InterruptControllerC;
  SSCRX = SscRx;
  SSCRX.InterruptController -> InterruptControllerC;
  USART0RX = Usart0Rx;
  USART0RX.InterruptController -> InterruptControllerC;
  USART1RX = Usart1Rx;
  USART1RX.InterruptController -> InterruptControllerC;
  USART2RX = Usart2Rx;
  USART2RX.InterruptController -> InterruptControllerC;
  TWIRX = TwiRx;
  TWIRX.InterruptController -> InterruptControllerC;
  SPIRX = SpiRx;
  SPIRX.InterruptController -> InterruptControllerC;
  SSCTX = SscTx;
  SSCTX.InterruptController -> InterruptControllerC;
  USART0TX = Usart0Tx;
  USART0TX.InterruptController -> InterruptControllerC;
  USART1TX = Usart1Tx;
  USART1TX.InterruptController -> InterruptControllerC;
  USART2TX = Usart2Tx;
  USART2TX.InterruptController -> InterruptControllerC;
  TWITX = TwiTx;
  TWITX.InterruptController -> InterruptControllerC;
  SPITX = SpiTx;
  SPITX.InterruptController -> InterruptControllerC;
}
