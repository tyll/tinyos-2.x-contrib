configuration GeneralIOTestAppC {}
implementation
{
  components MainC, ConsoleC, GeneralIOTestC, Hcs08GeneralIOC;
  components new TimerMilliC() as Timer;
  
  GeneralIOTestC.Boot -> MainC.Boot;
  ConsoleC <- GeneralIOTestC.In;
  ConsoleC <- GeneralIOTestC.Out;
  ConsoleC.StdControl <- GeneralIOTestC.ConsoleControl;
  GeneralIOTestC.Led -> Hcs08GeneralIOC.PortD0;
  GeneralIOTestC.GpIn -> Hcs08GeneralIOC.PortA2;
  GeneralIOTestC.Timer -> Timer;
}