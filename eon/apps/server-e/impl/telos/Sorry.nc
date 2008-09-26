configuration Sorry
{
  provides
  {
    interface StdControl;
    interface ISorry;
  }
}
implementation
{
  components SorryM, LedsC as Leds, RadioComm;

  StdControl = SorryM.StdControl;
  ISorry = SorryM.ISorry;
  SorryM.Leds -> Leds;
  SorryM.SendMsg -> RadioComm.SendMsg[AM_METAMSG];
}
