/*
  The SKEL application
*/

module SkelC
{
  uses interface Boot;
}
implementation
{
  event void Boot.booted()
  {
   1;
  }
}
