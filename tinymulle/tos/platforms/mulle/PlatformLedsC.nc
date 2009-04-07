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
  uses interface Init;
}
implementation
{
  components HplM16c62pGeneralIOC as IO;
  components PlatformP;

  Init = PlatformP.SubInit;

  Led0 = IO.PortP36;  // Pin P3_6 = Red LED
  Led1 = IO.PortP37;  // Pin P3_7 = Green LED
  Led2 = IO.PortP34;  // External LED, supplied by user.
}
