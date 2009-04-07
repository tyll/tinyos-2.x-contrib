/**
 * Mulle platform-specific LED interface.
 *
 * @author Henrik Makitaavola
 */
configuration PlatformLedsC
{
  provides interface GeneralIO as Led0;
  provides interface GeneralIO as Led1;
  provides interface GeneralIO as Led2;
  provides interface GeneralIO as Led3;
  provides interface GeneralIO as Led4;

  
  uses interface Init;
}
implementation
{
  components HplM16c62pGeneralIOC as IO;
  components PlatformP;

  Init = PlatformP.SubInit;
    
    //on board LED'S
  Led0 = IO.PortP36;  // Pin P3_6 = Red LED
  Led1 = IO.PortP37;  // Pin P3_7 = Green LED
    //external leds
  Led2 = IO.PortP80;  // Red.
  Led3 = IO.PortP13;  // Green
  Led4 = IO.PortP26;  // Blue
}
