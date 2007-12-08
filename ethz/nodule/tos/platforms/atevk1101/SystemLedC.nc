/* $Id$ */

/* @author Mustafa Yuecel <mustafa.yuecel@alumni.ethz.ch> */

configuration SystemLedC
{
  provides interface SystemLed;
}
implementation
{
  components SystemLedP;
  SystemLed = SystemLedP;

  components PlatformSystemLedC;
  SystemLedP.Init <- PlatformSystemLedC.Init;
  SystemLedP.Led -> PlatformSystemLedC.Led;
}
