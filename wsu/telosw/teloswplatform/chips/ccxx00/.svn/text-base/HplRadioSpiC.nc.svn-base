

configuration HplRadioSpiC {
  
  provides interface Resource;
  provides interface SpiByte;
  provides interface SpiPacket;
  
}

implementation {

  components new Msp430Spi0C() as SpiC;
  Resource = SpiC;
  SpiByte = SpiC;
  SpiPacket = SpiC;

}

