
/**
 * @author David Moss
 */

generic configuration HplCC2420SpiC() {
  
  provides interface Resource;
  provides interface SpiByte;
  provides interface SpiPacket;
  
}

implementation {

  components DummySpiP,
    TestSpiArbitrationP;
  
  Resource = TestSpiArbitrationP.PlatformSpiResource;
  
  SpiByte = DummySpiP;
  SpiPacket = DummySpiP;
  
}

