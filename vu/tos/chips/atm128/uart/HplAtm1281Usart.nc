#include "Atm128Usart.h"
interface HplAtm1281Usart {
  async command Atm1281UartControlA_t getUCSRA();

  async command void setUCSRA(Atm1281UartControlA_t ucsra);

  // get and set control register B
  async command Atm1281UartControlB_t getUCSRB();

  async command void setUCSRB(Atm1281UartControlB_t ucsrb);

  // get and set control register C
  async command Atm1281UartControlC_t getUCSRC();

  async command void setUCSRC(Atm1281UartControlC_t ucsrc);

  // get and set baud rate register
  async command Atm128UartBaudRate_t getUBRR();

  async command void setUBRR(Atm128UartBaudRate_t ubrr);

  // read and write transmit/receive buffer
  async command uint8_t readBuf();

  async command void writeBuf(uint8_t data);

  async command void enable();

  async command void disable();

  async command void setXCK();

  async command void clrXCK();

  async event void txComplete();
  async event void rxComplete();
  async event void dataRegisterEmpty();

}
