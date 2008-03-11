/* $Id$ */

/* @author Mustafa Yuecel <mustafa.yuecel@alumni.ethz.ch> */

configuration PowerManagerC
{
  provides interface PowerManager;
}
implementation
{
  components PowerManagerP;
  PowerManagerP = PowerManager;
}
