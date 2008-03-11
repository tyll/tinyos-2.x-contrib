/* $Id$ */

/* @author Mustafa Yuecel <mustafa.yuecel@alumni.ethz.ch> */

configuration InterruptControllerC
{
  provides {
    interface Init;
    interface InterruptController;
  }
}
implementation
{
  components InterruptControllerP;
  InterruptControllerP = InterruptController;
  InterruptControllerP = Init;
}
