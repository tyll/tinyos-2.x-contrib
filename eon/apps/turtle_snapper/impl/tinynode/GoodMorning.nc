configuration GoodMorning
{
  provides
  {
    interface StdControl;
    interface IGoodMorning;
	interface Calib;
  }
}
implementation
{
  components GoodMorningM, TimerC, SolarSrc;

  StdControl = GoodMorningM.StdControl;
  Calib = GoodMorningM.Calib;
  
  IGoodMorning = GoodMorningM.IGoodMorning;
  GoodMorningM.Timer -> TimerC.Timer[unique("Timer")];
  GoodMorningM.IDayNight -> SolarSrc.IDayNight;
}
