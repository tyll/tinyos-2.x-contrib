#include "Atm128Usart.h"
module HplAtm1281Usart0C {
  provides interface HplAtm1281Usart as Hpl;
}
implementation {
  // get and set control register A
  async command Atm1281UartControlA_t Hpl.getUCSRA() {
    return (Atm1281UartControlA_t)UCSR0A;
  }

  async command void Hpl.setUCSRA(Atm1281UartControlA_t ucsra) {
    UCSR0A = ucsra.flat;
  }

  // get and set control register B
  async command Atm1281UartControlB_t Hpl.getUCSRB() {
    return (Atm1281UartControlB_t)UCSR0B;
  }

  async command void Hpl.setUCSRB(Atm1281UartControlB_t ucsrb) {
    UCSR0B = ucsrb.flat;
  }

  // get and set control register C
  async command Atm1281UartControlC_t Hpl.getUCSRC() {
    return (Atm1281UartControlC_t)UCSR0C;
  }

  async command void Hpl.setUCSRC(Atm1281UartControlC_t ucsrc) {
    UCSR0C = ucsrc.flat;
  }

  // get and set baud rate register
  async command Atm128UartBaudRate_t Hpl.getUBRR() {
    return (Atm128UartBaudRate_t) (UBRR0L + (UBRR0H << 8));
  }

  async command void Hpl.setUBRR(Atm128UartBaudRate_t ubrr) {
    UBRR0L = (uint16_t)ubrr & 0xff;
    UBRR0H = ((uint16_t)ubrr >> 8) & 0x0f;
  }

  // read and write transmit/receive buffer
  async command uint8_t Hpl.readBuf() {
    return UDR0;
  }

  async command void Hpl.writeBuf(uint8_t data) {
    UDR0 = data;
  }

  async command void Hpl.enable() {
#if defined(PLATFORM_IRIS)
    // clear PRUSART0 in power reduction register 0
    CLR_BIT(PRR0,PRUSART0);
#endif
  }

  async command void Hpl.disable() {
#if defined(PLATFORM_IRIS)  	
    // set PRUSART0 in power reduction register 0
    SET_BIT(PRR0,PRUSART0);
#endif    
  }

  async command void Hpl.setXCK() {
    // enable sync clock on XCK0_DDR pin
    SET_BIT(DDRE, DDE2);
  }

  async command void Hpl.clrXCK() {
    // disable sync clock on XCK0_DDR pin
    CLR_BIT(DDRE, DDE2);
  }

  AVR_ATOMIC_HANDLER(SIG_USART0_TRANS) {
    signal Hpl.txComplete();
  }

  AVR_ATOMIC_HANDLER(SIG_USART0_RECV) {
      signal Hpl.rxComplete();
  }

  AVR_ATOMIC_HANDLER(SIG_USART0_DATA) {
      signal Hpl.dataRegisterEmpty();
  }

  default async event void Hpl.txComplete() {}
  default async event void Hpl.rxComplete() {}
  default async event void Hpl.dataRegisterEmpty() {}

}
