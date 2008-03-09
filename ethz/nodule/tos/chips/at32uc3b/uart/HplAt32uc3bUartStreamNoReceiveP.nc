/* $Id$ */

/* @author Mustafa Yuecel <mustafa.yuecel@alumni.ethz.ch> */

#include "at32uc3b.h"

generic module HplAt32uc3bUartStreamNoReceiveP(uint32_t USART)
{
  provides {
    interface Init;
    interface UartStream;
  }
  uses {
    interface HplAt32uc3bGeneralIO as Tx;
    interface InterruptController;
    interface PeripheralDmaController as DmaTx;
  }
}
implementation
{
  uint8_t * buffer;
  uint16_t length;

  void __attribute__((interrupt, section(".interrupt"))) _usart_interrupt_handler() {
    error_t status;
    uint8_t * buf;
    uint16_t len;

    // disable USART interrupt (TXEMPTY)
    get_register(get_avr32_usart_baseaddress(USART) + AVR32_USART_IDR) = (1 << AVR32_USART_IDR_TXEMPTY_OFFSET);

    // stop USART clock
    get_register(AVR32_PM_ADDRESS + AVR32_PM_PBAMASK) &= ~(1 << (get_avr32_usart_pbamask_offset(USART)));

    atomic {
      buf = buffer;
      len = length - call DmaTx.getTransferCounter();
    }

    status = call DmaTx.shutdownTransaction();

    signal UartStream.sendDone(buf, len, status);
  }

  inline void register_usart_interrupt_handler() {
    call InterruptController.registerUsartInterruptHandler(USART, &_usart_interrupt_handler);
  }

  command error_t Init.init() {
    // setup GPIO pins (no hardware flow control -> only RX/TX)
    call Tx.selectPeripheralFunc(get_avr32_usart_peripheral_function(USART));
    call Tx.disablePullup();

    // start USART clock
    get_register(AVR32_PM_ADDRESS + AVR32_PM_PBAMASK) |= (1 << (get_avr32_usart_pbamask_offset(USART)));

    // setup USART

    // USART Mode Register (MR)
    get_register(get_avr32_usart_baseaddress(USART) + AVR32_USART_MR) = ((AVR32_USART_MODE_NORMAL << AVR32_USART_MODE_OFFSET) | 
                                                                         (AVR32_USART_USCLKS_MCK << AVR32_USART_USCLKS_OFFSET) | 
                                                                         (AVR32_USART_CHRL_8 << AVR32_USART_CHRL_OFFSET) | 
                                                                         (0 << AVR32_USART_SYNC_OFFSET) | 
                                                                         (AVR32_USART_PAR_ODD << AVR32_USART_PAR_OFFSET) | 
                                                                         (AVR32_USART_NBSTOP_1 << AVR32_USART_NBSTOP_OFFSET) | 
                                                                         (AVR32_USART_MSBF_LSBF << AVR32_USART_MSBF_OFFSET) | 
                                                                         (0 << AVR32_USART_MODE9_OFFSET) | 
                                                                         (0 << AVR32_USART_CLKO_OFFSET) | 
                                                                         (AVR32_USART_OVER_X8 << AVR32_USART_OVER_OFFSET) | 
                                                                         (0 << AVR32_USART_INACK_OFFSET) | 
                                                                         (0 << AVR32_USART_DSNACK_OFFSET) | 
                                                                         (0 << AVR32_USART_VAR_SYNC_OFFSET) | 
                                                                         (0 << AVR32_USART_MAX_ITERATION_OFFSET) | 
                                                                         (0 << AVR32_USART_FILTER_OFFSET) | 
                                                                         (0 << AVR32_USART_MAN_OFFSET) |
                                                                         (0 << AVR32_USART_MODSYNC_OFFSET) |
                                                                         (0 << AVR32_USART_ONEBIT_OFFSET)); 

    // USART Transmitter Timeguard Register (TTGR)
    // improves data integrity on slow devices
    get_register(get_avr32_usart_baseaddress(USART) + AVR32_USART_TTGR) = 32;

    // USART Baud Rate Generator Register (BRGR)
    //   BAUDRATE = USCLKS / (8*(2-OVER)*CD) = 115200 / 24 = 4800, USCLKS = MSK = AVR32_PM_RCOSC_FREQUENCY = 115200, OVER = 1, CD = 3
    get_register(get_avr32_usart_baseaddress(USART) + AVR32_USART_BRGR) = ((3 << AVR32_USART_BRGR_CD_OFFSET) | 
                                                                           (0 << AVR32_USART_BRGR_FP_OFFSET));

    // USART Control Register (CR)
    // enable TX
    get_register(get_avr32_usart_baseaddress(USART) + AVR32_USART_CR) = (1 << AVR32_USART_CR_TXEN_OFFSET);

    // stop USART clock
    get_register(AVR32_PM_ADDRESS + AVR32_PM_PBAMASK) &= ~(1 << (get_avr32_usart_pbamask_offset(USART)));

    register_usart_interrupt_handler();

    return SUCCESS;
  }

  async command error_t UartStream.send(uint8_t * buf, uint16_t len) {
    atomic {
      buffer = buf;
      length = len;
    }

    // start USART clock
    get_register(AVR32_PM_ADDRESS + AVR32_PM_PBAMASK) |= (1 << (get_avr32_usart_pbamask_offset(USART)));

    call DmaTx.startupTransaction((void *) buf, len, FALSE);

    // enable USART interrupt (TXEMPTY)
    get_register(get_avr32_usart_baseaddress(USART) + AVR32_USART_IER) = (1 << AVR32_USART_IER_TXEMPTY_OFFSET);

    //// write 'hello world' into USART Transmit Holding Register (THR)
    //while (len > 0)
    //{
    //  get_register(get_avr32_usart_baseport(USART) + AVR32_USART_THR) = *buf;
    //  buf++;
    //  len--;
    //  delay(300);
    //}

    return SUCCESS;
  }
  default async event void UartStream.sendDone(uint8_t * buf, uint16_t len, error_t error) { }

  async command error_t UartStream.enableReceiveInterrupt() {
    // leave unimplemented
    return SUCCESS;
  }
  async command error_t UartStream.disableReceiveInterrupt() {
    // leave unimplemented
    return SUCCESS;
  }
  default async event void UartStream.receivedByte(uint8_t byte) { }

  async command error_t UartStream.receive(uint8_t * buf, uint16_t len) {
    // leave unimplemented
    return SUCCESS;
  }
  default async event void UartStream.receiveDone(uint8_t * buf, uint16_t len, error_t error) { }
}
