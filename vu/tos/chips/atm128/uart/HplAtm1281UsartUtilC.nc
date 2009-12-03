module HplAtm1281UsartUtilC {
  uses interface HplAtm1281Usart as Hpl;
  provides interface HplAtm1281UsartUtil as Util;
}
implementation {

  async command bool Util.isRxComplete() {
    return (call Hpl.getUCSRA()).bits.rxc;
  }

  async command bool Util.isTxInProgress() {
    return !(call Hpl.getUCSRA()).bits.udre;
  }

  async command bool Util.isRxOrTxInProgress() {
    Atm1281UartControlA_t ucsra = call Hpl.getUCSRA();
    return (!ucsra.bits.udre || ucsra.bits.rxc);
  }

  async command uint8_t Util.getRxErrorFlags() {
    // TODO: return ucsra masked to show the error bits only
    // TODO: supply enum values to decode error code
    Atm1281UartControlA_t ucsra = call Hpl.getUCSRA();
//    return (ucsra.bits.fe << 2 || ucsra.bits.dor << 1 || ucsra.bits.upe);
    return ucsra.flat & 0x1c;
  }

  async command void Util.flushRxBuffer() {
    while ( call Util.isRxComplete() ) {
      call Hpl.readBuf();
    }
  }

  async command void Util.enableRxCompleteInterrupt() {
        Atm1281UartControlB_t ucsrb;
        ucsrb = call Hpl.getUCSRB();
        ucsrb.bits.rxcie = 1; // enable rx complete interrupt
        call Hpl.setUCSRB(ucsrb);
  }

  async command void Util.disableRxCompleteInterrupt() {
        Atm1281UartControlB_t ucsrb;
        ucsrb = call Hpl.getUCSRB();
        ucsrb.bits.rxcie = 0; // disable rx complete interrupt
        call Hpl.setUCSRB(ucsrb);
  }

  async command bool Util.isRxCompleteInterruptEnabled() {
        Atm1281UartControlB_t ucsrb;
        ucsrb = call Hpl.getUCSRB();
        return ucsrb.bits.rxcie == 1;
  }

  async command void Util.enableTxBufferEmptyInterrupt() {
        Atm1281UartControlB_t ucsrb;
        ucsrb = call Hpl.getUCSRB();
        ucsrb.bits.udrie = 1;  // enable tx buffer empty interrupt
        call Hpl.setUCSRB(ucsrb);
  }

  async command void Util.disableTxBufferEmptyInterrupt() {
        Atm1281UartControlB_t ucsrb;
        ucsrb = call Hpl.getUCSRB();
        ucsrb.bits.udrie = 0;  // disable tx buffer empty interrupt
        call Hpl.setUCSRB(ucsrb);
  }

  async command bool Util.isTxBufferEmptyInterruptEnabled() {
        Atm1281UartControlB_t ucsrb;
        ucsrb = call Hpl.getUCSRB();
        return ucsrb.bits.udrie == 1;
  }

  async command void Util.tx(uint8_t b) {
    call Hpl.writeBuf(b);
  }

  async event void Hpl.txComplete() {}
  async event void Hpl.rxComplete() {}
  async event void Hpl.dataRegisterEmpty() {}

}
