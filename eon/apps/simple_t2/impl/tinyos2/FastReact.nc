configuration FastReact
{
  provides
  {
    interface StdControl;
    interface IFastReact;
  }
}
implementation
{
  components FastReactM;
  components MainC, LedsC;

  MainC.SoftwareInit->FastReactM.Init;
  StdControl = FastReactM.StdControl;
  IFastReact = FastReactM.IFastReact;
  
  FastReactM.Leds -> LedsC;
}
