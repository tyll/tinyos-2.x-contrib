interface SpiControl
{
  async command void enableSpi();
  async command void disableSpi();
  async command bool isSpi();
}
