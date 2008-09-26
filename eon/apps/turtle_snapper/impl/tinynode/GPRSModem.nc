

configuration GPRSModem
{
	provides
	{
		interface StdControl;
		interface GPRS;
	}
}
implementation
{
  components GPRSModemM, TimerC, HPLUARTC;
  components NoLeds as Leds; 

  StdControl = TimerC.StdControl;
  StdControl = GPRSModemM.StdControl;
  
  GPRS = GPRSModemM.GPRS;
  GPRSModemM.HPLUART -> HPLUARTC;

  GPRSModemM.Timer -> TimerC.Timer[unique("Timer")];
  GPRSModemM.OKTimer -> TimerC.Timer[unique("Timer")];
  GPRSModemM.Leds -> Leds;
}
