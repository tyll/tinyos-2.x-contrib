configuration DoBlink
{
  provides
  {
    interface StdControl;
    interface IDoBlink;
  }
}
implementation
{
  components DoBlinkM, LedsC as Leds;

  StdControl = DoBlinkM.StdControl;
  IDoBlink = DoBlinkM.IDoBlink;
  
  DoBlinkM.Leds -> Leds.Leds;
}
