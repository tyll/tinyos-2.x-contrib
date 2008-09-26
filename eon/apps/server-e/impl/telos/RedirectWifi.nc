includes ServerE;

configuration RedirectWifi
{
  provides
  {
    interface StdControl;
    interface IRedirectWifi;
  }
  
}
implementation
{
  components RedirectWifiM, RadioComm, LedsC as Leds;

  StdControl = RedirectWifiM.StdControl;
  IRedirectWifi = RedirectWifiM.IRedirectWifi;
  
  RedirectWifiM.SendMsg -> RadioComm.SendMsg[AM_REDIRECTMSG];
  RedirectWifiM.Leds -> Leds;
}
