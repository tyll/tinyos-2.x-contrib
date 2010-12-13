/**
 * Wiring component
 * 
 * </br> KTH | Royal Institute of Technology
 * </br> Automatic Control
 *
 * @author Aitor Hernandez <aitorhh@kth.se>
 * @version $Revision$ $Date$
 * 
 */
configuration LS7366RSpiWireC {
  
  provides interface Resource[ uint8_t id ];
  provides interface ChipSpiResource;
  provides interface LS7366RRegister as Reg[ uint8_t id ];
  provides interface LS7366RStrobe as Strobe[ uint8_t id ];

}

implementation {

  components LS7366RSpiP as SpiP;
  Resource = SpiP;
  Reg = SpiP;
  Strobe = SpiP;

  ChipSpiResource = SpiP;

  components new StateC() as WorkingStateC;
  SpiP.WorkingState -> WorkingStateC;
  
  components new HplLS7366RSpiC();
  SpiP.SpiResource -> HplLS7366RSpiC;
  SpiP.SpiByte -> HplLS7366RSpiC;

  components LedsC;
  SpiP.Leds -> LedsC;

}
