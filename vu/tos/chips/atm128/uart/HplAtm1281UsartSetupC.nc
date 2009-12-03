module HplAtm1281UsartSetupC {
  uses interface HplAtm1281Usart as Hpl;
  provides interface HplAtm1281UsartSetup as Setup;
}
implementation {

  async command void Setup.setMode(uint8_t mode, uint8_t charSize, uint8_t parity, uint8_t stopBits) {
    Atm1281UartControlA_t ucsra = call Hpl.getUCSRA();
    Atm1281UartControlC_t ucsrc = call Hpl.getUCSRC();
    uint8_t xck = 0;

    switch (mode) {
      case ATM128_UART_MODE_NORMAL_ASYNC:
        // set async
        ucsrc.bits.umsel = 0;

        // clear double speed
        ucsra.bits.u2x = 0;
        break;

      case ATM128_UART_MODE_DOUBLE_SPEED_ASYNC:
        // set async
        ucsrc.bits.umsel = 0;

        // set double speed
        ucsra.bits.u2x = 1;
        break;

      case ATM128_UART_MODE_MASTER_SYNC:
        // set sync
        ucsrc.bits.umsel = 1;

        // set master sync
        xck = 1;

        // clear double speed
        ucsra.bits.u2x = 0;
        break;

      case ATM128_UART_MODE_SLAVE_SYNC:
        // set sync
        ucsrc.bits.umsel = 1;

        // set slave sync
        xck = 0;

        // clear double speed
        ucsra.bits.u2x = 0;
        break;

      default:
    }

    switch (charSize) {
      case ATM128_UART_DATA_SIZE_5_BITS:
        ucsrc.bits.ucsz = 0;
        break;
      case ATM128_UART_DATA_SIZE_6_BITS:
        ucsrc.bits.ucsz = 1;
        break;
      case ATM128_UART_DATA_SIZE_7_BITS:
        ucsrc.bits.ucsz = 2;
        break;
      case ATM128_UART_DATA_SIZE_8_BITS:
        ucsrc.bits.ucsz = 3;
        break;
      default:
    }

    switch (parity) {
      case ATM128_UART_PARITY_NONE:
        ucsrc.bits.upm = 0;
        break;
      case ATM128_UART_PARITY_EVEN:
        ucsrc.bits.upm = 2;
        break;
      case ATM128_UART_PARITY_ODD:
        ucsrc.bits.upm = 3;
        break;
      default:
    }

    switch (stopBits) {
      case ATM128_UART_STOP_BITS_ONE:
        ucsrc.bits.usbs = 0;
        break;
      case ATM128_UART_STOP_BITS_TWO:
        ucsrc.bits.usbs = 1;
        break;
      default:
    }

    if(xck) call Hpl.setXCK();
      else call Hpl.clrXCK();

    call Hpl.setUCSRA(ucsra);
    call Hpl.setUCSRC(ucsrc);
  }

  async command uint32_t Setup.computeBaudRate(uint8_t mode, uint32_t f_osc, uint16_t ubrr) {
    switch (mode) {
      case ATM128_UART_MODE_NORMAL_ASYNC:
        return f_osc/(16 * (ubrr + 1));

      case ATM128_UART_MODE_DOUBLE_SPEED_ASYNC:
        return f_osc/(8 * (ubrr + 1));

      case ATM128_UART_MODE_MASTER_SYNC:
        return f_osc/(2 * (ubrr + 1));

      case ATM128_UART_MODE_SLAVE_SYNC:
        return f_osc/4; // returning the max possible, actual baud rate depends on master

      default:
        return 0;
    }
  }

  async command uint16_t Setup.computeUBRR(uint8_t mode, uint32_t f_osc, uint32_t baudRate) {
    switch (mode) {
      case ATM128_UART_MODE_NORMAL_ASYNC:
        return f_osc/(16 * baudRate) - 1;

      case ATM128_UART_MODE_DOUBLE_SPEED_ASYNC:
        return f_osc/(8 * baudRate) - 1;

      case ATM128_UART_MODE_MASTER_SYNC:
        return f_osc/(2 * baudRate) - 1;

      case ATM128_UART_MODE_SLAVE_SYNC:
        return 0; // no need to set

      default:
        return 0;
    }
  }

  async command uint16_t Setup.computeByteTimeMicro(uint8_t mode, uint8_t charSize, uint8_t parity, uint8_t stopBits, uint32_t baudRate) {
    uint16_t byteTime;
    uint8_t frameSize; // number of bits in frame

    frameSize = 1; // start bit

    // add character size to frameSize
    switch (charSize) {
      case ATM128_UART_DATA_SIZE_5_BITS:
        frameSize += 5;
        break;
      case ATM128_UART_DATA_SIZE_6_BITS:
        frameSize += 6;
        break;
      case ATM128_UART_DATA_SIZE_7_BITS:
        frameSize += 7;
        break;
      case ATM128_UART_DATA_SIZE_8_BITS:
        frameSize += 8;
        break;
      default:
    }

    // add parity
    switch (parity) {
      case ATM128_UART_PARITY_EVEN:
        frameSize++;
        break;
      case ATM128_UART_PARITY_ODD:
        frameSize++;
        break;
      default:
    }

    // add stop bits
    switch (stopBits) {
      case ATM128_UART_STOP_BITS_ONE:
        frameSize++;
        break;
      case ATM128_UART_STOP_BITS_TWO:
        frameSize += 2;
        break;
      default:
    }

    // calculate
    byteTime = 1000000*frameSize/baudRate;

    if (mode == ATM128_UART_MODE_DOUBLE_SPEED_ASYNC)
        byteTime >>= 1;

    return byteTime;
  }
  
  async event void Hpl.txComplete() {}
  async event void Hpl.rxComplete() {}
  async event void Hpl.dataRegisterEmpty() {}
  
}
