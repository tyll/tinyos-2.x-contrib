module Mrf24SpiCtrlC
{
  provides interface Mrf24SpiCtrl as SpiCtrl;
  uses interface Atm328Spi as Spi;
}
implementation
{
  async command void SpiCtrl.beginPacket()
  {
    call Spi.enableSs(TRUE);
  }

  async command void SpiCtrl.endPacket()
  {
    call Spi.enableSs(FALSE);
  }

  async event void Spi.dataReady(uint8_t data) { }
}
