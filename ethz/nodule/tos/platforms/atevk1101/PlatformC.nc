/* $Id$ */

/* @author Mustafa Yuecel <mustafa.yuecel@alumni.ethz.ch> */

configuration PlatformC
{
  provides interface Init;
}
implementation
{
  components PlatformP, InterruptControllerC;
  Init = PlatformP;
  PlatformP.InterruptInit -> InterruptControllerC;
}
